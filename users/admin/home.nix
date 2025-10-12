{pkgs, username, ...}:
{
  imports = [
    ../../home/core.niix
  ];

  users.users.${username}.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvvzzmAtcKOcvRsdB28CAL9PVgeFwf44qiecDEUKY1C nixos-server" ];
}