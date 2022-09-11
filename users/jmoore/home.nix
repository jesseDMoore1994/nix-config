{ config, pkgs, ... }:
let
  customNvim = import ./neovim;
  customTmux = import ./tmux;

in
  {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "jmoore";
    home.homeDirectory = "/home/jmoore";

    # enable font configuration in home manager
    fonts.fontconfig.enable = true;

    # package installation items
    home.packages = [
      pkgs.starship
      pkgs.tmux
      pkgs.wget
      pkgs.firefox
      pkgs.zsh
      pkgs.git
      pkgs.openconnect
      pkgs.teams
      pkgs.python3
      pkgs.exa
      (pkgs.nerdfonts.override { fonts = [ "Hasklig" ]; })
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };
    programs.neovim = customNvim pkgs;

    programs.zsh = {
      enable = true;
      enableCompletion = false; # enabled in oh-my-zsh
      shellAliases = {
        sudo = "sudo ";
	ls = "exa -al --color=always --group-directories-first";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "tmux" "ssh-agent" ];
        theme = "jonathan";
      };
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.tmux = customTmux pkgs;

    nixpkgs.config.allowUnfreePredicate = (pkg:
      builtins.elem (pkg.pname or (builtins.parseDrvName pkg.name).name) [
        "teams"
      ]
    );

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
