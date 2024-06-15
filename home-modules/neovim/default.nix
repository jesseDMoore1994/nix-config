{ pkgs, config, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file."${config.xdg.configHome}/nvim/bootstrap.lua" = {
    text = with pkgs; ''
      local storepaths = {}

      function storepaths.lua_language_server()
        return "${lua-language-server}/bin/lua-language-server"
      end
      function storepaths.pyright()
        return "${pyright}/bin/pyright-langserver"
      end
      function storepaths.nil_ls()
        return "${nil}/bin/nil"
      end
      function storepaths.haskell_language_server()
        return "${haskell-language-server}/bin/hls"
      end

      ${builtins.readFile ./bootstrap.lua}
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
      pyright
      nil
      haskell-language-server
      lua-language-server
    ];
  };
}
