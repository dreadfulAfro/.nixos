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
                reverse_proxy 192.168.178.57:5007
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
                reverse_proxy 192.168.100.91:51820
              '';
            };
            "jellyseerr.tails" = {
              extraConfig = ''
                tls internal
                reverse_proxy 192.168.100.91:5055
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
