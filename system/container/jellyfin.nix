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
      "jellyfin_media" = {
        hostPath = "/srv/data1tb/data/media";
        mountPoint = "/data/media";
        isReadOnly = false;
      };
      "jellyfin_config" = {
        hostPath = "/srv/data1tb/jellyfin/config";
        mountPoint = "/jellyfin/config";
        isReadOnly = false;
      };
    };

    config =
      { pkgs, ... }:
      {
        users = {
          groups.media = { gid = 1000; };
          users.jellyfin = {
            isSystemUser = true;
            uid = 1005;
            group = "media";
          };
        };
        services.jellyfin = {
          enable = true;
          openFirewall = true;
          user = "jellyfin";
          group = "media";
          dataDir = "/media";
          logDir = "/jellyfin/config/logs";
        };

        system.stateVersion = "25.05";
      };
  };
}
