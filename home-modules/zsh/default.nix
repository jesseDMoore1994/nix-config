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
    initContent = ''
      export LS_COLORS="$(vivid generate dracula)"
      eval "$(direnv hook zsh)"
      fastfetch
    '';
    shellAliases = {
      work = "ssh jmoore@jmoore-nixos.adtran.com";
      nc = "cd $HOME/projects/nix-config";
      ncga = "nc; ./scripts/apply_system.hs; cd -";
      ncas = "nc; ./scripts/apply_system.hs; cd -";
      ncau = "nc; ./scripts/apply_user.hs; cd -";
      ncu = "nc; ./scripts/update.hs; cd -";
      icat = "kitty +kitten icat";
      ":q" = "exit";
      doom = "~/.config/emacs/bin/doom";
    };
  };
}
