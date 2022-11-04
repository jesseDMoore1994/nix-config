{ pkgs, ... }:

{
  imports = [
    ./home-modules/bat
    ./home-modules/exa
    ./home-modules/fd
    ./home-modules/firefox
    ./home-modules/fonts
    ./home-modules/kitty
    ./home-modules/neovim
    ./home-modules/polybar
    ./home-modules/rofi
    ./home-modules/starship
    ./home-modules/tmux
    ./home-modules/zoxide
    ./home-modules/zsh
  ];
  home = {
    username = "jmoore";
    homeDirectory = "/home/jmoore";
    packages = with pkgs; [
      btop
      git
      gnumake
      jq
      neofetch
      openconnect
      python3
      teams
      vivid
      wget
    ];
    stateVersion = "21.11";
  };
  programs.home-manager.enable = true;
}
