{ config, pkgs, ... }:
{
  users.users = {
    jmoore = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      shell = pkgs.nushell;
    };
  };
}
