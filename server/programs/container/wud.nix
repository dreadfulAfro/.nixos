{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers.wud = {
    image = "getwud/wud:latest";

    ports = [
      "3000:3000"
    ];

    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock"
    ];

    environment = {
      WUD_WATCHER_LOCAL_DOCKER = "true";
    };

    extraOptions = [
      "--name=wud"
    ];
  };
}