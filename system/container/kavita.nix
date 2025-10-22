{ pkgs, ... }:
{
  containers.paperless = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.20";
    localAddress = "192.168.100.21";
    hostAddress6 = "fc00::20";
    localAddress6 = "fc00::21";

    bindMounts = {
      "paperless" = {
        hostPath = "/srv/data1tb/kavita";
        mountPoint = "/var/lib/kavita";
        isReadOnly = false;
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
        };

        networking.firewall = {
          enable = true;
          allowedTCPPorts = [ 42002 ];
        };

        system.stateVersion = "25.05";
      };
  };
}