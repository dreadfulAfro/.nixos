{ hostname, ... }:
{
  containers.caddy = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br-shared"; # Connect to the shared bridge
    localAddress = "10.10.10.2/24"; # Caddy's IP on the shared network

    bindMounts = {
      "caddy-data" = {
        hostPath = "/srv/data1tb/caddy";
        mountPoint = "/var/lib/caddy";
        isReadOnly = false;
      };
    };

    config =
      { pkgs, ... }:
      {
        services.caddy = {
          enable = true;

          virtualHosts = {
            "paperless.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 10.10.10.11:42001 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}
                } 
              '';
            };
            "kavita.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 10.10.10.21:42002 {
                  header_up Host {upstream_hostport}
                }
              '';
            };
            "jellyfin.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 10.10.10.91:8096 {
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
                reverse_proxy 10.10.10.91:7878 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}
                }
              '';
            };
            "sonarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 10.10.10.91:8989 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}
                }
              '';
            };
            "bazarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 10.10.10.91:6767 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}
                }
              '';
            };
            "lidarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 10.10.10.91:8686 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}
                }
              '';
            };
            "prowlarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 10.10.10.91:9696 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}
                }
              '';
            };
            "readarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 10.10.10.91:8787 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}
                }
              '';
            };
            "mediathekarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 10.10.10.50:5007
              '';
            };
            "sabnzbd.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 10.10.10.91:6336 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}
                }
              '';
            };
            "transmission.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 10.10.10.91:9091 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}
                }
              '';
            };
            "jellyseerr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 10.10.10.91:5055 {
                  header_up Host {upstream_hostport}
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-For {remote_host}
                  header_up X-Forwarded-Proto {scheme}
                  header_up X-Forwarded-Host {host}
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
