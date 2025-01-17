return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = function()
		local theme = function()
			local colors = {
				darkgray = "#1a1b26",
				gray = "#414868",
				white = "#c0caf5",
				innerbg = nil,
				outerbg = nil,
				insert = "#73daca",
				normal = "#7aa2f7",
				visual = "#f7768e",
				replace = "#bb9af7",
				command = "#7dcfff",
			}
			return {
				inactive = {
					a = { fg = colors.white, bg = colors.outerbg, gui = "bold" },
					b = { fg = colors.white, bg = colors.outerbg },
					c = { fg = colors.white, bg = colors.innerbg },
				},
				visual = {
					a = { fg = colors.visual, bg = colors.outerbg, gui = "bold" },
					b = { fg = colors.white, bg = colors.outerbg },
					c = { fg = colors.white, bg = colors.innerbg },
				},
				replace = {
					a = { fg = colors.darkgray, bg = colors.outerbg, gui = "bold" },
					b = { fg = colors.white, bg = colors.outerbg },
					c = { fg = colors.white, bg = colors.innerbg },
				},
				normal = {
					a = { fg = colors.normal, bg = colors.outerbg, gui = "bold" },
					b = { fg = colors.white, bg = colors.outerbg },
					c = { fg = colors.white, bg = colors.innerbg },
				},
				insert = {
					a = { fg = colors.insert, bg = colors.outerbg, gui = "bold" },
					b = { fg = colors.white, bg = colors.outerbg },
					c = { fg = colors.white, bg = colors.innerbg },
				},
				command = {
					a = { fg = colors.command, bg = colors.outerbg, gui = "bold" },
					b = { fg = colors.white, bg = colors.outerbg },
					c = { fg = colors.white, bg = colors.innerbg },
				},
			}
		end
		return {
			options = {
				component_separators = { left = " ", right = " " },
				section_separators = { left = " ", right = " " },
				theme = theme,
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha" } },
				symbols = {
					modified = " ", -- Text to show when the file is modified
					readonly = "󰈡 ", -- Text to show when the file is readonly
				},
			},
			sections = {
				lualine_a = { { "mode", icon = "" } },
			},
			extensions = { "lazy", "toggleterm", "mason", "neo-tree", "trouble" },
		}
	end,
}
