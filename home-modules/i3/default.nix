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
    #profileExtra = ''
    #  xrandr --output DP-1 --auto
    #  xrandr --output HDMI-0 --auto --right-of DP-1
    #'';
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;

      config = rec {
        modifier = "Mod4";
        bars = [ ];

        window.border = 0;

        gaps = {
          inner = 15;
          outer = 5;
        };

        keybindings = lib.mkOptionDefault {
          "XF86AudioMute" = "exec amixer set Master toggle";
          "XF86AudioLowerVolume" = "exec amixer set Master 4%-";
          "XF86AudioRaiseVolume" = "exec amixer set Master 4%+";
          "XF86MonBrightnessDown" = "exec brightnessctl set 4%-";
          "XF86MonBrightnessUp" = "exec brightnessctl set 4%+";
          "${modifier}+Return" = "exec ${pkgs.kitty}/bin/kitty";
          "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -modi drun -show drun";
          "${modifier}+Shift+d" = "exec ${pkgs.rofi}/bin/rofi -show window";
        };

        startup = [
          {
            command = "exec i3-msg workspace 1";
            always = true;
            notification = false;
          }
          {
            command = "exec feh --bg-scale ~/.background-image";
            always = true;
            notification = false;
          }
        ];
      };
    };
  };
}
