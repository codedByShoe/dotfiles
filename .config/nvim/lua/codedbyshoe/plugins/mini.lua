return {
	"echasnovski/mini.nvim",
	config = function()
		require("mini.surround").setup()
		require("mini.jump").setup()
		require("mini.icons").setup()
		require("mini.files").setup()
		require("mini.pairs").setup()
		require("mini.cursorword").setup()
		require("mini.comment").setup({
			mappings = {
				-- Toggle comment (like `gcip` - comment inner paragraph) for both
				-- Normal and Visual modes
				comment = "<space>/",

				-- Toggle comment on current line
				comment_line = "<space>/",

				-- Toggle comment on visual selection
				comment_visual = "<space>/",

				-- Define 'comment' textobject (like `dgc` - delete whole comment block)
				-- Works also in Visual mode if mapping differs from `comment_visual`
				textobject = "gc",
			},
		})
		require("mini.indentscope").setup({
			symbol = "|",
		})
		require("mini.ai").setup()
	end,
}
