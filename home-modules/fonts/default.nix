{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.hasklug
    nerd-fonts.monoid
  ];
}
