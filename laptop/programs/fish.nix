{ pkgs, ... }:

{
  ########################################
  # fish shell configuration
  ########################################

  programs.fish = {
    enable = true;

    shellAliases = {
      ls = "eza";
      ll = "eza -lah"; # improved ls
      cat = "bat"; # syntax highlighted cat
      gs = "git status"; # git status shortcut
      rebuild = "sudo nixos-rebuild switch --flake /home/angelo/.nixos/laptop#nixos-laptop"; # rebuild system
      update = "sudo nixos-rebuild switch --upgrade"; # rebuild + update
      gc = "nix-collect-garbage -d"; # remove old nix generations
    };

    interactiveShellInit = ''
      set -g fish_greeting           # disable greeting message

      # faster file search for fzf
      set -gx FZF_DEFAULT_COMMAND "fd --type f"
      set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

      # enable direnv automatically
      direnv hook fish | source

      # initialize smarter directory jumping
      zoxide init fish | source
    '';
  };

  ########################################
  # prompt
  ########################################

  programs.starship.enable = true; # fast cross-shell prompt

  ########################################
  # automatic nix environments
  ########################################

  programs.direnv = {
    enable = true; # auto-load env when entering folders
    nix-direnv.enable = true; # fast nix integration
  };

  ########################################
  # shell tools
  ########################################

  environment.systemPackages = with pkgs; [
    fishPlugins.done # notify when long jobs finish
    fishPlugins.fzf-fish # fuzzy search keybindings
    fishPlugins.forgit # interactive git commands
    fishPlugins.colored-man-pages # colored man pages
    #fishPlugins.hydro # colored output for tools
    fzf # fuzzy finder
    fd # fast file search
    ripgrep # fast text search
    bat # syntax highlighted cat
    eza # modern ls replacement
    zoxide # smarter cd command
    bottom # system monitor
    git # version control
    grc # colorize tool output
  ];

  ########################################
  # use fish as default shell for users
  ########################################

  users.defaultUserShell = pkgs.fish;
}
