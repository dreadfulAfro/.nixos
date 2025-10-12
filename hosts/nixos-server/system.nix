{lib, config, ...}: {
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-8e8ecfec-3711-4f6d-bd9f-fdf66f7396d8".device = "/dev/disk/by-uuid/8e8ecfec-3711-4f6d-bd9f-fdf66f7396d8";

  # It may be necessary to wait a bit for devices to be initialized.
  # See https://github.com/NixOS/nixpkgs/issues/98741
  boot.initrd.preLVMCommands = lib.mkBefore 400 "sleep 1";
  # enable cryptsetup
  boot.initrd.luks.forceLuksSupportInInitrd = true;
  # Your post-boot network configuration is taken
  # into account. It should contain:
  networking.useDHCP = false;
  networking.interfaces."enp1s0".useDHCP = true;

  # setup pre decryption ssh server
  boot.initrd = {
    availableKernelModules = [ "r8169" ];
    network = {
      enable = true;
      udhcpc.enable = true;
      flushBeforeStage2 = true;
      ssh = {
        enable = true;
        port = 4623;
        # Stored in plain text on boot partition, so don't reuse your host
        # keys. Also, make sure to use a boot loader with support for initrd
        # secrets (e.g. systemd-boot), or this will be exposed in the nix store
        # to unprivileged users.
        hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
        # I'll just authorize all keys authorized post-boot.
        authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
        # Set the shell profile to meet SSH connections with a decryption
        # prompt that writes to /tmp/continue if successful.
      };
      postCommands = ''
      # Automatically ask for the password on SSH login
      echo 'cryptsetup-askpass || echo "Unlock was successful; exiting SSH session" && exit 1' >> /root/.profile
      '';
    };
  };


}
