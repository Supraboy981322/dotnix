vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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
vim.keymap.set(
  { 'n', 'v' },
  'd',
  '"_d',
  { noremap = true, silent = true }
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
  { "n" },
  "<M-b>",
  "<Cmd>bp<CR>",
  { noremap = true, silent = true }
)

--`alt`+`del` to delete chunk after
vim.keymap.set(
  { "i" },
  "<M-del>",
  '<Cmd>normal! "_dw<CR>',
  { noremap = true, silent = true }
)

--`alt`+`bs` to delete chunk before
vim.keymap.set(
  { "i" },
  "<M-BS>",
  '<Cmd>normal! "_db<CR>',
  { noremap = true, silent = true }
)

--`alt`+`;` to enter normal mode
--  (from any mode, including term)
vim.keymap.set(
  {"v", "i", "n", "x", "t"},
  "<M-;>",
  "<C-\\><C-n>",
  { noremap = true, silent = true }
)

--`alt`+`p` to center buffer
vim.keymap.set(
  {"v", "i", "n", "x"},
  "<M-p>",
  function()
    vim.cmd("NoNeckPain")
  end,
  { noremap = true, silent = true }
)


vim.keymap.set(
  {"v", "i", "n", "x"},
  "<M-]>",
  function()
    vim.diagnostic.goto_next()
  end,
  { noremap = true, silent = true }
)
vim.keymap.set(
  {"v", "i", "n", "x"},
  "<M-[>",
  function()
    vim.diagnostic.goto_prev()
  end,
  { noremap = true, silent = true }
)

--disable arrow keys
vim.keymap.set(
  {"v", "n", "s", "i"},
  "<left>",
  function()
    local cur = vim.fn.mode()
    local key = "h"
    local dir = "left"
    if cur == "i" then
      key = "<M-"..key..">"
    else
      key = "<"..key..">"
    end
    print("use "..key.." to move "..dir)
  end,
  { noremap = true, silent = false }
)
vim.keymap.set(
  {"v", "n", "s", "i"},
  "<right>",
  function()
    local cur = vim.fn.mode()
    local key = "l"
    local dir = "right"
    if cur == "i" then
      key = "<M-"..key..">"
    else
      key = "<"..key..">"
    end
    print("use "..key.." to move "..dir)
  end,
  { noremap = true, silent = false }
)
vim.keymap.set(
  {"v", "n", "s", "i"},
  "<up>",
  function()
    local cur = vim.fn.mode()
    local key = "k"
    local dir = "up"
    if cur == "i" then
      key = "<M-"..key..">"
    else
      key = "<"..key..">"
    end
    print("use "..key.." to move "..dir)
  end,
  { noremap = true, silent = false }
)
vim.keymap.set(
  {"v", "n", "s", "i"},
  "<down>",
  function()
    local cur = vim.fn.mode()
    local key = "j"
    local dir = "down"
    if cur == "i" then
      key = "<M-"..key..">"
    else
      key = "<"..key..">"
    end
    print("use "..key.." to move "..dir)
  end,
  { noremap = true, silent = false }
)

-- map 'ctrl'+['h', 'j', 'k', or 'l'] to normal mode motion
vim.keymap.set(
  {"v", "n", "s", "i"},
  "<M-h>",
  "<C-o>h",
  { noremap = true, silent = true }
)
vim.keymap.set(
  {"v", "n", "s", "i"},
  "<M-j>",
  "<C-o>j",
  { noremap = true, silent = true }
)
vim.keymap.set(
  {"v", "n", "s", "i"},
  "<M-k>",
  "<C-o>k",
  { noremap = true, silent = true }
)
vim.keymap.set(
  {"v", "n", "s", "i"},
  "<M-l>",
  "<C-o>l",
  { noremap = true, silent = true }
)

--telescope
vim.keymap.set(
  { "v", "i", "n", "x" },
  "<M-f>",
  "<Cmd>:Telescope find_files<CR>",
  {
    noremap = true, silent = true,
    desc = "telescope find files"
  }
)
vim.keymap.set(
  { "v", "i", "n", "x" },
  "<M-g>",
  "<Cmd>:Telescope live_grep<CR>",
  {
    noremap = true, silent = true,
    desc = "telescope live grep"
  }
)
vim.keymap.set(
  { "v", "i", "n", "x" },
  "<M-/>",
  "<Cmd>:Telescope buffers<CR>",
  {
    noremap = true, silent = true,
    desc = "telescope buffers"
  }
)
