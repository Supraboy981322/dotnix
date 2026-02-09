vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.api.nvim_create_user_command(
  "Reorder", --think "I just typed this, what was the 'reorder' command? oh, wait."
  function()
    vim.cmd("BufferOrderByBufferNumber")
  end,
  { desc = "dup of :BufferOrderByBufferNumber" }
)

--think "whoops, held shift for too long"
vim.api.nvim_create_user_command(
  "Redo",
  function()
    vim.cmd("redo")
  end,
  { desc = "dup of :redo" }
)

--think "whoops, held shift for too long"
vim.api.nvim_create_user_command(
  "W",
  function()
    vim.cmd("write")
    print("buffer saved")
  end,
  { desc = "dup of :w", }
)

--think "whoops, held shift for too long"
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

--`<leader>`+`e` for file tree
vim.keymap.set(
  "n",
  "<leader>e", --I keep forgetting this exists, I don't use it, so I don't remember
  ":Neotree<CR>", 
  { silent = true }
)

--`ctrl`+`s` to save
vim.keymap.set(
  {"v", "i", "n", "x"},
  "<C-s>", --think "save"
  "<Cmd>w<CR>",
  { noremap = true, silent = true }
)

--`alt`+`n` to move to next buffer
vim.keymap.set(
  "n",
  "<M-n>", --think "next"
  "<Cmd>bn<CR>", 
  { noremap = true, silent = true }
)

--`alt`+`b` to move to previous buffer
vim.keymap.set(
  { "n" },
  "<M-b>", --think "b... previous"
  "<Cmd>bp<CR>",
  { noremap = true, silent = true }
)

--`alt`+`del` to delete chunk after
vim.keymap.set(
  { "i" },
  "<M-del>", --think "more delete"
  '<Cmd>normal! "_dw<CR>',
  { noremap = true, silent = true }
)

--`alt`+`bs` to delete chunk before
vim.keymap.set(
  { "i" },
  "<M-BS>", --think "more backspace"
  '<Cmd>normal! "_db<CR>',
  { noremap = true, silent = true }
)

--`alt`+`;` to enter normal mode 
--  (from any mode, including term)
vim.keymap.set(
  {"v", "i", "n", "x", "t"},
  "<M-;>", --this one comes natural, no need to think
  "<C-\\><C-n>",
  { noremap = true, silent = true }
)

--`alt`+`p` to center buffer
vim.keymap.set(
  {"v", "i", "n", "x"},
  "<M-p>", --think "p... center"
  function()
    vim.cmd("NoNeckPain")
  end,
  { noremap = true, silent = true }
)


--- lsp stuff ---
vim.keymap.set(
  {"v", "i", "n", "x"},
  "<M-d>", --think "definition"
  function()
    vim.diagnostic.open_float()
  end,
  { noremap = true, silent = true }
)
vim.keymap.set(
  {"v", "i", "n", "x"},
  "<M-]>", --think "right is forward"
  function()
    vim.diagnostic.goto_next()
  end,
  { noremap = true, silent = true }
)
vim.keymap.set(
  {"v", "i", "n", "x"},
  "<M-[>", --think "left is back"
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
  "<M-h>", --think "'h' but more"
  "<C-o>h",
  { noremap = true, silent = true }
)
vim.keymap.set(
  {"v", "n", "s", "i"},
  "<M-j>", --think "'j' but more"
  "<C-o>j",
  { noremap = true, silent = true }
)
vim.keymap.set(
  {"v", "n", "s", "i"},
  "<M-k>", --think "'k' but more"
  "<C-o>k",
  { noremap = true, silent = true }
)
vim.keymap.set(
  {"v", "n", "s", "i"},
  "<M-l>", --think "'l' but more"
  "<C-o>l",
  { noremap = true, silent = true }
)

--telescope
vim.keymap.set(
  { "v", "i", "n", "x" },
  "<M-f>", --think "file"
  ":Telescope find_files<CR>",
  {
    noremap = true, silent = true,
    desc = "telescope find files"
  }
)
vim.keymap.set(
  { "v", "i", "n", "x" },
  "<M-g>", --think "grep"
  ":Telescope live_grep<CR>",
  {
    noremap = true, silent = true,
    desc = "telescope live grep"
  }
)
vim.keymap.set(
  { "v", "i", "n", "x" },
  "<M-/>",
  ":Telescope buffers<CR>",
  {
    noremap = true, silent = true,
    desc = "telescope buffers"
  }
)
vim.keymap.set(
  { "v", "i", "n", "x" },
  "<M-'>", --think "say"
  ":Telescope help_tags<CR>",
  {
    noremap = true, silent = true,
    desc = "telescope help tags"
  }
)
