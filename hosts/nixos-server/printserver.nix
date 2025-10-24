{...}:
{
  # publish printer on network
  services.printing = {
    enable = true;
    webInterface = true;

    # This makes the server advertise printers via mDNS/IPP
    # so other devices can see them automatically.
    browsed.enable = true;
    listenAddresses = [ "0.0.0.0:631" ];
    allowFrom = [ "all" ];
    defaultShared = true;

    # optional but neat: make Avahi advertise too
    # (for macOS/Linux autodiscovery)
  };
  services.avahi = {
    daemon.enable = true;
    nssmdns.enable = true;
  };
}
