{ pkgs, ... }:
{
  containers.paperless = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.30";
    localAddress = "192.168.100.31";
    hostAddress6 = "fc00::20";
    localAddress6 = "fc00::21";

    bindMounts = {
      "jellyfin" = {
        hostPath = "/srv/data1tb/jellyfin";
        mountPoint = "/jellyfin";
        isReadOnly = false;
      };
    };

    config =
      { pkgs, ... }:
      {
        services.jellyfin = {
          enable = true;
          openFirewall = true;
          dataDir = "/jellyfin/data";
          logDir = "/jellyfin/logs";
        };

        system.stateVersion = "25.05";
      };
  };
}