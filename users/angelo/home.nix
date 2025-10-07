{ pkgs, ... }:
{
  imports = [
    ../../home/core.nix
    ../../home/programs/vscode.nix
    ../../home/programs/joplin.nix
    ../../home/programs/syncthing.nix
  ];

  programs.git = {
    enable = true;
    userEmail = "lukasangelo18@gmail.com";
    userName = "Lukas-Angelo Meier";
  };

  home.packages = with pkgs; [
    tor-browser
    dconf2nix
    gnome-network-displays
    miraclecast
    nixfmt-rfc-style
    teams-for-linux
  ];

  programs = {
    gnome-shell = {
      enable = true;
      extensions = [ { package = pkgs.gnomeExtensions.gsconnect; } ];
    };
    fish.enable = true;
  };

  services = {
    # For Virtualization and rdp
    remmina.enable = true;
  };
}
