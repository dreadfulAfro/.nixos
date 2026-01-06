{ hostname, ... }:
{
  containers.caddy = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.1";
    localAddress = "192.168.100.2";
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::2";

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
                reverse_proxy 192.168.178.57:42001 
              '';
            };
            "kavita.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.178.57:42002 
              '';
            };
            "jellyfin.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.178.57:8096 
              '';
            };
            "radarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.178.57:7878 
              '';
            };
            "sonarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.178.57:8989 
              '';
            };
            "bazarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.178.57:6767 
              '';
            };
            "lidarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.178.57:8686 
              '';
            };
            "prowlarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.178.57:9696 
              '';
            };
            "readarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.178.57:8787 
              '';
            };
            "mediathekarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.178.57:5007
              '';
            };
            "lazylibrarian.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.178.57:5299
              '';
            };
            "sabnzbd.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.178.57:8080 
              '';
            };
            "transmission.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.178.57:9091 
              '';
            };
            "jellyseerr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.178.57:5055
              '';
            };
            "bookshelf.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.178.57:8787
              '';
            };
            "audiobookrequest.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.178.57:8000
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
