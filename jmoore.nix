{ pkgs, additionalModules ? [ ], additionalPackages ? [ ], ... }:

{
  imports = [
    ./home-modules/bat
    ./home-modules/dunst
    ./home-modules/exa
    ./home-modules/fd
    ./home-modules/firefox
    ./home-modules/fonts
    ./home-modules/kitty
    ./home-modules/neovim
    ./home-modules/nix
    ./home-modules/nix-direnv
    ./home-modules/nushell
    ./home-modules/rofi
    ./home-modules/starship
    ./home-modules/tmux
    ./home-modules/zoxide
    ./home-modules/zsh
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
      python3
      ranger
      scrot
      teams
      vivid
      vlc
      wget
    ] ++ additionalPackages;
    stateVersion = "21.11";
  };
  programs.home-manager.enable = true;
}
