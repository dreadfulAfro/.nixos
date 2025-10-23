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
        destination = "192.168.100.101";
        sourcePort = 53;
        proto = "udp";
      }
      {
        destination = "192.168.100.101";
        sourcePort = 53;
        proto = "tcp";
      }
    ];
    };
    firewall = {
      extraCommands = ''
        iptables -A INPUT -p udp --dport 53 -s 192.168.178.0/24 -j ACCEPT
        iptables -A INPUT -p tcp --dport 53 -s 192.168.178.0/24 -j ACCEPT
        iptables -A INPUT -p udp --dport 53 -j DROP
        iptables -A INPUT -p tcp --dport 53 -j DROP
      '';
    };
  };
}
