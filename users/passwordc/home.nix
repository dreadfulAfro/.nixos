{pkgs, ...}:
{
  imports = [
    ../../home/core.nix
    ../../home/programs/vscode.nix
  ];

  programs.fish.enable = true;
}