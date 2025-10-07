{pkgs}:
{
  # Install firefox.
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      #forceWayland = true;
      extraPolicies = {
        ExtensionSettings = {};
      };
    };
  };
}