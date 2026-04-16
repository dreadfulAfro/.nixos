{ pkgs, username, ... }:
{
  nixpkgs.config.android_sdk.accept_license = true;

  environment.systemPackages = with pkgs; [
    android-studio
    android-tools
    jdk17
    gradle
    (androidenv.composeAndroidPackages {
      platformVersions = [ "34" ];
      buildToolsVersions = [ "34.0.0" ];
    }).androidsdk
  ];
  users.users.${username}.extraGroups = [ "kvm" ];

}
