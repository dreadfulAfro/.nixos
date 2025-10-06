{lib, ...}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-145f28a0-33df-440c-a18a-e838dc16157e".device = "/dev/disk/by-uuid/145f28a0-33df-440c-a18a-e838dc16157e";

  programs.dconf.profiles = {
    # TODO: Investigate customizing gdm greeter.
    user.databases = [
      {
        settings = with lib.gvariant; {
          "org/gnome/desktop/input-sources" = {
            mru-sources = [(mkTuple ["xkb" "us+altgr-intl"])];
            sources = [(mkTuple ["xkb" "us+altgr-intl"]) (mkTuple ["xkb" "de+nodeadkeys"])];
          };
        };
      }
    ];
  };

  # Virtualisierungskram für VMs
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
}
