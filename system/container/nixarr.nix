{pkgs, inputs,  ...}:
{
  containers.nixarr = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.90";
    localAddress = "192.168.100.91";
    hostAddress6 = "fc00::30";
    localAddress6 = "fc00::31";

    bindMounts = {
      "media" = {
        hostPath = "/srv/data1tb/data";
        mountPoint = "/data";
        isReadOnly = false;
      };
      "config" = {
        hostPath = "/srv/data1tb/nixarr";
        mountPoint = "/config";
        isReadOnly = false;
      };
    };

    specialArgs = { nixarrInput = inputs.nixarr; };

    config = { pkgs, nixarrInput, ... }: {
      imports = [ nixarrInput.nixosModules.default ];
      nixpkgs.config.allowUnfree = true;

#        use145329rs = {
#          groups.media = { gid = 1000; };
#          users.nixaarr = {
#            isSystemUser = true;
#            uid = 1001;
#            group = "media";
#          };
#        };
        nixarr = {
          enable = true;
          # These two values are also the default, but you can set them to whatever
          # else you want
          # WARNING: Do _not_ set them to `/home/user/whatever`, it will not work!
          mediaDir = "/data/media";
          stateDir = "/config/.state/nixarr";

#          vpn = {
#            enable = true;
#            # WARNING: This file must _not_ be in the config git directory
#            # You can usually get this wireguard file from your VPN provider
#            wgConf = "/config/.secret/wg-proton-server.conf";
#          };

          jellyfin = {
            enable = true;
            # These options set up a nginx HTTPS reverse proxy, so you can access
            # Jellyfin on your domain with HTTPS
            #expose.https = {
            #  enable = true;
            #  domainName = "your.domain.com";
            #  acmeMail = "your@email.com"; # Required for ACME-bot
            #};
          };

          transmission = {
            enable = true;
#            vpn.enable = true;
            peerPort = 51820; # Set this to the port forwarded by your VPN
          };
          sabnzbd = {
            enable = true;
            guiPort = 6336;
            stateDir = "/config/.state/sabnzbd";
#            vpn.enable = true;
          };
          
          # It is possible for this module to run the *Arrs through a VPN, but it
          # is generally not recommended, as it can cause rate-limiting issues.
          radarr = {
            enable = true;
            port = 7878;
            stateDir = "/config/.state/radarr";
          };
          sonarr = {
            enable = true;
            port = 8989;
            stateDir = "/config/.state/sonarr";
          };
          bazarr = {
            enable = true;
            port = 6767;
            stateDir = "/config/.state/bazarr";
          };
          lidarr = {
            enable = true;
            port = 8686;
            stateDir = "/config/.state/lidarr";
          };
          prowlarr = {
            enable = true;
            port = 9696;
            stateDir = "/config/.state/prowlarr";
          };
          readarr = {
            enable = true;
            port = 8787;
            stateDir = "/config/.state/readarr";
          };
          jellyseerr = {
            enable = true;
            port = 5055;
            stateDir = "/config/.state/jellyseerr";
          };
        };       

        system.stateVersion = "25.05";
      };
  };
}