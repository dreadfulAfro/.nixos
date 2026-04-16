{ pkgs, username, ... }:
{
  nixpkgs.config.android_sdk.accept_license = true;

  environment.systemPackages = with pkgs; [
    android-studio
    android-tools
    androidenv.androidPkgs.androidsdk
    jdk17
    gradle
  ];
  users.users.${username}.extraGroups = [ "kvm" ];

}
