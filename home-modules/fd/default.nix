{ pkgs, home, ...}:

{
  home.packages = with pkgs; [fd];
  programs.zsh.shellAliases = {
    find = "fd";
  };
}
