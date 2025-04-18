{
  pkgs
  #, doom
  , zellij
  , additionalModules ? [ ]
  , additionalPackages ? [ ]
  , ... 
}:

{
  imports = [
    ./home-modules/bat
    # doom.hmModule
    # ./home-modules/doom
    ./home-modules/dunst
    ./home-modules/emacs
    ./home-modules/eza
    ./home-modules/fd
    ./home-modules/firefox
    ./home-modules/fonts
    ./home-modules/kitty
    ./home-modules/neovim
    ./home-modules/nix
    ./home-modules/nix-direnv
    ((import ./home-modules/nushell) "${builtins.toString ./scripts}")
    ./home-modules/rofi
    ./home-modules/starship
    ./home-modules/tmux
    ./home-modules/user-updater
    (import ./home-modules/zellij pkgs { zellij = zellij; })
    ./home-modules/zoxide
    ./home-modules/zsh
    # move background somewhere I can get it
    { home.file.".background-image".source = ./wallpapers/nixos_dracula.png; }
  ] ++ additionalModules;
  home = {
    username = "jmoore";
    homeDirectory = "/home/jmoore";
    packages = with pkgs; [
      betterlockscreen
      btop
      discord
      git
      gnumake
      jq
      neofetch
      niv
      obs-studio
      openconnect
      pipes-rs
      prismlauncher
      python3
      ranger
      scrot
      vivid
      vlc
      wget
      # emacs reqs doom is adamant to manage itself
      ripgrep
      clang
      unzip
    ] ++ additionalPackages;
    stateVersion = "21.11";
  };
  programs.home-manager.enable = true;
}
