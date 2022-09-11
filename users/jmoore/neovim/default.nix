pkgs:

{
  enable = true;
  vimAlias = true;
  extraConfig = ''
    luafile ${./init.lua}
  '';

  plugins = with pkgs.vimPlugins; [
    bufferline-nvim
    crates-nvim
    cmp-buffer
    cmp-cmdline
    cmp-nvim-lsp
    cmp-nvim-lsp-document-symbol
    cmp-nvim-lua
    cmp-path
    cmp_luasnip
    comment-nvim
    dracula-vim
    editorconfig-nvim
    gitsigns-nvim
    indent-blankline-nvim
    lightspeed-nvim
    lsp_signature-nvim
    lspkind-nvim
    lualine-nvim
    luasnip
    null-ls-nvim
    numb-nvim
    nvim-cmp
    nvim-code-action-menu
    nvim-colorizer-lua
    nvim-dap
    nvim-gps
    nvim-jdtls
    nvim-lspconfig
    nvim-notify
    nvim-tree-lua
    (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
    nvim-treesitter-textobjects
    nvim-web-devicons
    nvim_context_vt
    plenary-nvim
    popup-nvim
    ron-vim
    rust-tools-nvim
    telescope-nvim
    telescope-fzf-native-nvim
    trouble-nvim
    vim-fugitive
    vim-lastplace
    vim-markdown
    vim-nix
    vim-visual-multi
  ];
}
