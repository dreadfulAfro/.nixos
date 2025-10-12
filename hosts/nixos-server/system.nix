{lib,  ...}: {
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-8e8ecfec-3711-4f6d-bd9f-fdf66f7396d8".device = "/dev/disk/by-uuid/8e8ecfec-3711-4f6d-bd9f-fdf66f7396d8";

}
