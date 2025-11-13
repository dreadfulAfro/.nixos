{ hostname, ... }:
{
  # NAT mapping for containers
  networking = {
    bridges.br-shared = {
      interfaces = [ ]; # Start empty, containers will attach to it
    };
    interfaces.br-shared = {
      ipv4.addresses = [
        {
          address = "10.10.10.1"; # Using 10.10.10.x to avoid conflicts with your existing networks
          prefixLength = 24;
        }
      ];
    };
    nat = {
      enable = true;
      internalInterfaces = [ "br-shared" ]; # NAT all internal interfaces starting with ve- which containers do with private network activated
      externalInterface = "enp1s0";

      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
      #      forwardPorts = [
      #        {
      #          destination = "192.168.100.101:53";
      #          sourcePort = 53;
      #          proto = "udp";
      #        }
      #        {
      #          destination = "192.168.100.101:53";
      #          sourcePort = 53;
      #          proto = "tcp";
      #        }
      #        # HTTP/HTTPS to Caddy container
      #        {
      #          destination = "192.168.100.2:80";
      #          sourcePort = 80;
      #          proto = "tcp";
      #        }
      #        {
      #          destination = "192.168.100.2:443";
      #          sourcePort = 443;
      #          proto = "tcp";
      #        }
      #      ];
      #    };
      firewall = {
        allowedTCPPorts = [
          80
          443
          53
        ];
        allowedUDPPorts = [
          53
        ];
        trustedInterfaces = [
          "br-shared"
          "tailscale0"
          "enp1s0"
        ];
        extraCommands = ''
          # Allow DNS from Tailscale
          iptables -A INPUT -p udp --dport 53 -s 100.64.0.0/10 -j ACCEPT
          iptables -A INPUT -p tcp --dport 53 -s 100.64.0.0/10 -j ACCEPT

          # Allow DNS from LAN
          iptables -A INPUT -p udp --dport 53 -s 192.168.178.0/24 -j ACCEPT
          iptables -A INPUT -p tcp --dport 53 -s 192.168.178.0/24 -j ACCEPT

          # Allow HTTP/HTTPS from LAN and Tailscale
          iptables -A INPUT -p tcp --dport 80 -s 192.168.178.0/24 -j ACCEPT
          iptables -A INPUT -p tcp --dport 443 -s 192.168.178.0/24 -j ACCEPT
          iptables -A INPUT -p tcp --dport 80 -s 100.64.0.0/10 -j ACCEPT
          iptables -A INPUT -p tcp --dport 443 -s 100.64.0.0/10 -j ACCEPT

          # Forward traffic from LAN/Tailscale to the shared bridge
          iptables -A FORWARD -i enp1s0 -o br-shared -j ACCEPT
          iptables -A FORWARD -i br-shared -o enp1s0 -j ACCEPT
          iptables -A FORWARD -i tailscale0 -o br-shared -j ACCEPT
          iptables -A FORWARD -i br-shared -o tailscale0 -j ACCEPT

          # DNAT for external access to services
          # Route traffic from LAN/Tailscale to the appropriate container
          iptables -t nat -A PREROUTING -i enp1s0 -p tcp --dport 80 -j DNAT --to-destination 10.10.10.2:80
          iptables -t nat -A PREROUTING -i enp1s0 -p tcp --dport 443 -j DNAT --to-destination 10.10.10.2:443
          iptables -t nat -A PREROUTING -i tailscale0 -p tcp --dport 80 -j DNAT --to-destination 10.10.10.2:80
          iptables -t nat -A PREROUTING -i tailscale0 -p tcp --dport 443 -j DNAT --to-destination 10.10.10.2:443

          # DNS forwarding
          iptables -t nat -A PREROUTING -i enp1s0 -p tcp --dport 53 -j DNAT --to-destination 10.10.10.3:53
          iptables -t nat -A PREROUTING -i enp1s0 -p udp --dport 53 -j DNAT --to-destination 10.10.10.3:53
          iptables -t nat -A PREROUTING -i tailscale0 -p tcp --dport 53 -j DNAT --to-destination 10.10.10.3:53
          iptables -t nat -A PREROUTING -i tailscale0 -p udp --dport 53 -j DNAT --to-destination 10.10.10.3:53

          # MASQUERADE for return traffic
          iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o enp1s0 -j MASQUERADE
        '';
      };
    };
  };
  systemd.services.docker-network-shared = {
    description = "Create Docker network on shared bridge";
    after = [
      "docker.service"
      "sys-devices-virtual-net-br\\x2dshared.device"
    ];
    requires = [ "docker.service" ];
    wants = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      # Remove any existing network with this name
      ${pkgs.docker}/bin/docker network rm shared-bridge 2>/dev/null || true

      # Create the network using our bridge
      ${pkgs.docker}/bin/docker network create \
        --driver=bridge \
        --subnet=10.10.10.0/24 \
        --gateway=10.10.10.1 \
        --opt com.docker.network.bridge.name=br-shared \
        shared-bridge
    '';

    preStop = ''
      ${pkgs.docker}/bin/docker network rm shared-bridge 2>/dev/null || true
    '';
  };
}
