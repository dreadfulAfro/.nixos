{ pkgs, username, ... }:
{
  nixpkgs.config.android_sdk.accept_license = true;

  environment.systemPackages = with pkgs; [
    android-studio
    android-tools
    jdk17
    gradle
    (androidenv.androidPkgs.androidsdk (
      sdkPkgs: with sdkPkgs; [
        platform-tools
        build-tools-34-0-0
        platforms-android-34
      ]
    ))
  ];
  users.users.${username}.extraGroups = [ "kvm" ];

}
