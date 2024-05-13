{
  lib,
  pkgs,
  ...
}:
with lib;
with pkgs;
let
  name = "hervyqa";
  modifier = "Mod4";

  # navigation
  left = "h";
  down = "j";
  up = "k";
  right = "l";

  # colors
  blue_1 = "#99C1F1";
  blue_2 = "#62A0EA";
  blue_3 = "#3584E4";
  blue_4 = "#1C71D8";
  blue_5 = "#1A5FB4";
  green_1 = "#8FF0A4";
  green_2 = "#57E389";
  green_3 = "#33D17A";
  green_4 = "#2EC27E";
  green_5 = "#26A269";
  yellow_1 = "#F9F06B";
  yellow_2 = "#F8E45C";
  yellow_3 = "#F6D32D";
  yellow_4 = "#F5C211";
  yellow_5 = "#E5A50A";
  orange_1 = "#FFBE6F";
  orange_2 = "#FFA348";
  orange_3 = "#FF7800";
  orange_4 = "#E66100";
  orange_5 = "#C64600";
  red_1 = "#F66151";
  red_2 = "#ED333B";
  red_3 = "#E01B24";
  red_4 = "#C01C28";
  red_5 = "#A51D2D";
  purple_1 = "#DC8ADD";
  purple_2 = "#C061CB";
  purple_3 = "#9141AC";
  purple_4 = "#813D9C";
  purple_5 = "#613583";
  brown_1 = "#CDAB8F";
  brown_2 = "#B5835A";
  brown_3 = "#986A44";
  brown_4 = "#865E3C";
  brown_5 = "#63452C";
  light_1 = "#FFFFFF";
  light_2 = "#F6F5F4";
  light_3 = "#DEDDDA";
  light_4 = "#C0BFBC";
  light_5 = "#9A9996";
  dark_1 = "#77767B";
  dark_2 = "#5E5C64";
  dark_3 = "#3D3846";
  dark_4 = "#241F31";
  dark_5 = "#000000";
  dark_6 = "#242424";
  dark_7 = "#1E1E1E";

  window_bg_color = dark_6;
  window_fg_color = light_1;
  view_bg_color = dark_2;
  view_fg_color = light_1;
  accent_bg_color = blue_3;
  accent_fg_color = light_1;
  urgent_bg_color = red_4;
  urgent_fg_color = light_1;

