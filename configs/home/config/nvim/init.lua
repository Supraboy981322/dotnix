--[[                                                                       ]]
--[[  ██████   █████                   █████   █████  ███                  ]]
--[[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]]
--[[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]]
--[[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]]
--[[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]]
--[[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]]
--[[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]]
--[[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]]
--[[                                                                       ]]

--- Basic Settings ---
vim.cmd("set nocompatible")          -- Be iMproved, required for Neovim
vim.cmd("filetype plugin indent on") -- Enable file type detection, plugins, and indenting
vim.cmd("syntax enable")             -- Enable syntax highlighting
vim.cmd("set encoding=utf-8")        -- Set encoding to UTF-8
vim.cmd("set relativenumber")        -- Show relative line numbers
vim.cmd("set number")                -- Show absolute line number for the current line
vim.cmd("set autoindent")            -- Enable auto-indentation
vim.cmd("set tabstop=2")             -- Number of spaces a tab counts for
vim.cmd("set shiftwidth=2")          -- Number of spaces to use for each step of (auto)indent
vim.cmd("set expandtab")             -- Use spaces instead of tabs (doesn't work for some reason)
vim.cmd("set smartindent")           -- Smart auto-indenting for C-like languages
vim.cmd("set mouse=")                -- Enable mouse support in all modes
vim.cmd("set clipboard=unnamedplus") -- Use system clipboard for copy/paste
vim.cmd("set signcolumn=yes")        -- Always show the sign column

--- Search Settings ---
vim.cmd("set incsearch")   -- Show search matches as you type
vim.cmd("set hlsearch")    -- Highlight all search matches
vim.cmd("set ignorecase")  -- Ignore case in search patterns
vim.cmd("set smartcase")   --override ignorcase if search has uppercase

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { --color scheme
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    { --alternative color scheme
      "navarasu/onedark.nvim",
      name = "onedark",
      priority = 999,
      config = function()
        require('onedark').setup {
          style = 'darker'
        }
        require('onedark').load()
      end
    },
    {
      "sphamba/smear-cursor.nvim",
      opts = {
        --smear when switching buffers and windows
        smear_between_buffers = true;
        --smear when moving within line or to nearby lines
        smear_between_neighbor_lines = true;
        --draw smear in buffer instead of screen on scroll
        scroll_buffer_space = true;
        --smear in insert mode
        smear_insert_mode = true;
        --set color to match ghostty cursor
        cursor_color = "#21f6bc";
      },
    },
    {
      "vhyrro/luarocks.nvim",
      priority = 9999, -- Very high priority is required
      config = true,
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      lazy = false
    },
    {
      "xiyaowong/transparent.nvim",
      lazy = false
    },
    {
      "vim-airline/vim-airline",
      lazy = false,
      priority = 1000,
      dependencies = {
        {"vim-airline/vim-airline-themes"},
        {"ryanoasis/vim-devicons"}, 
      }
    },
    {
      "romgrk/barbar.nvim",
      dependencies = {
        "lewis6991/gitsigns.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      init = function() vim.g.barbar_auto_setup = false end,
      opts = {
        exclude_name = {
          "rightpad",
          "leftpad",
        },
      },
      version = "^1.0.0",
    },
    {
      "nvim-treesitter/nvim-treesitter",
      branch = 'master',
      lazy = false,
      build = ":TSUpdate"
    },
    {
      "nvim-tree/nvim-web-devicons",
      opts = {}
    },
    {
      "shortcuts/no-neck-pain.nvim",
      version = "*"
    },
    {
      "rmagatti/auto-session",
      lazy = false,
      ---enables autocomplete for opts
      ---@module "auto-session"
      ---@type AutoSession.Config
      opts = {
        suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      },
    },
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

require("smear_cursor").setup({
  cursor_color = "#21f6bc",
  stiffness = 0.8,
  trailing_stiffness = 0.5,
  distance_stop_animating = 0.5,
})

vim.api.nvim_create_user_command(
  "Reorder",
  function()
    vim.cmd("BufferOrderByBufferNumber")
  end,
  { desc = "dup of :BufferOrderByBufferNumber" }
)

vim.api.nvim_create_user_command(
  "Redo",
  function()
    vim.cmd("redo")
  end,
  { desc = "dup of :redo" }
)

vim.api.nvim_create_user_command(
  "W",
  function()
    vim.cmd("write")
    print("buffer saved")
  end,
  { desc = "dup of :w", }
)

vim.api.nvim_create_user_command(
  "Q",
  function(opts)
    if opts.bang then
      vim.cmd("q!")
    else
      vim.cmd("q")
    end
  end,
  { bang = true, desc = "quit neovim" }
)

--make `d` not yank
vim.api.nvim_set_keymap(
  'n', 'd', '"_d', 
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'v', 'd', '"_d',
  { noremap = true, silent = false }
)

--i don't remember what this does,
--  but I'm afraid to remove it
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--once fully started, run fn
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("BufferOrderByBufferNumber")
    vim.cmd("TransparentEnable")
  end,
})

--set `<leader>` key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--`<leader>`+`e` for file tree
vim.keymap.set(
  "n",
  "<leader>e",
  ":Neotree<CR>",
  { silent = true }
)

--`ctrl`+`s` to save
vim.keymap.set(
  {"v", "i", "n", "x"},
  "<C-s>",
  "<Cmd>w<CR>",
  { noremap = true, silent = true }
)

--`alt`+`n` to move to next buffer
vim.keymap.set(
  "n",
  "<M-n>",
  "<Cmd>bn<CR>",
  { noremap = true, silent = true }
)

--`alt`+`b` to move to previous buffer
vim.keymap.set(
  "n",
  "<M-b>",
  "<Cmd>bp<CR>",
  { noremap = true, silent = true }
)

--`alt`+`del` to delete chunk after
vim.keymap.set(
  "i",
  "<M-del>",
  '<Cmd>normal! "_dw<CR>',
  { noremap = true, silent = true }
)

--`alt`+`bs` to delete chunk before
vim.keymap.set(
  "i",
  "<M-BS>",
  '<Cmd>normal! "_db<CR>',
  { noremap = true, silent = true }
)

--`alt`+`;` to enter normal mode 
--  (from any mode, including term)
vim.keymap.set(
  {"v", "i", "n", "x", "t"},
  "<M-;>", "<C-\\><C-n>", 
  { noremap = true, silent = true }
)

--`alt`+`p` to center buffer
vim.keymap.set(
  {"v", "i", "n", "x"},
  "<M-p>",
  "<Cmd>NoNeckPain<CR>",
  { noremap = true, silent = true }
)

--catppuccin color scheme with no bg
vim.cmd[[colorscheme tokyonight-moon]]
--vim.cmd[[colorscheme catppuccin]]
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })

require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "c",
    "cpp",
    "lua",
    "vim",
    "vimdoc",
    "python",
    "javascript",
    "typescript",
    "go",
    "html",
    "xml",
    "css",
    "json",
    "rust",
    "zig",
    "ocaml",
    "bash",
    "jsdoc",
    "markdown",
    "query",
    "dart",
    "java",
    "nix",
    "hyprlang"
  },
  sync_install = false,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
}

vim.filetype.add({
  extension = {
    elh = "html",
    bhtm = "html",
    bhtml = "html",
  },
})

vim.treesitter.language.register(
  'html', { 'elh', 'bhtm', 'bhtml' }
)
