pkgs:

{
  programs.eza.enable = true;
  programs.zsh.shellAliases = {
    ls = "eza -al --color=always --group-directories-first";
  };
}
