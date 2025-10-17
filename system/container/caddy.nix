{ hostname, ... }:
{
  containers.caddy = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.1";
    localAddress = "192.168.100.2";
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::2";
    forwardPorts = [
      { hostPort = 80; }
      { hostPort = 443; }
    ];

    bindMounts = {
      "caddy-data" = {
        hostPath = "/srv/data1tb/caddy"; # stores certs and config
        mountPoint = "/var/lib/caddy";
        isReadOnly = false;
      };
    };

    config =
      { pkgs, ... }:
      {
        services.caddy = {
          enable = true;
          # Set to true if you want automatic Let's Encrypt certs
          # email = "admin@example.org";

          virtualHosts = {
            "paperless.local" = {
              extraConfig = ''
                @external {
                  not remote_ip 192.168.178.0/24
                }
                respond @external 403
                tls internal
                reverse_proxy 192.168.100.11:28981 {
                  header_up Host {host}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                }
              '';
            };
          };
        };

        networking.firewall.allowedTCPPorts = [
          80
          443
        ];
        system.stateVersion = "25.05";
      };
  };
}
