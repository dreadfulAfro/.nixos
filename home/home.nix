{
  config,
  pkgs,
  ...
}: {
  home = {
    username = "angelo";
    homeDirectory = "/home/angelo";
    stateVersion = "25.05";

    packages = with pkgs; [
      btop
      dconf2nix
      tor-browser
    ];
  };

  programs = {
    gnome-shell = {
      enable = true;
      extensions = [{package = pkgs.gnomeExtensions.gsconnect;}];
    };
    fish.enable = true;
    git = {
      enable = true;
      userEmail = "lukasangelo18@gmail.com";
      userName = "Lukas-Angelo Meier";
    };
  };

  services = {
    # For Virtualization and rdp
    remmina.enable = true;
    
  };
}
