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
          port = 28981;
          dataDir = "/paperless/data";
          mediaDir = "/paperless/media";
          passwordFile = "/etc/secrets/admin.key";
          settings = {
            PAPERLESS_OCR_LANGUAGE = "deu+eng";
            PAPERLESS_URL = "https://paperless.local"; # to prevent csrf-verification issues
          };
        };

        networking.firewall = {
          enable = true;
          allowedTCPPorts = [ 28981 ];
        };

        system.stateVersion = "25.05";
      };
  };
}
