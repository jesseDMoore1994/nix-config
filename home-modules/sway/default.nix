{ config, pkgs, lib, ... }:

{

  programs.feh.enable = true;
  home.packages = with pkgs; [swaybar];

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "kitty"; 
      # startup = [
      #   # Launch Firefox on start
      #   # {command = "firefox";}
      # ];
    };
  };

}
