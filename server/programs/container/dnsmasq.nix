{ config, pkgs, server, ... }:
{
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;  # Don't add 127.0.0.1 to /etc/resolv.conf
    settings = {
      # DON'T restrict listen-address - let it listen on all interfaces
      # Remove or comment out listen-address
      # listen-address = [ ... ];
      
      # Instead, use interface specification
      interface = "enp1s0";
      
      listen-address = [
        "${server.ip}"
        "127.0.0.1"
      ];

      # Enable query logging for debugging
      #log-queries = true;
      # Your domain configuration
      domain = "tails";
      local = "/tails/";

      # All .tails domains point to Caddy on the shared bridge
      address = [
        "/paperless.tails/${server.ip}" # Changed from 192.168.100.2
        "/kavita.tails/${server.ip}"
        "/jellyfin.tails/${server.ip}"
        "/radarr.tails/${server.ip}"
        "/sonarr.tails/${server.ip}"
        "/bazarr.tails/${server.ip}"
        "/lidarr.tails/${server.ip}"
        "/prowlarr.tails/${server.ip}"
        "/readarr.tails/${server.ip}"
        "/sabnzbd.tails/${server.ip}"
        "/transmission.tails/${server.ip}"
        "/mediathekarr.tails/${server.ip}"
        "/jellyseerr.tails/${server.ip}"
        "/lazylibrarian.tails/${server.ip}"
        "/bookshelf.tails/${server.ip}"
        "/audiobookrequest.tails/${server.ip}"
        "/whatsupdocker.tails/${server.ip}"
      ];

      server = [
        "9.9.9.9"
        "1.1.1.1"
      ];

     # Don't read /etc/resolv.conf
     # no-resolv = true;
      
      # Bind to interface, not IP
      #bind-interfaces = false;

      #expand-hosts = true;
      local-ttl = 60;
    };
  };
}
