{ pkgs, ... }:
{
  users.groups = {
    media = {
      gid = 169;
    };
  };

  # Create per-service users with shared group
  users.users = {
    dnsmasq  = {
      isNormalUser = true;
      uid = 1101;
      group = "media";
    };
    caddy  = {
      isNormalUser = true;
      uid = 1102;
      group = "media";
    };
    tailscale = {
      isNormalUser = true;
      uid = 1103;
      group = "media";
    };
    jellyfin = {
      isNormalUser = true;
      uid = 1104;
      group = "media";
    };
    mediathekarr = {
      isNormalUser = true;
      uid = 1105;
      group = "media";
    };
    prowlarr = {
      isNormalUser = true;
      uid = 1106;
      group = "media";
    };
    radarr = {
      isNormalUser = true;
      uid = 1108;
      group = "media";
    };
    lidarr = {
      isNormalUser = true;
      uid = 1109;
      group = "media";
    };
    bookshelf  = {
      isNormalUser = true;
      uid = 1110;
      group = "media";
    };
    audiobookrequest  = {
      isNormalUser = true;
      uid = 1111;
      group = "media";
    };
    sabnzbd = {
      isNormalUser = true;
      uid = 1112;
      group = "media";
    };
    kavita = {
      isNormalUser = true;
      uid = 1113;
      group = "media";
    };
    paperless = {
      isNormalUser = true;
      uid = 1114;
      group = "media";
    };
    pinchflat = {
      isNormalUser = true;
      uid = 1115;
      group = "media";
    };
    lazylibrarian = {
      isNormalUser = true;
      uid = 1116;
      group = "media";
    };
    bazarr = {
      isNormalUser = true;
      uid = 1117;
      group = "media";
    };
    jellyseer = {
      isNormalUser = true;
      uid = 1118;
      group = "media";
    };
    readarr = {
      isNormalUser = true;
      uid = 1119;
      group = "media";
    };
    sonarr = {
      isNormalUser = true;
      uid = 1120;
      group = "media";
    };
  };

  ## create directories and set permissions
  systemd.tmpfiles.rules = [
    #Type Path                                  Mode  User              Group             Age Argument
    "d    /srv/data1tb/data                     0755  root              media             -"
    "d    /srv/data1tb/data/usenet              0755  root              media             -"
    "d    /srv/data1tb/data/library             0755  root              media             -"
    "d    /srv/data1tb/data/                     0755  root              media             -"
    "d    /srv/data1tb/data/                     0755  root              media             -"
    "d    /srv/data1tb/data/                     0755  root              media             -"
    "d    /srv/data1tb/data/                     0755  root              media             -"
    "d    /srv/data1tb/data/                     0755  root              media             -"

    "d    /srv/data1tb/.config/dnsmasq          0770  dnsmasq           dnsmasq           -"
    "d    /srv/data1tb/.config/caddy            0770  caddy             caddy             -"
    "d    /srv/data1tb/.config/tailscale        0770  tailscale         tailscale         -"
    "d    /srv/data1tb/.config/jellyfin         0770  jellyfin          jellyfin          -"
    "d    /srv/data1tb/.config/mediathekarr     0770  mediathekarr      mediathekarr      -"
    "d    /srv/data1tb/.config/prowlarr         0770  prowlarr          prowlarr          -"
    "d    /srv/data1tb/.config/radarr           0770  radarr            radarr            -"
    "d    /srv/data1tb/.config/sonarr           0770  sonarr            sonarr            -"
    "d    /srv/data1tb/.config/lidarr           0770  lidarr            lidarr            -"
    "d    /srv/data1tb/.config/bookshelf        0770  bookshelf         bookshelf         -"
    "d    /srv/data1tb/.config/audiobookrequest 0770  audiobookrequest  audiobookrequest  -"
    "d    /srv/data1tb/.config/sabnzbd          0770  sabnzbd           sabnzbd           -"
    "d    /srv/data1tb/.config/kavita           0770  kavita            kavita            -"
    "d    /srv/data1tb/.config/paperless        0770  paperless         paperless         -"
    "d    /srv/data1tb/.config/pinchflat        0770  pinchflat         pinchflat         -"
  ];
}