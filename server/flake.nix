{
  description = "nixos-laptop";
  inputs = {
    # NixOS official package source, using the nixos-unstable branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # HomeManager
    # The `follows` keyword in inputs is used for inheritance.
    # Here, `inputs.nixpkgs` of home-manager is kept consistent with
    # the `inputs.nixpkgs` of the current flake,
    # to avoid problems caused by different versions of nixpkgs.
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    {
      nixosConfigurations.nixos-server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; username = "admin"; };
        modules = [
          ./settings/hardware-configuration.nix
          ./settings/core.nix
          ./programs/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { username = "admin"; };
            home-manager.users.admin = import ./home/home.nix;
          }
        ];
      };
    };
}
