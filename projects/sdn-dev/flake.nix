{
  description = "Mininet + Ryu SDN development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Python environment with Ryu and dependencies
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          ryu
          eventlet
          msgpack
          netaddr
          ovs
          routes
          webob
        ]);

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core networking tools
            mininet
            openvswitch
            
            # Python with Ryu
            pythonEnv
            
            # Network utilities
            xterm
            iperf2
            iperf3
            iputils  # provides ping
            
            # Additional useful tools
            tcpdump
            wireshark-cli  # tshark
            net-tools
            iproute2
          ];

          shellHook = ''
            echo "🚀 Mininet + Ryu Development Environment"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "Available tools:"
            echo "  • mininet    - Network emulator"
            echo "  • ryu-manager - SDN controller"
            echo "  • xterm      - Terminal emulator"
            echo "  • iperf/iperf3 - Network performance"
            echo "  • ping       - ICMP testing"
            echo "  • ovs-vsctl  - Open vSwitch control"
            echo ""
            echo "Quick start:"
            echo "  sudo mn --topo single,3 --mac --controller remote"
            echo "  ryu-manager ryu.app.simple_switch_13"
            echo ""
            
            # Set Python path for Ryu
            export PYTHONPATH="${pythonEnv}/${pythonEnv.sitePackages}:$PYTHONPATH"
            
            # Optional: Add aliases
            alias mn='sudo mn'
            alias ryu='ryu-manager'
          '';
        };
      }
    );
}