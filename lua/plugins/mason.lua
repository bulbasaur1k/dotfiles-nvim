-- plugins/mason.lua
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
				"phpactor",
				"pyright",
				"typescript-language-server", -- The package for ts_ls
				"biome",
				"marksman",
				"dockerls",
				"ansiblels",
				"rust_analyzer",
				"roslyn-unstable",
				"lua_ls",
				"yaml-language-server", -- The package for yamlls

				-- Formatters for conform.nvim
				"stylua", -- For Lua
				"ruff", -- For Python (includes ruff_format)
				"black", -- For Python (alternative)
				"taplo", -- For TOML
				"shfmt", -- For Shell scripts
				"rustfmt", -- For Rust
				"prettierd", -- For web languages (JS, CSS, HTML, Markdown)
				"php-cs-fixer", -- For PHP
				"alejandra", -- For Nix

				-- Linters for nvim-lint
				"shellcheck", -- For Shell scripts
				"hadolint", -- For Dockerfile
				"yamllint", -- For YAML
			},
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
		end,
	},
}
