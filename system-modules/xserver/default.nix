{ config, pkgs, ... }:
{
  services.xserver.enable = true;

  services.xserver.displayManager.lightdm = {
    enable = true;
    background = pkgs.nixos-artwork.wallpapers.dracula.gnomeFilePath;
  };
  # services.xserver.desktopManager.xfce.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
}
