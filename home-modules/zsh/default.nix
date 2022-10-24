pkgs:
{
  programs.zsh = {
    enable = true;
    enableCompletion = false; # enabled in oh-my-zsh
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "ssh-agent" ];
      theme = "";
    };
    initExtra = ''
      export LS_COLORS="$(vivid generate dracula)"
      neofetch
      '';
  };
}
