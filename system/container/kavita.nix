{ pkgs, ... }:
{
  containers.kavita = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.20";
    localAddress = "192.168.100.21";
    hostAddress6 = "fc00::20";
    localAddress6 = "fc00::21";

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

        networking.firewall = {
          enable = true;
          allowedTCPPorts = [ 42002 ];
        };

        system.stateVersion = "25.05";
      };
  };
}