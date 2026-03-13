{ pkgs, ... }:
{
  # Enable the GNOME Desktop Environment.
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Auto-login to the user "angelo" (change this to your username)
  services.displayManager.autoLogin.enable  = true;
  services.displayManager.autoLogin.user = "angelo";

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.gsconnect
    gnomeExtensions.just-perfection
  ];

  # enable gnome-settings-daemon for better integration with gnome-shell
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  environment.gnome.excludePackages = with pkgs; [
    atomix # puzzle game
    #cheese # webcam tool
    epiphany # web browser
    evince # document viewer
    gedit # text editor
    #gnome-characters
    #gnome-photos
    #gnome-terminal
    #gnome-clock
    gnome-weather
    gnome-characters
    totem # video player
    yelp # help viewer
    geary # email client
    gnome-calendar # calendar
    gnome-contacts # contacts
    gnome-maps # maps
    gnome-music # music
    gnome-tour
    hitori # sudoku game
    iagno # go game
    tali # poker game
  ];
}
