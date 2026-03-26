{
  description = "Multi-language development environments";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {

      devShells.${system} = {

        latex = pkgs.mkShell {
          packages = with pkgs; [
            texlive.combined.scheme-full # or a smaller scheme
            perl
          ];
        };

        python = pkgs.mkShell {
          packages = with pkgs; [
            python3
            python3Packages.pip
            python3Packages.virtualenv
            python3Packages.black
            python3Packages.ipython
          ];
        };

        java = pkgs.mkShell {
          packages = with pkgs; [
            jdk
            maven
            gradle
          ];
        };

        cpp = pkgs.mkShell {
          packages = with pkgs; [
            gcc
            clang
            gdb
            cmake
            pkg-config
          ];
        };

        rust = pkgs.mkShell {
          packages = with pkgs; [
            rustc
            cargo
            rust-analyzer
          ];
        };

        node = pkgs.mkShell {
          packages = with pkgs; [
            nodejs
            nodePackages.npm
            nodePackages.pnpm
          ];
        };

      };

    };
}
