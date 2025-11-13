{ hostname, pkgs, ... }:
{
  # NAT mapping for containers
  networking = {
    nameservers = [ "192.168.100.3" "1.1.1.1" ];
    search = [ "tails" ];
    bridges.br-shared = {
      interfaces = [ ]; # Start empty, containers will attach to it
    };
    interfaces.br-shared = {
      ipv4.addresses = [
        {
          address = "192.168.100.1"; # Using 192.168.100.x to avoid conflicts with your existing networks
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
      forwardPorts = [
        {
          destination = "192.168.100.3:53";
          sourcePort = 53;
          proto = "udp";
        }
        {
          destination = "192.168.100.3:53";
          sourcePort = 53;
          proto = "tcp";
        }
        # HTTP/HTTPS to Caddy container
        {
          destination = "192.168.100.2:80";
          sourcePort = 80;
          proto = "tcp";
        }
        {
          destination = "192.168.100.2:443";
          sourcePort = 443;
          proto = "tcp";
        }
      ];
    };
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
        # Allow DNS from Tailnet
        iptables -A INPUT -p udp --dport 53 -s 100.64.0.0/10 -j ACCEPT
        iptables -A INPUT -p tcp --dport 53 -s 100.64.0.0/10 -j ACCEPT

        # Allow DNS from LAN
        iptables -A INPUT -p udp --dport 53 -s 192.168.178.0/24 -j ACCEPT
        iptables -A INPUT -p tcp --dport 53 -s 192.168.178.0/24 -j ACCEPT

        # Drop all other DNS requests
        #iptables -A INPUT -p udp --dport 53 -j DROP
        #iptables -A INPUT -p tcp --dport 53 -j DROP

        # Forward traffic from LAN/Tailscale to the shared bridge
        iptables -A FORWARD -i enp1s0 -o br-shared -j ACCEPT
        iptables -A FORWARD -i br-shared -o enp1s0 -j ACCEPT
        iptables -A FORWARD -i tailscale0 -o br-shared -j ACCEPT
        iptables -A FORWARD -i br-shared -o tailscale0 -j ACCEPT
        
        # Allow forwarding to Dnsmasq container
        iptables -A FORWARD -d 192.168.100.3 -p tcp --dport 53 -j ACCEPT
        iptables -A FORWARD -d 192.168.100.3 -p udp --dport 53 -j ACCEPT

        # Redirect DNS queries to the dnsmasq container
        iptables -t nat -A PREROUTING -d 192.168.178.57 -p tcp --dport 53 -j DNAT --to-destination 192.168.100.3:53
        iptables -t nat -A PREROUTING -d 192.168.178.57 -p udp --dport 53 -j DNAT --to-destination 192.168.100.3:53

        # CRITICAL: Add DNAT rules that work from ALL interfaces, not just enp1s0
        # This allows LAN and Tailscale traffic to reach Caddy
        iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 192.168.100.2:80
        iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination 192.168.100.2:443

        # Allow forwarding to Caddy container
        iptables -A FORWARD -d 192.168.100.2 -p tcp --dport 80 -j ACCEPT
        iptables -A FORWARD -d 192.168.100.2 -p tcp --dport 443 -j ACCEPT

        # MASQUERADE so responses can get back
        iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o enp1s0 -j MASQUERADE
        iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o tailscale0 -j MASQUERADE

      '';

    };
  };
}
