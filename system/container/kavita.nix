{ pkgs, ... }:
{
  containers.kavita = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br-shared";
    localAddress = "192.168.100.21/24";

    bindMounts = {
      "kavita" = {
        hostPath = "/srv/data1tb/kavita";
        mountPoint = "/var/lib/kavita";
        isReadOnly = false;
      };
      "key" = {
        hostPath = "/etc/secrets/kavita";
        mountPoint = "/etc/secrets";
      };
    };

    config =
      { pkgs, ... }:
      {
        services.kavita = {
          enable = true;
          settings = {
            IpAddresses = "192.168.100.21";
            Port = 42002;
          };
          dataDir = "/var/lib/kavita";
          tokenKeyFile = "/etc/secrets/token.key";
        };

        # Configure DNS to use dnsmasq on the host
        networking = {
          defaultGateway = {
            address = "192.168.100.1";
            interface = "eth0";
          };
          nameservers = [ "192.168.100.3" ];
          search = [ "tails" ];
          firewall = {
            enable = true;
            allowedTCPPorts = [ 42002 ];
          };
        };

        system.stateVersion = "25.05";
      };
  };
}
