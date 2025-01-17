---@diagnostic disable-next-line: undefined-global
return {
	"neoclide/coc.nvim",
	branch = "master",
	build = "yarn install --frozen-lockfile",
	config = function()
		local vim = vim
		-- Some servers have issues with backup files, see #649
		vim.opt.backup = false
		vim.opt.writebackup = false
		-- Autocomplete
		function _G.check_back_space()
			local col = vim.fn.col(".") - 1
			return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
		end

		-- Use K to show documentation in preview window
		function _G.show_docs()
			local cw = vim.fn.expand("<cword>")
			if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
				vim.api.nvim_command("h " .. cw)
			elseif vim.api.nvim_eval("coc#rpc#ready()") then
				vim.fn.CocActionAsync("doHover")
			else
				vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
			end
		end

		-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
		vim.api.nvim_create_augroup("CocGroup", {})
		vim.api.nvim_create_autocmd("CursorHold", {
			group = "CocGroup",
			command = "silent call CocActionAsync('highlight')",
			desc = "Highlight symbol under cursor on CursorHold",
		})

		-- Setup formatexpr specified filetype(s)
		vim.api.nvim_create_autocmd("FileType", {
			group = "CocGroup",
			pattern = "typescript,json",
			command = "setl formatexpr=CocAction('formatSelected')",
			desc = "Setup formatexpr specified filetype(s).",
		})

		-- Update signature help on jump placeholder
		vim.api.nvim_create_autocmd("User", {
			group = "CocGroup",
			pattern = "CocJumpPlaceholder",
			command = "call CocActionAsync('showSignatureHelp')",
			desc = "Update signature help on jump placeholder",
		})

		-- Add `:Format` command to format current buffer
		vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

		-- Add `:OR` command for organize imports of the current buffer
		vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})
		-- Add (Neo)Vim's native statusline support
		-- NOTE: Please see `:h coc-status` for integrations with external plugins that
		-- provide custom statusline: lightline.vim, vim-airline
		vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

		vim.keymap.set(
			"i",
			"<C-n>",
			'coc#pum#visible() ? coc#pum#next(1) : "<C-n>"',
			{ silent = true, noremap = true, expr = true, replace_keycodes = false }
		)
		vim.keymap.set(
			"i",
			"<C-p>",
			'coc#pum#visible() ? coc#pum#prev(1) : "<C-p>"',
			{ silent = true, noremap = true, expr = true, replace_keycodes = false }
		)
		-- Make <CR> to accept selected completion item or notify coc.nvim to format
		-- <C-g>u breaks current undo, please make your own choice
		vim.keymap.set(
			"i",
			"<C-y>",
			'coc#pum#visible() ? coc#pum#confirm() : "<C-y>"',
			{ silent = true, noremap = true, expr = true, replace_keycodes = false }
		)
		-- Use <c-j> to trigger snippets
		vim.keymap.set("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
		-- Use <c-space> to trigger completion
		vim.keymap.set("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })
		-- Use `[g` and `]g` to navigate diagnostics
		-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
		vim.keymap.set("n", "[d", "<Plug>(coc-diagnostic-prev)", { silent = true })
		vim.keymap.set("n", "]d", "<Plug>(coc-diagnostic-next)", { silent = true })
		-- GoTo code navigation
		vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true })
		vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
		vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true })
		vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true })
		vim.keymap.set("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })
		-- Symbol renaming
		vim.keymap.set("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })
		-- Formatting selected code
		vim.keymap.set("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
		vim.keymap.set("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })

		-- Apply the most preferred quickfix action on the current line.
		vim.keymap.set("n", "<leader>qf", "<Plug>(coc-fix-current)", { silent = true, nowait = true })
		-- Map function and class text objects
		-- NOTE: Requires 'textDocument.documentSymbol' support from the language server
		vim.keymap.set("x", "if", "<Plug>(coc-funcobj-i)", { silent = true, nowait = true })
		vim.keymap.set("o", "if", "<Plug>(coc-funcobj-i)", { silent = true, nowait = true })
		vim.keymap.set("x", "af", "<Plug>(coc-funcobj-a)", { silent = true, nowait = true })
		vim.keymap.set("o", "af", "<Plug>(coc-funcobj-a)", { silent = true, nowait = true })
		vim.keymap.set("x", "ic", "<Plug>(coc-classobj-i)", { silent = true, nowait = true })
		vim.keymap.set("o", "ic", "<Plug>(coc-classobj-i)", { silent = true, nowait = true })
		vim.keymap.set("x", "ac", "<Plug>(coc-classobj-a)", { silent = true, nowait = true })
		vim.keymap.set("o", "ac", "<Plug>(coc-classobj-a)", { silent = true, nowait = true })
		-- Remap <C-f> and <C-b> to scroll float windows/popups
		---@diagnostic disable-next-line: redefined-local
		vim.keymap.set(
			"n",
			"<C-f>",
			'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"',
			{ silent = true, nowait = true, expr = true }
		)
		vim.keymap.set(
			"n",
			"<C-b>",
			'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"',
			{ silent = true, nowait = true, expr = true }
		)
		vim.keymap.set(
			"i",
			"<C-f>",
			'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"',
			{ silent = true, nowait = true, expr = true }
		)
		vim.keymap.set(
			"i",
			"<C-b>",
			'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"',
			{ silent = true, nowait = true, expr = true }
		)
		vim.keymap.set(
			"n",
			"<C-f>",
			'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"',
			{ silent = true, nowait = true, expr = true }
		)
		vim.keymap.set(
			"n",
			"<C-b>",
			'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"',
			{ silent = true, nowait = true, expr = true }
		) -- Do default action for next item
	end,
}
