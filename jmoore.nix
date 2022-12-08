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
    ./home-modules/nix-direnv
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
      discord
      git
      gnumake
      jq
      neofetch
      niv
      openconnect
      python3
      ranger
      teams
      vivid
      wget
    ];
    stateVersion = "21.11";
  };
  programs.home-manager.enable = true;
}
