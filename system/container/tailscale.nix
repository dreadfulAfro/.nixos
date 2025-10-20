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
    useRoutingFeatures = "server"; # or both
    authKeyFile = "/etc/secrets/tailscale/authKey.key";
    openFirewall = true;
    extraUpFlags = [
      "--advertise-routes=192.168.178.0/24" # advertise your LAN subnet to Tailscale
      # "--ssh"                               # optional: allow SSH over Tailscale
    ];
    permitCertUid = "root"; # allows Tailscale TLS certs

  };
}
