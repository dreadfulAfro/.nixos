{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    android-studio
  ];
  programs.adb.enable = true;

  nixpkgs.config = {
    android_sdk.accept_license = true;
  };

}
