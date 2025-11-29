{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./system.nix
    ./printserver.nix
    ../../system/core.nix

    ../../system/container/network.nix
    ../../system/container/tailscale.nix
    ../../system/container/dnsmasq.nix
    ../../system/container/caddy.nix

    ./permissions.nix
    ../../system/container/kavita.nix
    ../../system/container/paperless-ngx.nix
    ../../system/container/mediathekarr.nix
    ../../system/container/nixarr.nix
    ../../system/container/lazylibrarian.nix

  ];

  system.stateVersion = "25.05";
  networking.hostName = "nixos-server";
  nixpkgs.config.allowUnfree = true;

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--print-build-logs"
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  services = {
    openssh = {
      enable = true;
      ports = [ 4623 ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "admin" ];
      };
    };
    # ban hosts that cause multiple authentication errors
    fail2ban.enable = true;
    # slow down ssh connection attempts by indeffinitley delaying connections
    endlessh = {
      enable = true;
      port = 22;
      openFirewall = true;
    };

  };
  # Enable autologin for the user
  services.getty.autologinUser = "admin";
}
