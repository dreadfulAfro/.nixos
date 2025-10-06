{pkgs, ...}: {
  imports = [
    ../../home/core.nix
    ../../home/programs
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
  ];

  programs = {
    gnome-shell = {
      enable = true;
      extensions = [{package = pkgs.gnomeExtensions.gsconnect;}];
    };
    fish.enable = true;
  };

  services = {
    # For Virtualization and rdp
    remmina.enable = true;
  };
}
