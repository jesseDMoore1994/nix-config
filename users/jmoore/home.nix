{ config, pkgs, ... }:
let
  customNvim = import ./neovim;

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
      pkgs.neovim
      pkgs.starship
      pkgs.tmux
      pkgs.wget
      pkgs.firefox
      pkgs.zsh
      pkgs.git
      pkgs.openconnect
      pkgs.teams
      pkgs.python3
      (pkgs.nerdfonts.override { fonts = [ "Hasklig" ]; })
    ];

    programs.neovim = customNvim pkgs;

    programs.zsh = {
      enable = true;
      enableCompletion = false; # enabled in oh-my-zsh
      shellAliases = {
        vim = "nvim";
        sudo = "sudo ";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "tmux" ];
        theme = "jonathan";
      };
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.tmux = {
      enable = true;
      shortcut = "a";
      aggressiveResize = true;
      baseIndex = 1;
      newSession = true;
      clock24 = true;
      keyMode = "vi";
      # Stop tmux+escape craziness.
      escapeTime = 0;

      extraConfig = ''
        # Mouse works as expected
        set-option -g mouse on
        # easy-to-remember split pane commands
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        bind -T copy-mode-vi v send -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
        bind P paste-buffer
        bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
      '';
    };

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
