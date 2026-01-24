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

-- setup lazy.nvim
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
      "mason-org/mason.nvim",
      opts = {
        ui = {
          border = "rounded",
        },
      },
    },
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {
          "lua_ls",
          "gopls",
          "vtsls",
          "zls",
          "tailwindcss",
        },
        servers = {
          clangd = { mason = false, },
        },
      },
      dependencies = {
        "mason-org/mason.nvim",
        "neovim/nvim-lspconfig",
      },
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
    {
      "folke/todo-comments.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {},
    },
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
