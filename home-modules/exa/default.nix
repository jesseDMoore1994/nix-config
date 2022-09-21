pkgs:

{
  programs.exa.enable = true;
  programs.zsh.shellAliases = {
    ls = "exa -al --color=always --group-directories-first";
  };
}
