{ pkgs, ... }:
{
  # Example for /etc/nixos/configuration.nix
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # additional services
  services = {
    joycond.enable = true;
  }; 
}