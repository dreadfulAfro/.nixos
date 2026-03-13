{pkgs, ...}:
{
  # Install firefox.
  programs.firefox = {
    enable = true;
    preferences = {
      # disable libadwaita theming for Firefox
      "widget.gtk.libadwaita-colors.enabled" = false;
    };
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      #forceWayland = true;
      extraPolicies = {
        ExtensionSettings = {};
      };
    };
  };
}