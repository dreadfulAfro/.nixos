{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./system.nix
    ../../system/core.nix
  ];

  system.stateVersion = "25.05";
  networking.hostName = "nixos-server";

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