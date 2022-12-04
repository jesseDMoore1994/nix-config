{ config, pkgs, lib, ... }:

{
  services.picom = {
    enable = true;
  };

  # move background somewhere I can get it
  home.file.".background-image".source = ../../wallpapers/pastel_mesa.png;
  programs.feh.enable = true;

  xsession = {
    enable = true;
    windowManager.xmonad = {
      config = ./xmonad.hs;
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.dbus
        haskellPackages.List
        haskellPackages.monad-logger
        haskellPackages.xmonad
      ];
    };
  };
}
