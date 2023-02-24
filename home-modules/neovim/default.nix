{ pkgs, home, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = ''
      luafile ${./init.lua}
    '';

    plugins = with pkgs.vimPlugins; [
      dracula-vim
      vim-nix
    ];
  };
}
