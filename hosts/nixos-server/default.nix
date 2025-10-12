{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/core.nix
  ];

  networking.hostName = "nixos-server";
  system.stateVersion = "25.05";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-8e8ecfec-3711-4f6d-bd9f-fdf66f7396d8".device = "/dev/disk/by-uuid/8e8ecfec-3711-4f6d-bd9f-fdf66f7396d8";

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
    fail2ban.enable = true;
  };
  # Enable autologin for the user
  services.getty.autologinUser = "admin";
}