{ config, pkgs, ... }:
{
  users.users = {
    jmoore = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "atticd" ];
      shell = pkgs.nushell;
    };
    atticd = {
      isSystemUser = true;
      group = "atticd";
    };
  };
  users.groups.atticd = {};
}