in {
  programs.waybar.enable = true;
  programs.wpaperd = {
    enable = true;
    settings = {
      eDP-1 = {
        path = "/home/jmoore/.background_image";
      };
    };
  };
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "${modifier}";
      terminal = "kitty";
      bars = [{
        command = "waybar";
      }];
      focus = {
        #forceWrapping = false;
        #followMouse = false;
      };
      fonts = {
        names = ["Roboto"];
        size = 9.0;
      };
      gaps = {
        inner = 10;
      };
      startup = [
        { command = "autotiling"; }
        { command = "wpaperd"; }
      ];
      input = {
        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
        };
      };
      workspaceOutputAssign = let
        first = "eDP-1 VGA-1";
        second = "DP-1 DP-2 DP-3 DP-4 HDMI-A-1 HDMI-A-2";
      in [
        { output = first; workspace = "1"; }
        { output = first; workspace = "2"; }
        { output = first; workspace = "3"; }
        { output = first; workspace = "4"; }
        { output = first; workspace = "5"; }
        { output = second; workspace = "6"; }
        { output = second; workspace = "7"; }
        { output = second; workspace = "8"; }
        { output = second; workspace = "9"; }
        { output = second; workspace = "10"; }
      ];
      window = {
        border = 3;
        titlebar = false;
        commands = [
          {
            command = "floating enable, sticky enable";
            criteria.title = "Picture-in-Picture";
          }
          {
            command = "floating enable, sticky enable";
            criteria.title = ".*Sharing Indicator.*";
          }
        ];
      };
      assigns = {
        "1" = [
          { app_id = "foot"; }
        ];
        "2" = [
          { app_id = "org.qutebrowser.qutebrowser"; }
        ];
        "3" = [
          { app_id = "si.biolab.python3"; }
          { app_id = "spyder"; }
        ];
        "4" = [
          { app_id = "DBeaver"; }
          { app_id = "rstudio"; }
          { app_id = "sqlitebrowser"; }
        ];
        "5" = [
          { app_id = "vscode"; }
          { app_id = "vscodium"; }
        ];
        "6" = [
          { app_id = "texstudio"; }
          { app_id = "libreoffice-base"; }
          { app_id = "libreoffice-calc"; }
          { app_id = "libreoffice-draw"; }
          { app_id = "libreoffice-impress"; }
          { app_id = "libreoffice-math"; }
          { app_id = "libreoffice-writer"; }
        ];
        "7" = [
          { app_id = "lmms"; }
          { app_id = "org.kde.kdenlive"; }
          { app_id = "tenacity"; }
        ];
        "8" = [
          { app_id = "blender"; }
          { app_id = "inkscape"; }
          { app_id = "scribus"; }
          { app_id = "synfigstudio"; }
          { class = ".*Gimp-.*"; }
          { class = "krita"; }
        ];
        "9" = [
          { app_id = "org.telegram.desktop"; }
        ];
      };
      floating = {
        modifier = "${modifier}";
        border = 3;
        titlebar = false;
        criteria = [
          { app_id = ".themechanger-wrapped"; }
          { app_id = "at.yrlf.wl_mirror"; }
          { app_id = "imv"; }
          { app_id = "inkview"; }
          { app_id = "kvantummanager"; }
          { app_id = "mpv"; }
          { app_id = "org.pwmt.zathura"; }
          { app_id = "qt5ct"; }
          { app_id = "qt6ct"; }
          { app_id = "system-config-printer"; }
          { app_id = "wdisplays"; }
        ];
      };
      keybindings = mkOptionDefault {
        # rofi: menu
        "${modifier}+d" = "exec rofi -show drun";
        # rofi: clipboard manager
        "${modifier}+c" = "exec cliphist list | rofi -dmenu | cliphist decode | wl-copy";
        # rofi: bluetooth
        "${modifier}+y" = "exec rofi-bluetooth";
        # rofi: password store
        "${modifier}+e" = "exec rofi-pass";
        # rofi: emoji
        "${modifier}+m" = "exec rofi -modi emoji -show emoji";
        # pick color
        "${modifier}+n" = "exec wl-color-picker clipboard";
        # mirror screen
        "${modifier}+o" = "exec wl-present mirror";
  
        # modes
        "${modifier}+g" = "mode recording";
        "${modifier}+p" = "mode printscreen";
        "${modifier}+q" = "mode browser";
        "${modifier}+r" = "mode resize";
        "${modifier}+u" = "mode audio";
        "${modifier}+x" = "mode session";
  
        "${modifier}+period" = "workspace next";
        "${modifier}+comma" = "workspace prev";
  
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
  
        "${modifier}+Shift+period" = "move container to workspace next; workspace next";
        "${modifier}+Shift+comma" = "move container to workspace prev; workspace prev";
  
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
  
        "${modifier}+${left}" = "focus left";
        "${modifier}+${down}" = "focus down";
        "${modifier}+${up}" = "focus up";
        "${modifier}+${right}" = "focus right";
  
        "${modifier}+Ctrl+${left}" = "move workspace to output left";
        "${modifier}+Ctrl+${down}" = "move workspace to output down";
        "${modifier}+Ctrl+${up}" = "move workspace to output up";
        "${modifier}+Ctrl+${right}" = "move workspace to output right";
  
        "${modifier}+Shift+${left}" = "move left";
        "${modifier}+Shift+${down}" = "move down";
        "${modifier}+Shift+${up}" = "move up";
        "${modifier}+Shift+${right}" = "move right";
  
        # audio control
        "XF86AudioRaiseVolume" = "exec pamixer --increase 2";
        "XF86AudioLowerVolume" = "exec pamixer --decrease 2";
        "XF86AudioMute" = "exec pamixer --toggle-mute";
  
        # mic control
        "${modifier}+XF86AudioRaiseVolume" = "exec pamixer --default-source --increase 2";
        "${modifier}+XF86AudioLowerVolume" = "exec pamixer --default-source --decrease 2";
        "${modifier}+XF86AudioMute" = "exec pamixer --default-source -t";
  
        # brightness
        "XF86MonBrightnessUp" = "exec light -A 2";
        "XF86MonBrightnessDown" = "exec light -U 2";
      };
      colors = {
        background = window_bg_color;
        focused = {
          border = accent_bg_color;
          background = accent_bg_color;
          text = accent_fg_color;
          indicator = accent_bg_color;
          childBorder = accent_bg_color;
        };
        focusedInactive = {
          border = view_bg_color;
          background = view_bg_color;
          text = view_fg_color;
          indicator = view_bg_color;
          childBorder = view_bg_color;
        };
        unfocused = {
          border = view_bg_color;
          background = view_bg_color;
          text = view_fg_color;
          indicator = view_bg_color;
          childBorder = view_bg_color;
        };
        urgent = {
          border = urgent_bg_color;
          background = urgent_bg_color;
          text = urgent_fg_color;
          indicator = urgent_bg_color;
          childBorder = urgent_bg_color;
        };
        placeholder = {
          border = accent_bg_color;
          background = accent_bg_color;
          text = accent_fg_color;
          indicator = accent_bg_color;
          childBorder = accent_bg_color;
        };
      };
      modes = {
        audio = {
          # audio = "launch: [i]input [o]output";
          Escape = "mode default";
          Return = "mode default";
          "i" = "exec rofi-pulse-select source, mode default";
          "o" = "exec rofi-pulse-select sink, mode default";
        };
        browser = {
          # browser = "launch: [1]qutebrowser [2]private";
          Escape = "mode default";
          Return = "mode default";
          "1" = "exec qutebrowser, mode default";
          "2" = "exec qutebrowser --target private-window, mode default";
        };
        printscreen = {
          # printscreen = "launch: [1]save-area [2]save-all [3]copy-area [4]copy-all";
          Escape = "mode default";
          Return = "mode default";
          "1" = ''exec sleep 1.0; exec grim -g "$(slurp -d)" "$(xdg-user-dir PICTURES)/$(date +%Y%m%d_%Hh%Mm%Ss_@${name}.png)" | wl-copy -t image/png, mode default'';
          "2" = ''exec sleep 1.0; exec grim "$(xdg-user-dir PICTURES)/$(date +%Y%m%d_%Hh%Mm%Ss_@${name}.png)" | wl-copy -t image/png, mode default'';
          "3" = ''exec sleep 1.0; exec grim -g "$(slurp -d)" - | wl-copy -t image/png, mode default'';
          "4" = ''exec sleep 1.0; exec grim - | wl-copy -t image/png, mode default'';
        };
        recording = {
          # printscreen = "launch:
          # [1]area-with-audio [2]full-with-audio;
          # [3]area-without-audio [4]full-without-audio;
          # [0]stop-record";
          Escape = "mode default";
          Return = "mode default";
          "1" = ''exec sleep 1.0; exec wl-screenrec --low-power=off --filename="$(xdg-user-dir VIDEOS)/$(date +%Y%m%d_%Hh%Mm%Ss_@${name}.mp4)" --geometry "$(slurp -d)" --audio, mode default'';
          "2" = ''exec sleep 1.0; exec wl-screenrec --low-power=off --filename="$(xdg-user-dir VIDEOS)/$(date +%Y%m%d_%Hh%Mm%Ss_@${name}.mp4)" --audio, mode default'';
          "3" = ''exec sleep 1.0; exec wl-screenrec --low-power=off --filename="$(xdg-user-dir VIDEOS)/$(date +%Y%m%d_%Hh%Mm%Ss_@${name}.mp4)" --geometry "$(slurp -d)", mode default'';
          "4" = ''exec sleep 1.0; exec wl-screenrec --low-power=off --filename="$(xdg-user-dir VIDEOS)/$(date +%Y%m%d_%Hh%Mm%Ss_@${name}.mp4)", mode default'';
          "0" = ''exec sleep 1.0; exec pkill --signal INT wl-screenrec, mode default'';
        };
        resize = {
          Escape = "mode default";
          Return = "mode default";
          "${down}" = "resize grow height 5 px or 5 ppt";
          "${left}" = "resize shrink width 5 px or 5 ppt";
          "${right}" = "resize grow width 5 px or 5 ppt";
          "${up}" = "resize shrink height 5 px or 5 ppt";
        };
        session = {
          # session = launch:
          # [h]ibernate [p]oweroff [r]eboot
          # [s]uspend [l]ockscreen log[o]ut
          Escape = "mode default";
          Return = "mode default";
          "h" = "exec systemctl hibernate, mode default";
          "p" = "exec systemctl poweroff, mode default";
          "r" = "exec systemctl reboot, mode default";
          "s" = "exec systemctl suspend, mode default";
          "l" = "exec swaylock, mode default";
          "o" = "exec swaymsg exit, mode default";
        };
      };
    };
  };
}
