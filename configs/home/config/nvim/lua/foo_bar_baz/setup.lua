require("smear_cursor").setup({
  cursor_color = "#21f6bc",
  stiffness = 0.8,
  trailing_stiffness = 0.5,
  distance_stop_animating = 0.5,
})

require("todo-comments").setup({
  keywords = {
    FIX = {
      icon = "󰨰 ", color = "error",
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }
    },
    TODO = {
      icon = " ", color = "info"
    },
    HACK = {
      icon = "󰖷 ", color = "warning"
    },
    WARN = {
      icon = " ", color = "warning",
      alt = { "WARNING", "!!!" }
    },
  },
})
