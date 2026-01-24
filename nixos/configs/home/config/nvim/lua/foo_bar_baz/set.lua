-- basic settings
vim.cmd("set nocompatible")          -- be "iMproved", required for Neovim
vim.cmd("filetype plugin indent on") -- enable file type detection, plugins, and indenting
vim.cmd("syntax enable")             -- enable syntax highlighting
vim.cmd("set encoding=utf-8")        -- set encoding to UTF-8
vim.cmd("set relativenumber")        -- show relative line numbers
vim.cmd("set number")                -- show absolute line number for the current line
vim.cmd("set autoindent")            -- enable auto-indentation
vim.cmd("set tabstop=2")             -- number of spaces a tab counts for
vim.cmd("set shiftwidth=2")          -- number of spaces to use for each step of (auto)indent
vim.cmd("set expandtab")             -- use spaces instead of tabs (doesn't work for some reason)
vim.cmd("set smartindent")           -- smart auto-indenting for C-like languages
vim.cmd("set mouse=")                -- enable mouse support in all modes
vim.cmd("set clipboard=unnamedplus") -- use system clipboard for copy/paste
vim.cmd("set signcolumn=yes")        -- always show the sign column

-- search settings
vim.cmd("set incsearch")   -- show search matches as you type
vim.cmd("set hlsearch")    -- highlight all search matches
vim.cmd("set ignorecase")  -- ignore case in search patterns
vim.cmd("set smartcase")   -- override ignorcase if search has uppercase

--i don't remember what this does,
--  but I'm afraid to remove it
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
