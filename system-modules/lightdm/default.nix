{ config, pkgs, ... }:
{
  services.xserver.displayManager.lightdm = {
    enable = true;
    background = pkgs.nixos-artwork.wallpapers.dracula.gnomeFilePath;
  };
  services.xserver.displayManager.defaultSession = "xsession";
  services.xserver.displayManager.session = [
    {
      manage = "desktop";
      name = "xsession";
      start = ''exec $HOME/.xsession'';
    }
  ];
}
