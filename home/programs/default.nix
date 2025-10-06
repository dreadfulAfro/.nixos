{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./joplin.nix
    ./syncthing.nix
    ./vscode.nix
  ];
}
