-- FILE: lua/plugins/conform.lua
return {
	{
		"stevearc/conform.nvim",
		dependencies = { "folke/snacks.nvim" },
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			-- Настраиваем форматтеры, которые будут запускаться для каждого типа файла.
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format", "black" },
				rust = { "rustfmt" },
				toml = { "taplo" },
				cs = { "csharpier" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				jsonc = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
				sh = { "shfmt" },
				css = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				nix = { "alejandra" },
				["_"] = { "trim_whitespace" },
			},

			-- Включаем автоматическое форматирование при сохранении.
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)

			-- Инициализация Snacks для переключения форматирования
			local snacks = require("snacks")
			snacks.toggle
				.new({
					name = "formatting",
					get = function()
						return not vim.b.disable_autoformat
					end,
					set = function(state)
						vim.b.disable_autoformat = not state
					end,
				})
				:map("<leader>tf")

			-- Ручное форматирование
			vim.keymap.set({ "n", "v" }, "<leader>cf", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "Format buffer" })
		end,
	},
}
