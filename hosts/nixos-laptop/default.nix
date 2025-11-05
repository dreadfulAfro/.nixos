{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./network.nix
    ./system.nix
    ../../system/core.nix
    ../../system/programs/gnome.nix
    ../../system/programs/fish.nix
    ../../system/programs/firefox.nix
  ];

  networking.hostName = "nixos-laptop";
  system.stateVersion = "25.05";

  #hardware.enableAllFirmware = true;
  #hardware.firmware = [ pkgs.linux-firmware ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Install additional software
  environment.systemPackages = with pkgs; [
    scrcpy
    gnomeExtensions.appindicator
  ];

  # additional services
  #services = {
  #  safeeyes.enable = true;
  #};

}