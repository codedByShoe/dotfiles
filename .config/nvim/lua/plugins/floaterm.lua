return {
  "nvzone/floaterm",
  dependencies = "nvzone/volt",
  opts = {
    border = false,
    size_h = 60,
    size_w = 70,

    terminals = {
      { name = "Commands", cmd = "zsh" },
      { name = "Server", cmd = "zsh" },
      { name = "Claude", cmd = "zsh" },
      -- More terminals
    },
  },
  keys = {
    { "<c-`>", mode = { "n", "t" }, "<cmd>FloatermToggle<cr>", desc = "Toggle terminal" },
  },

  cmd = "FloatermToggle",
}
