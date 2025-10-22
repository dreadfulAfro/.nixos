{ pkgs, ... }:
{
  containers.paperless = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    hostAddress6 = "fc00::10";
    localAddress6 = "fc00::11";

    bindMounts = {
      "paperless" = {
        hostPath = "/srv/data1tb/paperless-ngx";
        mountPoint = "/paperless";
        isReadOnly = false;
      };
      "key" = {
        hostPath = "/etc/secrets/paperless";
        mountPoint = "/etc/secrets";
        isReadOnly = false;
      };
    };

    config =
      { pkgs, ... }:
      {
        services.paperless = {
          enable = true;
          address = "192.168.100.11";
          port = 42001;
          dataDir = "/paperless/data";
          mediaDir = "/paperless/media";
          passwordFile = "/etc/secrets/admin.key";
          settings = {
            PAPERLESS_OCR_LANGUAGE = "deu+eng";
            #PAPERLESS_URL = "https://nixos-server.tail194e5d.ts.net"; # to prevent csrf-verification issues
            #PAPERLESS_FORCE_SCRIPT_NAME = "/paperless";
            #PAPERLESS_STATIC_URL = "/paperless/static/";
            PAPERLESS_URL = "https://paperless.local";
            PAPERLESS_ALLOWED_HOSTS = "paperless.local,nixos-server.tail194e5d.ts.net";
            PAPERLESS_USE_X_FORWARDED = "true"; # trust Caddy headers
            PAPERLESS_USE_X_FORWARD_HOST = "true";
            PAPERLESS_USE_X_FORWARD_PORT = "true";

          };
        };

        networking.firewall = {
          enable = true;
          allowedTCPPorts = [ 42001 ];
        };

        system.stateVersion = "25.05";
      };
  };
}
