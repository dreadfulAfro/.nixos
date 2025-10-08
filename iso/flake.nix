{
  description = "custom nixos iso";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      exampleIso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

          ({
            users.users.nixos = {
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvvzzmAtcKOcvRsdB28CAL9PVgeFwf44qiecDEUKY1C nixos-server"
              ];
            };
          })
        ];
      };
    };
  };
}