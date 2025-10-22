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
            "paperless.local nixos-server.tail194e5d.ts.net/paperless"= {
              extraConfig = ''
                handle_path /paperless/* {}
                tls internal
                reverse_proxy 192.168.100.11:42001 {
                    header_up X-Forwarded-Proto {scheme}
                    header_up Host {host}
                }
              '';
            };
            "kavita.local nixos-server.tail194e5d.ts.net/kavita" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.21:42002 {
                    header_up X-Forwarded-Proto {scheme}
                    header_up Host {host}
                }
              '';
            };
            "jellyfin.local nixos-server.tail194e5d.ts.net/jellyfin" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.31:8096 {
                    header_up X-Forwarded-Proto {scheme}
                    header_up Host {host}
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
