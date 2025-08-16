{ pkgs, ... }:
{
    # Enable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal  # Core portal for desktop environments
      xdg-desktop-portal-wlr  # For wlroots-based desktops
      # Add other portals as needed (e.g., xdg-desktop-portal-hyprland for Hyprland)
      xdg-desktop-portal-cosmic
    ];
  };
}
