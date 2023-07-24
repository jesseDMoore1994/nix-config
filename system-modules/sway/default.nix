{ config, pkgs, ... }:
{
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };
  security.polkit.enable = true;
}
