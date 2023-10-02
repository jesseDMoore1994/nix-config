{ pkgs, home, config, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file."${config.xdg.configHome}/nvim/bootstrap.lua" = {
    text = with pkgs; ''
      local lua_language_server = "${lua-language-server}/bin/lua-language-server"
      ${builtins.readFile ./_bootstrap.lua}
    '';
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = ''
      luafile ${config.xdg.configHome}/nvim/bootstrap.lua
    '';

    plugins = with pkgs.vimPlugins; [
      cmp-nvim-lsp
      nvim-cmp
      dracula-vim
      vim-nix
    ];

    extraPackages = with pkgs; [
      rnix-lsp
      haskell-language-server
      lua-language-server
    ];
  };
}
