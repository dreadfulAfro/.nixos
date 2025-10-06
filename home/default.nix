{pkgs, ...}: {
  imports = [
    ./home.nix
    ./packages
    ./programs
  ];
}
