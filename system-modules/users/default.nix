{ config, pkgs, ... }:
{
  users.users = {
    jmoore = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      shell = pkgs.zsh;
    };
  };
  programs.zsh.enable = true;
}
