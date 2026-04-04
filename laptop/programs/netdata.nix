{ pkgs, config, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [ "netdata" ];

  services.netdata = {
    enable = true;

    package = pkgs.netdata.override {
      withCloudUi = true;
    };

    config.global = {
      "memory mode" = "ram";
      "debug log" = "none";
      "access log" = "none";
      "error log" = "syslog";
    };
  };
}