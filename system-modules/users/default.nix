{ config, pkgs, ... }:
{
  users.users = {
    jmoore = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "dialout" ];
      shell = pkgs.zsh;
    };
  };
  programs.zsh.enable = true;
}
