{pkgs, ...}:
{
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      data-root = "/srv/data1tb/docker";
    };
  };
}