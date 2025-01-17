return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"mfussenegger/nvim-dap-python",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			local pythonPath = function()
				---@diagnostic disable-next-line: undefined-field
				local cwd = vim.loop.cwd()
				if vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
					return cwd .. "/.venv/bin/python"
				else
					return "/usr/bin/python"
				end
			end

			require("dapui").setup()
			require("dap-go").setup()
			require("dap-python").setup(pythonPath())
			require("nvim-dap-virtual-text").setup({})

			vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#cc0000" }) -- Red
			vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#cc0000" }) -- Red
			vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" }) -- Blue
			vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" }) -- Green
			vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#31353f" })

			local dap_signs = {
				Breakpoint = { text = "⏺", texthl = "DapBreakpoint", linehl = "", numhl = "" },
				BreakpointCondition = { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" },
				LogPoint = { text = "⟲", texthl = "DapLogPoint", linehl = "", numhl = "" },
				BreakpointRejected = { text = "✖", texthl = "DapBreakpointRejected", linehl = "", numhl = "" },
				Stopped = { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" },
			}

			for name, sign in pairs(dap_signs) do
				vim.fn.sign_define("Dap" .. name, sign)
			end

			vim.keymap.set(
				"n",
				"<leader>db",
				dap.toggle_breakpoint,
				{ silent = true, desc = "debug toggle breakpoint" }
			)
			vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { silent = true, desc = "debug to cursor" })

			-- Eval var under cursor
			vim.keymap.set("n", "<leader>dv", function()
				require("dapui").eval(nil, { enter = true })
			end, { silent = true, desc = "debug var under cursor" })

			vim.keymap.set("n", "<leader>dc", dap.continue, { silent = true, desc = "debug continue" })
			vim.keymap.set("n", "<leader>du", "<CMD> DapUiToggle<CR>", { silent = true, desc = "debug UI toggle" })
			vim.keymap.set("n", "<leader>di", dap.step_into, { silent = true, desc = "debug step into" })
			vim.keymap.set("n", "<leader>do", dap.step_over, { silent = true, desc = "debug step over" })
			vim.keymap.set("n", "<leader>dO", dap.step_out, { silent = true, desc = "debug step out" })
			vim.keymap.set("n", "<leader>dB", dap.step_back, { silent = true, desc = "debug step back" })
			vim.keymap.set("n", "<leader>dr", dap.restart, { silent = true, desc = "debug restart" })

			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},
}
