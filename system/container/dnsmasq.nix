{ config, pkgs, ... }:
{
  containers.dnsmasq = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.100";
    localAddress = "192.168.100.101";
    forwardPorts = [
      {
        protocol = "udp";
        hostPort = 53;
        containerPort = 53;
      }
      {
        protocol = "tcp";
        hostPort = 53;
        containerPort = 53;
      }
    ];

    config =
      { pkgs, ... }:
      {
        services.dnsmasq = {
          enable = true;
          settings = {
            # Listen on all interfaces
            bind-interfaces = true;
            listen-address = [
              #              "100.77.114.79"
              "192.168.100.101"
              "127.0.0.1"
            ];

            # Local DNS entries for your containers
            address = [
              "/paperless.tails/192.168.178.57"
              "/kavita.tails/192.168.178.57"
              "/jellyfin.tails/192.168.178.57"
            ];

            # Upstream resolvers
            server = [
              "9.9.9.9"
              "1.1.1.1"
            ];

            # Optionally, make short names work via search
            domain = "tails";
            expand-hosts = true;
            local-ttl = 60;
          };
        };

        # Open port 53 for DNS
        networking.firewall.allowedTCPPorts = [ 53 ];
        networking.firewall.allowedUDPPorts = [ 53 ];

        system.stateVersion = "25.05";
      };
  };
}
