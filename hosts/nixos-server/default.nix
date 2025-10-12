{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/core.nix
  ];

  networking.hostName = "nixos-server";
  system.stateVersion = "25.05";


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
}