{ config, pkgs, ... }:
{
  containers.dnsmasq = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br-shared";
    localAddress = "192.168.100.3";

    config =
      { pkgs, ... }:
      {
        services.dnsmasq = {
          enable = true;
          settings = {
            bind-interfaces = true;
            listen-address = [
              "192.168.100.3"
              "127.0.0.1"
            ];

            # All .tails domains point to Caddy on the shared bridge
            address = [
              "/paperless.tails/192.168.100.2"
              "/kavita.tails/192.168.100.2"
              "/jellyfin.tails/192.168.100.2"
              "/radarr.tails/192.168.100.2"
              "/sonarr.tails/192.168.100.2"
              "/bazarr.tails/192.168.100.2"
              "/lidarr.tails/192.168.100.2"
              "/prowlarr.tails/192.168.100.2"
              "/readarr.tails/192.168.100.2"
              "/sabnzbd.tails/192.168.100.2"
              "/transmission.tails/192.168.100.2"
              "/mediathekarr.tails/192.168.100.2"
              "/jellyseerr.tails/192.168.100.2"
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
