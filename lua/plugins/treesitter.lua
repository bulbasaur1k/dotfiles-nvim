-- FILE: lua/plugins/treesitter.lua
return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"folke/ts-comments.nvim",
			"nvim-treesitter/nvim-treesitter-context",
		},
		build = ":TSUpdate",
		event = { "BufNewFile", "BufReadPost", "BufWritePre" },
		opts = {
			auto_install = true,
			ensure_installed = {
				"bash",
				"css",
				"dockerfile",
				"fish",
				"git_config",
				"git_rebase",
				"gitattributes",
				"gitcommit",
				"gitignore",
				"html",
				"javascript",
				"json",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"nix",
				"regex",
				"scss",
				"sql",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"vue",
				"yaml",
				"helm",
				"c_sharp",
				"rust",
				"toml",
				"python",
			},
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
			vim.filetype.add({ pattern = { ["%.env%.[%w_.-]+"] = "sh" } })
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufNewFile", "BufReadPost", "BufWritePre" },
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = true,
		},
	},
}
