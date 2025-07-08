-- FILE: lua/plugins/mason.lua
return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			ensure_installed = {
				-- LSP Servers
				"pyright",
				"typescript-language-server",
				"biome",
				"marksman",
				"dockerfile-language-server",
				"ansible-language-server",
				"rust-analyzer",
				"roslyn",
				"lua-language-server",
				"yaml-language-server",
				"eslint-lsp",
				"tailwindcss-language-server",
				"html-lsp",
				"css-lsp",
				"json-lsp",

				-- Formatters for conform.nvim
				"stylua",
				"ruff",
				"black",
				"taplo",
				"shfmt",
				"rustfmt",
				"prettierd",
				"prettier",
				"alejandra",
				"csharpier",

				-- Linters for nvim-lint
				"shellcheck",
				"hadolint",
				"yamllint",
				"eslint_d",

				-- DAP
				"codelldb",
				"netcoredbg",
				"js-debug-adapter",
			},
			registries = {
				"github:mason-org/mason-registry",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
		end,
	},
}
