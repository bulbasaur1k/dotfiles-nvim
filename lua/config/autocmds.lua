-- config/autocmds.lua

local function augroup(name)
	return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"query",
		"spectre_panel",
		"grug-far",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Enable spell checking for text files and fix E763 error
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "markdown", "text" },
	callback = function()
		-- Skip if inside an obsidian vault (obsidian plugin handles its own spell check)
		if vim.fn.expand("%:p"):match(vim.fn.expand("~") .. "/obsidian/") then
			return
		end

		vim.opt_local.wrap = true
		vim.opt_local.spell = true
		-- Set Russian as the primary language to define word characters, fixing E763
		vim.opt_local.spelllang = "ru,en"

		-- Setup spellfiles for each language
		local spell_langs = { "ru", "en" }
		local spellfiles = {}
		for _, lang in ipairs(spell_langs) do
			table.insert(spellfiles, vim.fn.expand("~/.config/local-spell/" .. lang .. ".utf-8.add"))
		end
		vim.opt_local.spellfile = table.concat(spellfiles, ",")
	end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = augroup("json_conceal"),
	pattern = { "json", "jsonc", "json5" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

-- Disable diagnostic for .env files
vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Disable diagnostic for .env files",
	pattern = ".env",
	callback = function(ev)
		vim.diagnostic.enable(false, { bufnr = ev.buf })
	end,
})

-- Format on save using Conform
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		require("conform").format({ bufnr = args.buf, async = true })
	end,
})
