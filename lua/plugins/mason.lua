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
				-- LSP servers
				"phpactor", -- PHP
				"pyright", -- Python
				"php-cs-fixer",
				"tsserver", -- JS/TS/React
				"marksman", -- Markdown/Obsidian
				"dockerls", -- Docker
				"ansiblels", -- Ansible
				"rust_analyzer", -- Rust
				"lua_ls", -- Lua
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
		end,
	},
}
