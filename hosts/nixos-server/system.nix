{lib, config, pkgs, ...}: {
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  # It may be necessary to wait a bit for devices to be initialized.
  # See https://github.com/NixOS/nixpkgs/issues/98741
  #boot.initrd.preLVMCommands = lib.mkBefore 400 "sleep 1";
  # enable cryptsetup
  #boot.initrd.luks.forceLuksSupportInInitrd = true;
  # Your post-boot network configuration is taken
  # into account. It should contain:
  #networking.useDHCP = false;
  #networking.interfaces."enp1s0".useDHCP = true;

 boot.initrd.luks.devices."luks-13c09ff4-cff9-4151-9a4e-976185f280f1".device = "/dev/disk/by-uuid/13c09ff4-cff9-4151-9a4e-976185f280f1";

  # Initialize external drives
  # 1TB Intenso
  systemd.services."luks-open-data1tb" = {
    description = "Unlock /srv LUKS volume 1TBIntenso";
    #wantedBy = [ "local-fs.target" ];  # systemd will try to run this unit when starting local filesystem
    before = [ "local-fs.target" ];  # makes sure it is started before the local filesystem
    serviceConfig = {
      Type = "oneshot";  # unit is executed once
      RemainAfterExit = true;   # is marked as still active after execution, so execStop is still called later
      ExecStart = "${pkgs.cryptsetup}/bin/cryptsetup open /dev/disk/by-id/ata-ST1000LM024_HN-M101MBB_S2RXJ9ADB27331-part1 data1tb --key-file /etc/secrets/cryptsetup/ata-ST1000LM024_HN-M101MBB_S2RXJ9ADB27331-part1.key";
      ExecStop = "${pkgs.cryptsetup}/bin/cryptsetup close data1tb";
    };
  };
  # Mount the decrypted volume
  fileSystems."/srv/data1tb" = {
    device = "/dev/mapper/data1tb";
    fsType = "ext4";
  };
  # Ensure /srv exists
  systemd.tmpfiles.rules = [
    "d /srv 0755 root root -"
  ];


  # setup pre decryption ssh server
  boot.kernelParams = [ "ip=dhcp" ];
  boot.initrd = {
    availableKernelModules = [ "r8169" ];
    network = {
      enable = true;
      flushBeforeStage2 = true;
      ssh = {
        enable = true;
        port = 4622;
        # Stored in plain text on boot partition, so don't reuse your host
        # keys. Also, make sure to use a boot loader with support for initrd
        # secrets (e.g. systemd-boot), or this will be exposed in the nix store
        # to unprivileged users.
        hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
        # I'll just authorize all keys authorized post-boot.
        authorizedKeys = config.users.users.admin.openssh.authorizedKeys.keys;
        # Set the shell to greet us with password prompt
        shell = "/bin/cryptsetup-askpass";
      };
    };
  };


}
