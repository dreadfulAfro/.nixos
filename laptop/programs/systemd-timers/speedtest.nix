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
      LOGFILE="/home/angelo/speedtest.csv"

      timestamp=$(date +%R)

      echo "$timestamp,$(${pkgs.ookla-speedtest}/bin/speedtest --format=csv 2>/dev/null)" >> "$LOGFILE"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "angelo";
    };
  };
}