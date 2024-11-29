-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps hereby
vim.keymap.set("i", "jk", "<Esc>")

vim.keymap.set("n", "<leader>fh", "<CMD> Telescope oldfiles theme=ivy<CR>", { desc = "Show History" })
vim.keymap.set(
  "n",
  "<leader><space>",
  "<CMD> Telescope buffers sort_mru=true sort_lastused=true initial_mode=normal theme=ivy<CR>",
  { desc = "Show Open Buffers" }
)
vim.keymap.set("n", "<leader>fg", "<CMD> Telescope git_files theme=ivy<CR>", { desc = "Search Git Files" })
vim.keymap.set("n", "<leader>ff", "<CMD> Telescope find_files theme=ivy<CR>", { desc = "Search Files" })
vim.keymap.set("n", "<leader>f?", "<CMD> Telescope help_tags theme=ivy<CR>", { desc = "Search Help" })
vim.keymap.set("n", "<leader>fw", "<CMD> Telescope grep_string theme=ivy<CR>", { desc = "Search Workspace" })
vim.keymap.set(
  "n",
  "<leader>fl",
  "<CMD> Telescope live_grep grep_open_files=true theme=ivy<CR>",
  { desc = "Search Live Grep" }
)
vim.keymap.set(
  "n",
  "<leader>fd",
  "<CMD> Telescope diagnostics initial_mode=normal theme=ivy<CR>",
  { desc = "Search Diagnostics" }
)
