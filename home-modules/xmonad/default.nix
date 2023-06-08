{ config, pkgs, lib, ... }:

{
  services.picom = {
    enable = true;
  };

  programs.feh.enable = true;

  programs.xmobar.enable = true;
  programs.xmobar.extraConfig = builtins.readFile ./xmobarrc;

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
