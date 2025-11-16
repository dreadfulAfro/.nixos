{ hostname, pkgs, ... }:
{
  # Make sure Docker is running and can manage iptables/ip-masq
  virtualisation.docker = {
  enable = true;
  # Ensure docker manages iptables / masquerade for its default bridge if you still use it
  extraOptions = "--iptables=true --ip-masq=true";
  };

  # NAT mapping for containers
  networking = {
    nameservers = [ "192.168.100.3" "1.1.1.1" ];
    search = [ "tails" ];
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ]; # NAT all internal interfaces starting with ve- which containers do with private network activated
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
        #{
        #  destination = "192.168.100.2:80";
        #  sourcePort = 80;
        #  proto = "tcp";
        #}
        #{
        #  destination = "192.168.100.2:443";
        #  sourcePort = 443;
        #  proto = "tcp";
        #}
      ];
    };
    firewall = {
      allowedTCPPorts = [
        53 80 443 5007 8989 7878 8096 6767 8686 9696 8787 6336 9091 5055
      ];
      allowedUDPPorts = [
        53
      ];
      trustedInterfaces = [
        "tailscale0"
        "enp1s0"
        "lo"
      ];
      extraCommands = ''
        # Allow DNS from Tailnet
        iptables -A INPUT -p udp --dport 53 -s 100.64.0.0/10 -j ACCEPT
        iptables -A INPUT -p tcp --dport 53 -s 100.64.0.0/10 -j ACCEPT
        
        # Allow DNS from LAN
        iptables -A INPUT -p udp --dport 53 -s 192.168.178.0/24 -j ACCEPT
        iptables -A INPUT -p tcp --dport 53 -s 192.168.178.0/24 -j ACCEPT

        # Redirect DNS queries to the dnsmasq container
        #iptables -t nat -A PREROUTING -d 192.168.178.57 -p tcp --dport 53 -j DNAT --to-destination 192.168.100.3:53
        #iptables -t nat -A PREROUTING -d 192.168.178.57 -p udp --dport 53 -j DNAT --to-destination 192.168.100.3:53
        #iptables -t nat -A PREROUTING -d 100.77.114.79 -p tcp --dport 53 -j DNAT --to-destination 192.168.100.3:53
        #iptables -t nat -A PREROUTING -d 100.77.114.79 -p udp --dport 53 -j DNAT --to-destination 192.168.100.3:53
  
        # Redirect HTTP/HTTPS to Caddy for Tailscale traffic (destined to Tailscale IP)
        iptables -t nat -A PREROUTING -d 100.77.114.79 -p tcp --dport 80 -j DNAT --to-destination 192.168.100.2:80
        iptables -t nat -A PREROUTING -d 100.77.114.79 -p tcp --dport 443 -j DNAT --to-destination 192.168.100.2:443
  
        
        # Redirect HTTP/HTTPS to Caddy - ONLY for traffic destined to the host IP
        iptables -t nat -A PREROUTING -d 192.168.178.57 -p tcp --dport 80 -j DNAT --to-destination 192.168.100.2:80
        iptables -t nat -A PREROUTING -d 192.168.178.57 -p tcp --dport 443 -j DNAT --to-destination 192.168.100.2:443
        
        # MASQUERADE so responses can get back
        iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o enp1s0 -j MASQUERADE
        iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o tailscale0 -j MASQUERADE
      '';

    };
  };
}
