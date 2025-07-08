-- FILE: lua/plugins/typescript-tools.lua
return {
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
		opts = {
			on_attach = function(client, bufnr)
				-- Отключаем форматирование через ts_ls, используем prettier/biome
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false

				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
				end

				-- TypeScript specific commands
				map("<leader>to", "<cmd>TSToolsOrganizeImports<cr>", "[T]ypeScript [O]rganize Imports")
				map("<leader>ts", "<cmd>TSToolsSortImports<cr>", "[T]ypeScript [S]ort Imports")
				map("<leader>tu", "<cmd>TSToolsRemoveUnused<cr>", "[T]ypeScript Remove [U]nused")
				map("<leader>tf", "<cmd>TSToolsFixAll<cr>", "[T]ypeScript [F]ix All")
				map("<leader>ta", "<cmd>TSToolsAddMissingImports<cr>", "[T]ypeScript [A]dd Missing Imports")
				map("<leader>tr", "<cmd>TSToolsRenameFile<cr>", "[T]ypeScript [R]ename File")
				map("<leader>tg", "<cmd>TSToolsGoToSourceDefinition<cr>", "[T]ypeScript [G]o to Source Definition")
			end,
			settings = {
				tsserver_file_preferences = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayVariableTypeHintsWhenTypeMatchesName = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		},
	},
}
