{ pkgs, ... }:
{
  users.groups = {
    media = {
      gid = 169;
    };
  };

  # Create per-service users with shared group
  users.users = {
#    nixarr = {
#      isNormalUser = true;
#      uid = 1001;
#      group = "media";
#    };
#    paperless = {
#      isNormalUser = true;
#      uid = 1002;
#      group = "media";
#    };
    mediathekarr = {
      isNormalUser = true;
      uid = 1003;
      group = "media";
    };
  };
  # Ensure media directory ownership & permissions
#  environment.etc."media-permissions.sh".text = ''
#    chown -R root:media /srv/data1tb/data
#    chmod -R 2775 /srv/data1tb/data
#  '';

}