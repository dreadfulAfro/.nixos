{ config, pkgs, ... }:
{
  services.dnsmasq = {
    enable = true;
    settings = {
      # DON'T restrict listen-address - let it listen on all interfaces
      # Remove or comment out listen-address
      # listen-address = [ ... ];
      
      # Instead, use interface specification
      interface = "enp1s0";
      
      # Enable query logging for debugging
      log-queries = true;
      # Your domain configuration
      domain = "tails";
      local = "/tails/";

      # All .tails domains point to Caddy on the shared bridge
      address = [
        "/paperless.tails/192.168.178.57" # Changed from 192.168.100.2
        "/kavita.tails/192.168.178.57"
        "/jellyfin.tails/192.168.178.57"
        "/radarr.tails/192.168.178.57"
        "/sonarr.tails/192.168.178.57"
        "/bazarr.tails/192.168.178.57"
        "/lidarr.tails/192.168.178.57"
        "/prowlarr.tails/192.168.178.57"
        "/readarr.tails/192.168.178.57"
        "/sabnzbd.tails/192.168.178.57"
        "/transmission.tails/192.168.178.57"
        "/mediathekarr.tails/192.168.178.57"
        "/jellyseerr.tails/192.168.178.57"
        "/lazylibrarian.tails/192.168.178.57"
        "/bookshelf.tails/192.168.178.57"
        "/audiobookrequest.tails/192.168.178.57"
      ];

      server = [
        "9.9.9.9"
        "1.1.1.1"
      ];

     # Don't read /etc/resolv.conf
      no-resolv = true;
      
      # Bind to interface, not IP
      bind-interfaces = false;
      
      #expand-hosts = true;
      local-ttl = 60;
    };
  };
}
