{
  description = "Multi-system NixOS setup with users angelo and work";

  nixConfig = {
    #extra-substituters = [
    #  "https://nix-community.cachix.org"
    #];
    #extra-trusted-public-keys = [
    #  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #];
  };

  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # additional modules
    nixarr.url = "github:rasmus-kirk/nixarr";

    # HomeManager
    # The `follows` keyword in inputs is used for inheritance.
    # Here, `inputs.nixpkgs` of home-manager is kept consistent with
    # the `inputs.nixpkgs` of the current flake,
    # to avoid problems caused by different versions of nixpkgs.
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixarr,
      home-manager,
      ...
    }:
    let
      mkSystem =
        {
          hostname,
          username,
          system ? "x86_64-linux",
        }:
        let
          specialArgs = { inherit username hostname inputs; };
        in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/${hostname}/default.nix
            ./users/${username}/nixos.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];
        };
#        nixpkgs.config.allowUnfree = true;
    in
    {
      nixosConfigurations = {
        nixos-laptop = mkSystem {
          hostname = "nixos-laptop";
          username = "angelo";
        };
        nixos-server = mkSystem {
          hostname = "nixos-server";
          username = "admin";
        };
        nixos-ctf = mkSystem {
          hostname = "nixos-ctf";
          username = "passwordc";
        };
      };
    };
}
