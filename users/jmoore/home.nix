{ config, pkgs, lib, ... }:
let
  customAlacritty = import ./alacritty;
  customNvim      = import ./neovim;
  customTmux      = import ./tmux;

in
  {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "jmoore";
    home.homeDirectory = "/home/jmoore";

    # set background
    home.file.".background-image".source = ./wallpapers/pastel_mesa.png;

    # enable font configuration in home manager
    fonts.fontconfig.enable = true;

    # allow teams even though it isn"t free software
    nixpkgs.config.allowUnfreePredicate = (pkg:
      builtins.elem (pkg.pname or (builtins.parseDrvName pkg.name).name) [
        "teams"
      ]
    );
    # package installation items
    home.packages = with pkgs; [
      bat
      exa
      fd
      feh
      firefox
      git
      jq
      (nerdfonts.override { fonts = [ "Hasklig" "Monoid" ]; })
      openconnect
      python3
      teams
      tmux
      wget
    ];

    programs.alacritty = customAlacritty pkgs;

    home.sessionVariables = {
      EDITOR = "nvim";
    };
    programs.neovim = customNvim pkgs;

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.tmux = customTmux pkgs;

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = false; # enabled in oh-my-zsh
      shellAliases = {
        sudo = "sudo ";
        ls = "exa -al --color=always --group-directories-first";
        cat = "bat";
        find = "fd";
        cd = "z";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "tmux" "ssh-agent" ];
        theme = "jonathan";
      };
    };

    services.picom = {
      enable = true;
    };
    xsession.enable = true;
    xsession.windowManager.i3 = {
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
          "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
        };

        startup = [
          {
            command = "exec i3-msg workspace 1";
            always = true;
            notification = false;
          }
          {
            command = "exec $(xrandr --output Virtual-1 --auto && xrandr --output Virtual-1 --mode 1920x1080)";
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

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "21.11";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  }
