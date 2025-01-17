local keymap = vim.keymap.set

-- Keymaps for better default experience
keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
keymap("i", "jk", "<Esc>", { silent = true })

-- Stay in indent mode
keymap("v", "<", "<gv", { silent = true })
keymap("v", ">", ">gv", { silent = true })

-- Easy insertion of a trailing ; or , from insert mode.
keymap("i", ";;", "<Esc>A;<Esc>")
keymap("i", ",,", "<Esc>A,<Esc>")

-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- " buffer switching
keymap("n", "<leader>wh", "<C-w>h", { silent = true, desc = "Window Split Left" })
keymap("n", "<leader>wl", "<C-w>l", { silent = true, desc = "Window Split Right" })
keymap("n", "<leader>wj", "<C-w>j", { silent = true, desc = "Window Split Up" })
keymap("n", "<leader>wk", "<C-w>k", { silent = true, desc = "Window Split Down" })
keymap("n", "<leader>wq", "<C-w>q", { silent = true, desc = "Window Split Kill" })

-- Maintain the cursor position when yanking a visual selection.
keymap("v", "y", "myy`y")
keymap("v", "Y", "myY`y")

-- Paste replace visual selection without copying it.
keymap("v", "p", '"_dP')

-- Navigate buffers
keymap("n", "<Tab>", ":bnext<CR>", { silent = true, desc = "Buffer Next" })
keymap("n", "<S-Tab>", ":bprevious<CR>", { silent = true, desc = "Buffer Previous" })

keymap("i", "jk", "<Esc>")

keymap("n", "[d", vim.diagnostic.goto_prev)
keymap("n", "]d", vim.diagnostic.goto_next)
keymap("n", "<leader>d", vim.diagnostic.open_float)
keymap("n", "<leader>q", vim.diagnostic.setloclist)
keymap("n", "<leader>te", ":lua MiniFiles.open()<CR>", { silent = true, desc = " Toggle file explorer" })
