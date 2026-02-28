--vim.filetype.add({
--  extension = {
--    kbd = "lisp",
--  },
--})

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
    "hyprlang",
    "commonlisp",
    "clojure",
    "fennel",
    "vala",
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
