-- FILE: lua/plugins/crates.lua
return {
	{
		"saecki/crates.nvim",
		ft = { "rust", "toml" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("crates").setup({
				completion = {
					cmp = {
						enabled = true,
					},
					crates = {
						enabled = true,
						max_results = 8,
						min_chars = 3,
					},
				},

				-- LSP интеграция
				lsp = {
					enabled = true,
					on_attach = function(client, bufnr)
						local map = function(keys, func, desc)
							vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
						end

						-- Основные команды для работы с crates
						map("<leader>ct", function()
							require("crates").toggle()
						end, "[C]rates [T]oggle popup")
						map("<leader>cr", function()
							require("crates").reload()
						end, "[C]rates [R]eload")
						map("<leader>cv", function()
							require("crates").show_versions_popup()
						end, "[C]rates [V]ersions")
						map("<leader>cf", function()
							require("crates").show_features_popup()
						end, "[C]rates [F]eatures")
						map("<leader>cd", function()
							require("crates").show_dependencies_popup()
						end, "[C]rates [D]ependencies")

						-- Обновление
						map("<leader>cu", function()
							require("crates").update_crate()
						end, "[C]rates [U]pdate")
						map("<leader>ca", function()
							require("crates").update_all_crates()
						end, "[C]rates Update [A]ll")
						map("<leader>cU", function()
							require("crates").upgrade_crate()
						end, "[C]rates [U]pgrade")
						map("<leader>cA", function()
							require("crates").upgrade_all_crates()
						end, "[C]rates Upgrade [A]ll")

						-- Открыть в браузере
						map("<leader>ch", function()
							require("crates").open_homepage()
						end, "[C]rates [H]omepage")
						map("<leader>cR", function()
							require("crates").open_repository()
						end, "[C]rates [R]epository")
						map("<leader>cD", function()
							require("crates").open_documentation()
						end, "[C]rates [D]ocumentation")
						map("<leader>cC", function()
							require("crates").open_crates_io()
						end, "[C]rates Open [C]rates.io")
					end,
					actions = true,
					completion = true,
					hover = true,
				},

				-- Настройки всплывающих окон
				popup = {
					autofocus = true,
					hide_on_select = true,
					copy_register = '"',
					style = "minimal",
					border = require("util.ui").border,
					show_version_date = true,
					show_dependency_version = true,
					max_height = 30,
					min_width = 20,
					padding = 1,
				},

				-- Автодополнение в источниках
				src = {
					cmp = {
						enabled = true,
					},
				},

				-- Интеграция с null-ls
				null_ls = {
					enabled = true,
					name = "crates.nvim",
				},
			})

			-- Автокоманда для автоматического обновления информации о crates
			vim.api.nvim_create_autocmd("BufRead", {
				group = vim.api.nvim_create_augroup("crates_toml", { clear = true }),
				pattern = "Cargo.toml",
				callback = function()
					require("crates").reload()
				end,
			})
		end,
	},
}
