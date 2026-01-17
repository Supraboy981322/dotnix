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
vim.api.nvim_set_keymap(
  'n', 'd', '"_d', 
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'v', 'd', '"_d',
  { noremap = true, silent = false }
)

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
  function()
    vim.cmd("NoNeckPain")
  end,
  { noremap = true, silent = true }
)


--- lsp stuff ---
vim.keymap.set(
  {"v", "i", "n", "x"},
  "<M-d>",
  function()
    vim.diagnostic.open_float()
  end,
  { noremap = true, silent = true }
)
