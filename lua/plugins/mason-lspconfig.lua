-- FILE: lua/plugins/mason-lspconfig.lua
return {
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim" },
		opts = {
			ensure_installed = {
				"pyright",
				"ts_ls",
				"biome",
				"marksman",
				"dockerls",
				"ansiblels",
				"rust_analyzer",
				"lua_ls",
				"yamlls",
				"eslint",
				"tailwindcss",
				"html",
				"cssls",
				"jsonls",
			},
			automatic_installation = true,
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)
		end,
	},
}
