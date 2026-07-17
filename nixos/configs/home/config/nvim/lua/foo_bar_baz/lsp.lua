vim.lsp.enable("vala_ls")

vim.diagnostic.config({
  signs = {
    text = {
      [ vim.diagnostic.severity.ERROR ] = "", -- Nerd Font icon for error (a cross)
      [ vim.diagnostic.severity.WARN  ]  = "", -- Nerd Font icon for warning
      [ vim.diagnostic.severity.HINT  ]  = "", -- Nerd Font icon for hint
      [ vim.diagnostic.severity.INFO  ]  = "󰙎", -- Nerd Font icon for info    },
    },
  },
  virtual_text = { current_line = false },
  virtual_lines = { current_line = true },
  underline = true,
  update_in_insert = true,
})

vim.lsp.config('clangd', {
  cmd = {
    "/run/current-system/sw/bin/clangd",
    "--background-index", "--clang-tidy",
    "--log=verbose"
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = {
    ".git",
  },
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp", },
  callback = function()
    vim.lsp.enable("clangd")
  end,
})

vim.lsp.config('lua_ls', {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    '.emmyrc.json',
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
  settings = {
    Lua = {
      codeLens = { enable = true },
      hint = {
        enable = true,
        semicolon = "Disable"
      },
      diagnostics = {
        globals = {
          "vim",
          "require",
          "hl", --hyprland
        },
      },
      workspace = {
        library = {
          vim.fn.expand("$VIMRUNTIME"),
          vim.fn.expand("~/.config/hypr/stubs/"),
        };
        checkThirdParty = false,
      };
    },
  },
})

--local og_virt_text
--local og_virt_line
--vim.api.nvim_create_autocmd({ 'CursorMoved', 'DiagnosticChanged' }, {
--  group = vim.api.nvim_create_augroup('diagnostic_only_virtlines', {}),
--  callback = function()
--    if og_virt_line == nil then
--      og_virt_line = vim.diagnostic.config().virtual_lines
--    end
--
--    -- ignore if virtual_lines.current_line is disabled
--    if not (og_virt_line and og_virt_line.current_line) then
--      if og_virt_text then
--        vim.diagnostic.config({ virtual_text = og_virt_text })
--        og_virt_text = nil
--      end
--      return
--    end
--
--    if og_virt_text == nil then
--      og_virt_text = vim.diagnostic.config().virtual_text
--    end
--
--    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
--
--    if vim.tbl_isempty(vim.diagnostic.get(0, { lnum = lnum })) then
--      vim.diagnostic.config({ virtual_text = og_virt_text })
--    else
--      vim.diagnostic.config({ virtual_text = false })
--    end
--  end
--})


vim.lsp.config('zls', {
  cmd = { "zls" },
  root_dir = vim.fs.root(0, { "zls.json", "build.zig", ".git" }),
  settings = {
    zls = {
      enable_ast_check_diagnostics = true,
      warn_style = true,
      enable_semantic_tokens = true,
      enable_inlay_hints = true,
      inlay_hints_hide_redundant_param_names = true,
      inlay_hints_hide_redundant_param_names_last_token = true,
      include_at_in_builtins = true,
      max_detail_length = 1048576,
    }
  },
})
vim.lsp.enable({ 'zls' })
