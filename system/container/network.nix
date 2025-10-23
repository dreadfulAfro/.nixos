{ hostname, ... }:
{
  # NAT mapping for containers
  networking = {
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ]; # NAT all internal interfaces starting with ve- which containers do with private network activated
      externalInterface = "enp1s0";
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
      forwardPorts = [
        {
          sourceInterface = "tailscale0";
          destination = "192.168.100.101";
          sourcePort = 53;
          proto = "udp";
        }
        {
          sourceInterface = "tailscale0";
          destination = "192.168.100.101";
          sourcePort = 53;
          proto = "tcp";
        }
      ];
    };
    firewall = {
      trustedInterfaces = [
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
        iptables -A INPUT -p udp --dport 53 -j DROP
        iptables -A INPUT -p tcp --dport 53 -j DROP

        # Allow forwarded DNS from tailscale0 to container
        iptables -A FORWARD -i tailscale0 -o ve-dnsmasq -p udp --dport 53 -j ACCEPT
        iptables -A FORWARD -i tailscale0 -o ve-dnsmasq -p tcp --dport 53 -j ACCEPT
      '';
    };
  };
}
