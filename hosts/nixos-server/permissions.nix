{ pkgs, ... }:

let
  mediaGid = 1000;

  radarrUid = 1001;
  sonarrUid = 1002;
  lidarrUid = 1003;
  jellyfinUid = 1004;
in
{
  users.groups.media = {
    gid = 1000;
  };

  # Create per-service users with shared group
  users.users.radarr = {
    uid = 1001;
    group = "media";
#    home = "/var/lib/radarr";
 #   shell = pkgs.runCommandShell "nologin" {};
  };
  users.users.sonarr = {
    uid = 1002;
    group = "media";
#    home = "/var/lib/sonarr";
#    shell = pkgs.runCommandShell "nologin" {};
  };
  users.users.lidarr = {
    uid = 1003;
    group = "media";
#    home = "/var/lib/lidarr";
#    shell = pkgs.runCommandShell "nologin" {};
  };
  users.users.sabnzbd = {
    uid = 1004;
    group = "media";
  };
  users.users.jellyfin = {
    uid = 1005;
    group = "media";
#    home = "/var/lib/jellyfin";
#    shell = pkgs.runCommandShell "nologin" {};
  };
  users.users.paperless = {
    uid = 1006;
  };

  # Ensure media directory ownership & permissions
#  environment.etc."media-permissions.sh".text = ''
#    chown -R root:media /srv/data1tb/data
#    chmod -R 2775 /srv/data1tb/data
#  '';

}