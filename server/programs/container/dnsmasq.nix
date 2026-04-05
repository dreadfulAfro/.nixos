{ config, pkgs, serverIP, ... }:
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
        "${serverIP}"
        "127.0.0.1"
      ];

      # Enable query logging for debugging
      #log-queries = true;
      # Your domain configuration
      domain = "tails";
      local = "/tails/";

      # All .tails domains point to Caddy on the shared bridge
      address = [
        "/paperless.tails/${serverIP}" # Changed from 192.168.100.2
        "/kavita.tails/${serverIP}"
        "/jellyfin.tails/${serverIP}"
        "/radarr.tails/${serverIP}"
        "/sonarr.tails/${serverIP}"
        "/bazarr.tails/${serverIP}"
        "/lidarr.tails/${serverIP}"
        "/prowlarr.tails/${serverIP}"
        "/readarr.tails/${serverIP}"
        "/sabnzbd.tails/${serverIP}"
        "/transmission.tails/${serverIP}"
        "/mediathekarr.tails/${serverIP}"
        "/jellyseerr.tails/${serverIP}"
        "/lazylibrarian.tails/${serverIP}"
        "/bookshelf.tails/${serverIP}"
        "/audiobookrequest.tails/${serverIP}"
        "/whatsupdocker.tails/${serverIP}"
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
