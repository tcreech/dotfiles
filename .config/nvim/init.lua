local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- Plug('https://github.com/junegunn/seoul256.vim.git')
Plug('https://github.com/rebelot/kanagawa.nvim')
Plug('https://github.com/nyoom-engineering/oxocarbon.nvim')

vim.call('plug#end')

vim.cmd("colorscheme kanagawa")
