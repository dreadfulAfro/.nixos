{pkgs, ...}:
{
  systemd.timers."speedtest" = {
  description = "Run speedtest every 10 minutes";

  wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "speedtest.service";
    };
  };

  systemd.services."speedtest" = {
    description = "Periodic Internet Speedtest";
    script = ''
      LOGFILE="/home/youruser/speedtest.csv"

      timestamp=$(date --iso-8601=seconds)

      ${pkgs.speedtest}/bin/speedtest --csv  >> "$LOGFILE"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}