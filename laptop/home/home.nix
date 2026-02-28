{ pkgs, username, ... }:
{
  imports = [
    ./programs/vscode.nix
    ./programs/joplin.nix
  ];

   # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs = {
    fish.enable = true;
    git = {
      enable = true;
      settings.user = {
        email = "lukasangelo18@gmail.com";
        name = "Lukas-Angelo Meier";
      };
    };
  };

  home.packages = with pkgs; [
    #microsoft-edge
    tor-browser
    dconf2nix
    nixfmt
    teams-for-linux
    obsidian
  ];

  services = {
  };
}
