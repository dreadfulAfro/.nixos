{ pkgs, ... }:
{
  services.netdata = {
    enable = true;
    config.global = {
      "memory mode" = "ram";
      "debug log" = "none";
      "access log" = "none";
      "error log" = "syslog";
    };
  };
  networking.firewall.allowedTCPPorts = [ 19999 ];
}