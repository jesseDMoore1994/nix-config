{ config, pkgs, ... }:
{
  users.users = {
    jmoore = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
      shell = pkgs.zsh;
    };
  };
}
