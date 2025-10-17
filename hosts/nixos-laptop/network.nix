{ lib, ... }:
{
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  programs.ssh = {
    extraConfig = "
      Host nixos-server-decr
        Hostname 192.168.178.57
        Port 4622
        User root
      Host nixos-server
        Hostname 192.168.178.57
        Port 4623
        User admin
      IdentitiesOnly yes
      IdentityFile ~/.ssh/id_ed25519
    ";
  };

  services.tailscale.enable = true;
  #networking.firewall.trustedInterfaces = [ "p2p-wl+" ];
  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ]; # for gsconnect
    allowedUDPPortRanges = allowedTCPPortRanges; # for gsconnect
  };

  networking.extraHosts = "192.168.178.57 paperless.local";

}
