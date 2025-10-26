{ pkgs, ... }:
{
  containers.jellyfin = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.30";
    localAddress = "192.168.100.31";
    hostAddress6 = "fc00::30";
    localAddress6 = "fc00::31";

    bindMounts = {
      "jellyfin" = {
        hostPath = "/srv/data1tb/jellyfin";
        mountPoint = "/media/jellyfin";
        isReadOnly = false;
      };
    };

    config =
      { pkgs, ... }:
      {
        services.jellyfin = {
          enable = true;
          openFirewall = true;
          dataDir = "/media/jellyfin/data";
          logDir = "/media/jellyfin/logs";
        };

        system.stateVersion = "25.05";
      };
  };
}
