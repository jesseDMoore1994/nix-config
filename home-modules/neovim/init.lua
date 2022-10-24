local api = vim.api
local b = vim.b
local g = vim.g
local map = vim.keymap.set
local o = vim.o

vim.cmd("colorscheme dracula")

o.clipboard = "unnamedplus"
o.completeopt = "menuone,noinsert,noselect"
o.cursorline = true
o.expandtab = true
o.ignorecase = true
o.list = true
o.listchars = "eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣"
o.mouse = "a"
o.foldenable = false
o.showmode = false
o.swapfile = false
o.number = true
o.relativenumber = true
o.scrolloff = 2
o.shiftwidth = 4
o.shortmess = "aoOtTIcF"
o.showtabline = 2
o.signcolumn = "yes"
o.smartcase = true
o.smartindent = true
o.splitbelow = true
o.splitright = true
o.termguicolors = true
o.timeoutlen = 400
o.title = true
o.updatetime = 300

api.nvim_command([[
hi! Normal ctermbg=NONE guibg=NONE
]])
