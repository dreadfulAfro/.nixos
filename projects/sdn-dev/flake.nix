{
  description = "Mininet + Ryu SDN development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        devShells.default = pkgs.mkShell {
          # Core system packages
          packages = [
            pkgs.mininet
            pkgs.openvswitch
            pkgs.xterm
            pkgs.iperf
            pkgs.iputils
            pkgs.python3
          ];

          # Setup commands run when entering the shell
          shellHook = ''
            echo "Setting up Python environment…"

            python -m venv .venv
            source .venv/bin/activate

            pip install --upgrade pip wheel setuptools
            pip install ryu

            echo ""
            echo "Environment ready:"
            echo " - Ryu: ryu-manager"
            echo " - Mininet: mininet-start"
          '';

        };

        # Your scripts
        apps = {
          mininet-start = {
            type = "app";
            program = toString (pkgs.writeShellScript "mininet-start" ''
              echo "Starting Mininet with Ryu controller at 127.0.0.1:6633"
              sudo mn --controller=remote,ip=127.0.0.1 --switch=ovsk
            '');
          };

          ryu-simple = {
            type = "app";
            program = toString (pkgs.writeShellScript "ryu-simple" ''
              ryu-manager ryu.app.simple_switch_13
            '');
          };
        };
      });
}