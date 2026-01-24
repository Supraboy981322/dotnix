require("foo_bar_baz.set")
require("foo_bar_baz.kb")
require("foo_bar_baz.lsp")
require("foo_bar_baz.lazy")
require("foo_bar_baz.style")
require("foo_bar_baz.treesitter")
require("foo_bar_baz.setup")

--once fully started, run fn
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("BufferOrderByBufferNumber")
    vim.cmd("TransparentEnable")
  end,
})
