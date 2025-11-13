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
      # 1. Enable IP Forwarding (required for NAT to work)
      echo 1 > /proc/sys/net/ipv4/ip_forward
      
      # 2. Accept FORWARD traffic on the bridge (NixOS does some of this declaratively, but this is a good safety net)
      iptables -A FORWARD -i br-shared -j ACCEPT
      iptables -A FORWARD -o br-shared -j ACCEPT
      
      # 3. Accept traffic related to the bridge (for established connections)
      iptables -A FORWARD -i br-shared -o enp1s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
      iptables -A FORWARD -i enp1s0 -o br-shared -m state --state RELATED,ESTABLISHED -j ACCEPT
      
      # NOTE: The DNAT rules for ports 80, 443, and 53 must be removed/commented out from here.
      # You should only rely on networking.nat.forwardPorts and the host's nameservers setting.
    '';
    };
  };
}
