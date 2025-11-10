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
      { hostPort = 80; }   # Add containerPort
      { hostPort = 443; } # Add containerPort
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
            "paperless.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.11:42001 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}                } 
              '';
            };
            "kavita.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.21:42002 {
                  header_up Host {upstream_hostport}
                }
              '';
            };
            "jellyfin.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:8096 {
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}
                }
              '';
            };
            "radarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:7878 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}                }
              '';
            };
            "sonarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:8989 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}                }
              '';
            };
            "bazarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:6767 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}                }
              '';
            };
            "lidarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:8686 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}                }
              '';
            };
            "prowlarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:9696 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}                }
              '';
            };
            "readarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:8787 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}                }
              '';
            };
            "mediathekarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.178.57:5007 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}                }
              '';
            };
            "sabnzbd.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:6336 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}                }
              '';
            };
            "transmission.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:51820 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}                }
              '';
            };
            "jellyseerr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:5055 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}                }
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
