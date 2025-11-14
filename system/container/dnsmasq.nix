{ config, pkgs, ... }:
{
  containers.dnsmasq = {
    autoStart = true;
    privateNetwork = true;
    #hostAddress = "192.168.100.3";
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
              "/paperless.tails/192.168.178.57" # Changed from 192.168.100.2
              "/kavita.tails/192.168.178.57"
              "/jellyfin.tails/192.168.178.57"
              "/radarr.tails/192.168.178.57"
              "/sonarr.tails/192.168.178.57"
              "/bazarr.tails/192.168.178.57"
              "/lidarr.tails/192.168.178.57"
              "/prowlarr.tails/192.168.178.57"
              "/readarr.tails/192.168.178.57"
              "/sabnzbd.tails/192.168.178.57"
              "/transmission.tails/192.168.178.57"
              "/mediathekarr.tails/192.168.178.57"
              "/jellyseerr.tails/192.168.178.57"
            ];

            server = [
              "9.9.9.9"
              "1.1.1.1"
            ];

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
