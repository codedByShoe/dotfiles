return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "fannheyward/telescope-coc.nvim" },
	},
	config = function()
		require("telescope").setup({
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
				coc = {
					theme = "ivy",
					prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
					push_cursor_on_edit = true, -- save the cursor position to jump back in the future
					timeout = 3000, -- timeout for coc commands
				},
			},
			defaults = {
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						-- set to `false` if you want the input to be on the left and
						-- preview on the right
						prompt_position = "top",
						mirror = false,
						width = { padding = 0 },
						height = { padding = 0 },
						preview_cutoff = 100,
						preview_width = 0.5,
					},
				},
				-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#ignore-files-bigger-than-a-threshold
				preview = {
					filesize_limit = 1.0, -- MB
				},
				sorting_strategy = "ascending",
				prompt_prefix = " ",
				selection_caret = " ",
				path_display = { "smart" },
				file_ignore_patterns = { "node_modules", "vendor", "__pycache__", "bin", "obj" },
			},
			pickers = {
				buffers = { initial_mode = "normal", sort_mru = true, sort_lastused = true },
				diagnostics = { initial_mode = "normal" },
			},
		})

		-- Enable telescope fzf native, if installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		pcall(require("telescope").load_extension, "coc")
		-- pcall(require("telescope").load_extension("harpoon"), "harpoon")

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>sh", builtin.oldfiles, { silent = true, desc = "Show History" })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Show Open Buffers" })
		vim.keymap.set("n", "<leader>sb", function()
			builtin.current_buffer_fuzzy_find()
		end, { desc = "Search Buffer" })

		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "Live Grep Open Files" })
		vim.keymap.set("n", "<leader>sg", builtin.git_files, { desc = "Search Git Files" })
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search Files" })
		vim.keymap.set("n", "<leader>s?", builtin.help_tags, { desc = "Search Help" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search Workspace" })
		vim.keymap.set("n", "<leader>sl", builtin.live_grep, { desc = "Search Live Grep" })
		vim.keymap.set(
			"n",
			"<leader>sd",
			":Telescope coc diagnostics<CR>",
			{ desc = "Search Diagnostics", silent = true, nowait = true }
		)
		vim.keymap.set(
			"n",
			"<space>sc",
			":Telescope coc commands<CR>",
			{ desc = "Search Coc Commands", silent = true, nowait = true }
		)
		vim.keymap.set(
			"n",
			"<leader>ss",
			":Telescope coc workspace_symbols<CR>",
			{ desc = "Search Workspace Symbols", silent = true, nowait = true }
		)
		-- Remap keys for applying codeActions to the current buffer
		vim.keymap.set(
			"n",
			"<leader>ca",
			":Telescope coc line_code_actions<CR>",
			{ desc = "Show Code Actions", silent = true, nowait = true }
		)
	end,
}
