--catppuccin color scheme with no bg
vim.o.termguicolors = true
--vim.cmd[[colorscheme tokyonight-moon]]
vim.cmd[[colorscheme ayu-dark]]
--vim.cmd[[colorscheme catppuccin]]

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    for name, modification in pairs({

      --transparency
      Normal      = { bg = "none" },
      NormalFloat = { bg = "none" },
      FloatBorder = { bg = "none" },
      Pmenu       = { bg = "none" },

      --visual mode highlight that's easier to see (in my terminal)
      Visual = { bg = "#3b2b2a" },

      --brighter line numbers, and colorize current line
      LineNr      = { fg = "#ffc777" },
      LineNrAbove = { fg = "#3b4261" },
      LineNrBelow = { fg = "#3b4261" },

      --minor tabbar change
      TabLine     = { fg = "#636a72", bg = "#05070a" },
      TabLineSel  = { fg = "#bfbdb6", bg = "#0b0e14" },
      TabLineFill = { fg = "#bfbdb6", bg = "#000000" },

    }) do
      vim.api.nvim_set_hl(0, name, modification)
    end
  end,
})
