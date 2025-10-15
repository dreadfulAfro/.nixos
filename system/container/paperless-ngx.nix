{ pkgs, ... }:
{
  containers.paperless-ngx = {
    autoStart = true;

    config =
      { pkgs }:
      {
        services.paperless = {
          enable = true;
          dataDir = "/srv/data1tb/paperless-ngx/data";
          mediaDir = "/srv/data1tb/paperless-ngx/media";
          passwordFile = "/etc/secrets/paperless/admin.key";
          settings = {
            PAPERLESS_OCR_LANGUAGE = "deu+eng";

          };
        };
      };
  };
}
