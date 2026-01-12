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
    interfaces = {
      enp1s0.ipv4.addresses = [
        {
          address = "192.168.178.57";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.178.1";
      interface = "enp1s0";
    };
    nameservers = [
      "192.168.178.57"
      "127.0.0.1"
    ];
    search = [ "tails" ];
    firewall = {
      allowedTCPPorts = [
        53
        80
        443
        5007
        8989
        7878
        8096
        6767
        8686
        9696
        8787
        6336
        8080
        9091
        5055
        5299
        7777
        8000
      ];
      allowedUDPPorts = [
        53
      ];

      # Explicitly allow DNS on the LAN interface
      interfaces.enp1s0 = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
      };

      extraCommands = ''
        # CRITICAL: Allow DNS queries BEFORE any other rules
        #iptables -I INPUT 1 -p udp --dport 53 -j ACCEPT
        #iptables -I INPUT 1 -p tcp --dport 53 -j ACCEPT

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
