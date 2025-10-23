{
  lib,
  config,
  pkgs,
  ...
}:
{
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

  boot.initrd.luks.devices."luks-13c09ff4-cff9-4151-9a4e-976185f280f1".device =
    "/dev/disk/by-uuid/13c09ff4-cff9-4151-9a4e-976185f280f1";

  # Initialize external drives
  # 1TB Intenso
  systemd.services."luks-open-data1tb" = {
    description = "Unlock /srv LUKS volume 1TBIntenso";
    after = [ "local-fs.target" ]; # makes sure it is started after the local filesystem
    before = [ "multi-user.target" ]; # but before services are started
    #wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot"; # unit is executed once
      RemainAfterExit = true; # is marked as still active after execution, so execStop is still called later
      ExecStart = "${pkgs.cryptsetup}/bin/cryptsetup open /dev/disk/by-id/ata-ST1000LM024_HN-M101MBB_S2RXJ9ADB27331-part1 data1tb --key-file /etc/secrets/cryptsetup/ata-ST1000LM024_HN-M101MBB_S2RXJ9ADB27331-part1.key";
      ExecStop = "${pkgs.cryptsetup}/bin/cryptsetup close data1tb";
    };
  };
  # Mount the decrypted volume
  fileSystems."/srv/data1tb" = {
    device = "/dev/mapper/data1tb";
    fsType = "ext4";
    neededForBoot = false;
    options = [
      "nofail"
      "x-systemd.requires=luks-open-data1tb.service"
      "x-systemd.after=luks-open-data1tb.service"
    ];
  };
  # Ensure /srv exists
  systemd.tmpfiles.rules = [
    "d /srv 0755 root root -"
  ];

  # enable static ip address
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
      "192.168.100.101"
      "9.9.9.9"
      "1.1.1.1"
    ];
    firewall = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [ 53 ];
      trustedInterfaces = [
        "tailscale0"
        "enp1s0"
      ];
      extraCommands = ''
        iptables -A INPUT -p udp --dport 53 -s 100.64.0.0/10 -j ACCEPT
        iptables -A INPUT -p udp --dport 53 -s 192.168.178.0/24 -j ACCEPT
        iptables -A INPUT -p udp --dport 53 -j DROP
        iptables -A INPUT -p tcp --dport 53 -s 100.64.0.0/10 -j ACCEPT
        iptables -A INPUT -p tcp --dport 53 -s 192.168.178.0/24 -j ACCEPT
        iptables -A INPUT -p tcp --dport 53 -j DROP
      '';
    };
    #search = [ "tail194e5d.ts.net" ];
  };

  # setup pre decryption ssh server
  boot.kernelParams = [ "ip=192.168.178.57::192.168.178.1:255.255.255.0::enp1s0:off" ];
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
