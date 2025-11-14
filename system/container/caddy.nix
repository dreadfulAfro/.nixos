{ hostname, ... }:
{
  containers.caddy = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br-shared"; # Connect to the shared bridge
    localAddress = "192.168.100.2/24"; # Caddy's IP on the shared network

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
        networking.defaultGateway = {
          address = "192.168.100.1";
          interface = "eth0";
        };
        services.caddy = {
          enable = true;

          virtualHosts = {
            "paperless.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.11:42001 
              '';
            };
            "kavita.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.21:42002 
              '';
            };
            "jellyfin.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:8096 
              '';
            };
            "radarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:7878 
              '';
            };
            "sonarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:8989 
              '';
            };
            "bazarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:6767 
              '';
            };
            "lidarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:8686 
              '';
            };
            "prowlarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:9696 
              '';
            };
            "readarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:8787 
              '';
            };
            "mediathekarr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.50:5007
              '';
            };
            "sabnzbd.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:6336 
              '';
            };
            "transmission.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:9091 
              '';
            };
            "jellyseerr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:5055 {
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
