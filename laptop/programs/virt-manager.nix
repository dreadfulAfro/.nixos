{ lib, username, ... }:
{
  # Virtualisierungskram für VMs
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  # for usb passthrough
  virtualisation.spiceUSBRedirection.enable = true;

  users.users.${username}.extraGroups = [ "libvirtd" ];
}
