{ pkgs, ... }:
{
  users.groups = {
    media = {
      gid = 1000;
    };
    paperless = {};
  };

  # Create per-service users with shared group
  users.users = {
    radarr = {
      isNormalUser = true;
      uid = 1001;
      group = "media";
    };
    sonarr = {
      isNormalUser = true;
      uid = 1002;
      group = "media";
    };
    lidarr = {
      isNormalUser = true;
      uid = 1003;
      group = "media";
    };
    sabnzbd = {
      isNormalUser = true;
      uid = 1004;
      group = "media";
    };
    jellyfin = {
      isNormalUser = true;
      uid = 1005;
      group = "media";
    };
    paperless = {
      isNormalUser = true;
      uid = 1006;
      group = "paperless";
    };
  };
  # Ensure media directory ownership & permissions
#  environment.etc."media-permissions.sh".text = ''
#    chown -R root:media /srv/data1tb/data
#    chmod -R 2775 /srv/data1tb/data
#  '';

}