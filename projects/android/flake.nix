{
  description = "Android development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    android.url = "github:tadfisher/android-nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      android,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            android_sdk.accept_license = true;
          };
        };

        androidSdk = android.sdk.${system} (
          sdkPkgs: with sdkPkgs; [
            cmdline-tools-latest
            platform-tools
            build-tools-34-0-0
            platforms-android-34
            emulator
          ]
        );

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            jdk17
            gradle
            androidSdk
            android-tools
          ];

          ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
          ANDROID_HOME = "${androidSdk}/libexec/android-sdk";

          shellHook = ''
            echo "Android dev environment ready"
            echo "SDK path: $ANDROID_SDK_ROOT"
          '';
        };
      }
    );
}
