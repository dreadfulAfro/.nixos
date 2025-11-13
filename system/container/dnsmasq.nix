{ config, pkgs, ... }:
{
  containers.dnsmasq = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br-shared";
    localAddress = "10.10.10.3/24";

    config =
      { pkgs, ... }:
      {
        services.dnsmasq = {
          enable = true;
          settings = {
            bind-interfaces = true;
            listen-address = [
              "10.10.10.3"
              "127.0.0.1"
            ];

            # All .tails domains point to Caddy on the shared bridge
            address = [
              "/paperless.tails/10.10.10.2"
              "/kavita.tails/10.10.10.2"
              "/jellyfin.tails/10.10.10.2"
              "/radarr.tails/10.10.10.2"
              "/sonarr.tails/10.10.10.2"
              "/bazarr.tails/10.10.10.2"
              "/lidarr.tails/10.10.10.2"
              "/prowlarr.tails/10.10.10.2"
              "/readarr.tails/10.10.10.2"
              "/sabnzbd.tails/10.10.10.2"
              "/transmission.tails/10.10.10.2"
              "/mediathekarr.tails/10.10.10.2"
              "/jellyseerr.tails/10.10.10.2"
            ];

            server = [
              "9.9.9.9"
              "1.1.1.1"
            ];

            local = "/tails/";
            domain = "tails";
            expand-hosts = true;
            local-ttl = 60;
          };
        };

        networking.firewall.allowedTCPPorts = [ 53 ];
        networking.firewall.allowedUDPPorts = [ 53 ];
        system.stateVersion = "25.05";
      };
  };
}
