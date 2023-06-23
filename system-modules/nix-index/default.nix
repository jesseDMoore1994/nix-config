{ config, pkgs, ... }:
{
  programs.command-not-found.enable = false;
  programs.nix-index-database.comma.enable = true;
}
