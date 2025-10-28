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
  users.users.sonarr = {
    isNormalUser = true;
    uid = 1002;
    group = "media";
#    home = "/var/lib/sonarr";
#    shell = pkgs.runCommandShell "nologin" {};
  };
  users.users.lidarr = {
    isNormalUser = true;
    uid = 1003;
    group = "media";
#    home = "/var/lib/lidarr";
#    shell = pkgs.runCommandShell "nologin" {};
  };
  users.users.sabnzbd = {
    isNormalUser = true;
    uid = 1004;
    group = "media";
  };
  users.users.jellyfin = {
    isNormalUser = true;
    uid = 1005;
    group = "media";
#    home = "/var/lib/jellyfin";
#    shell = pkgs.runCommandShell "nologin" {};
  };
  users.users.paperless = {
    isNormalUser = true;
    uid = 1006;
    group = "paperless";
  };

  # Ensure media directory ownership & permissions
#  environment.etc."media-permissions.sh".text = ''
#    chown -R root:media /srv/data1tb/data
#    chmod -R 2775 /srv/data1tb/data
#  '';

}