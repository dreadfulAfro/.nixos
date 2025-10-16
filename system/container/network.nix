{ }:
{
  # NAT mapping for containers
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];  # NAT all internal interfaces starting with ve- which containers do with private network activated
    externalInterface = "enp1s0";   
    # Lazy IPv6 connectivity for the container
    enableIPv6 = true;
  };
}
