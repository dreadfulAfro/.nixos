{
  lib,
  config,
  pkgs,
  ...
}:
{
  # Tailscale
  services.tailscale = {
    enable = true;
    #enableDNS = false; # to prevent magicdns slowing down normal connections
    useRoutingFeatures = "server"; # or server
    authKeyFile = "/etc/secrets/tailscale/authKey.key";
    openFirewall = true;
    extraUpFlags = [
      "--accept-dns=true"
      "--advertise-routes=192.168.100.0/24"
      "--advertise-routes=192.168.178.0/24"
      #      "--advertise-routes=192.168.178.0/24, 192.168.100.0/24" # advertise your LAN subnet to Tailscale
      # "--ssh"                               # optional: allow SSH over Tailscale
    ];
    permitCertUid = "caddy"; # allows Tailscale TLS certs

  };
}
