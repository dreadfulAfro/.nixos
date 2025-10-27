{...}:
{
  # publish printer on network
  services.printing = {
    enable = true;
    # This makes the server advertise printers via mDNS/IPP
    # so other devices can see them automatically.
    #browsed.enable = true;
    listenAddresses = [ "0.0.0.0:631" ];
    allowFrom = [ "192.168.178.0/24" ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;

    # optional but neat: make Avahi advertise too
    # (for macOS/Linux autodiscovery)
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
}
