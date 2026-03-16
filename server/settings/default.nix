{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    ./network.nix
    ./core.nix
    ../programs/container/default.nix
  ];

}
