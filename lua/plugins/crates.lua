-- FILE: lua/plugins/crates.lua
return {
	{
		"saecki/crates.nvim",
		ft = { "rust", "toml" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("crates").setup({
				-- Disable all completion integrations since we use blink.cmp
				completion = {
					cmp = {
						enabled = false,
					},
					coq = {
						enabled = false,
					},
				},

				-- Disable LSP integration
				lsp = {
					enabled = false,
					on_attach = function() end,
					actions = false,
					completion = false,
					hover = false,
				},

				-- Popup window settings
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

				-- Disable null-ls integration
				null_ls = {
					enabled = false,
				},

				-- Disable other integrations
				src = {
					cmp = {
						enabled = false,
					},
					coq = {
						enabled = false,
					},
				},
			})

			-- Keymaps for working with crates
			vim.api.nvim_create_autocmd("BufRead", {
				group = vim.api.nvim_create_augroup("crates_keymaps", { clear = true }),
				pattern = "Cargo.toml",
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
					end

					-- Main crates commands
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

					-- Update commands
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

					-- Open in browser
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
			})

			-- Auto-reload crates info when opening Cargo.toml
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
