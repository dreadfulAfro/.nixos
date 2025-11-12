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
          destination = "192.168.100.101:53";
          sourcePort = 53;
          proto = "udp";
        }
        {
          destination = "192.168.100.101:53";
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
        "tailscale0"
        "enp1s0"
        "ve-+"
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

        # Allow forwarded DNS from Tailscale to dnsmasq container
        iptables -A FORWARD -i tailscale0 -o ve-dnsmasq -p udp --dport 53 -j ACCEPT
        iptables -A FORWARD -i tailscale0 -o ve-dnsmasq -p tcp --dport 53 -j ACCEPT

        # === Allow containers to reach Caddy on host ===
        # NixOS containers (192.168.100.x) can reach host IP for Caddy
        iptables -A INPUT -s 192.168.100.0/24 -d 192.168.178.57 -p tcp -m multiport --dports 80,443 -j ACCEPT
        
        # Docker containers (172.x.x.x) can reach host IP for Caddy
        iptables -A INPUT -s 172.16.0.0/12 -d 192.168.178.57 -p tcp -m multiport --dports 80,443 -j ACCEPT
        
        # === Allow Caddy to reach backend services ===
        # Caddy container can reach nixarr container
        iptables -A FORWARD -s 192.168.100.2 -d 192.168.100.91 -j ACCEPT
        iptables -A FORWARD -s 192.168.100.91 -d 192.168.100.2 -j ACCEPT
        
        # NAT so nixarr sees requests from Caddy properly
        iptables -t nat -A POSTROUTING -s 192.168.100.2 -d 192.168.100.91 -j MASQUERADE
        
        # Caddy can reach other containers (paperless, kavita)
        iptables -A FORWARD -s 192.168.100.2 -d 192.168.100.0/24 -j ACCEPT
        iptables -A FORWARD -s 192.168.100.0/24 -d 192.168.100.2 -j ACCEPT
        
        # Caddy can reach host services (mediathekarr on Docker)
        # Mediathekarr is accessible at 127.0.0.1:5007 or 192.168.178.57:5007 from Caddy's perspective
        # If using host network for mediathekarr, this allows the connection back
        # iptables -A INPUT -s 192.168.100.2 -d 192.168.178.57 -p tcp --dport 5007 -j ACCEPT
      '';
    };
  };
}
