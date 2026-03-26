{
  pkgs,
  ...
}:

{
  imports = [
    ./gnome.nix
    #./cosmic.nix
    ./fish.nix
    ./firefox.nix
    ./syncthing.nix
    ./steam.nix
  ];

  # Install additional software
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    btop
    scrcpy
    protonvpn-gui
    signal-desktop
    logseq
    #valent
    remmina
    element-desktop
    fractal
    #stremio
  ];

  # additional services
  services = {
    flatpak.enable = true;
    safeeyes.enable = false;
  };

}
