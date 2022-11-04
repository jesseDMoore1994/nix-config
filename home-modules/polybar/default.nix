{ config, pkgs, ... }:

let
  mainBar = import ./bar.nix {};

  mypolybar = pkgs.polybar.override {
    alsaSupport = true;
    githubSupport = true;
    mpdSupport = true;
    pulseSupport = true;
  };

  # theme adapted from: https://github.com/adi1090x/polybar-themes#-polybar-5
  bars = builtins.readFile ./bars.ini;
  colors = builtins.readFile ./colors.ini;
  mods1 = builtins.readFile ./modules.ini;
  mods2 = builtins.readFile ./user_modules.ini;

in
{
  services.polybar = {
    enable = true;
    package = mypolybar;
    config = ./config.ini;
    script = ''
polybar &
'';
  };
}
