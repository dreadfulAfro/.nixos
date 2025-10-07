{pkgs, ...}:
{
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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
