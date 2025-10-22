{ config, pkgs, ... }:
{
  containers.dnsmasq = {
    autoStart = true;
    privateNetwork = false;
    hostAddress = "192.168.100.100";
    localAddress = "192.168.100.101";

    config = { pkgs, ... }: {
      services.dnsmasq = {
        enable = true;
        settings = {
          # Listen on all interfaces
          interface = "enp1s0";
          bind-interfaces = true;

          # Local DNS entries for your containers
          address = [
            "/paperless.local/192.168.100.11"
            "/kavita.local/192.168.100.21"
            "/jellyfin.local/192.168.100.31"
          ];

          # Upstream resolvers
          server = [
            "9.9.9.9"
            "1.1.1.1"
          ];

          # Optionally, make short names work via search
          domain = "local";
          expand-hosts = true;
          local-ttl = 60;
        };
      };

      # Open port 53 for DNS
      networking.firewall.allowedTCPPorts = [ 53 ];
      networking.firewall.allowedUDPPorts = [ 53 ];
    };
  };
}
