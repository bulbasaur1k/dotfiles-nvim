-- FILE: lua/plugins/whichkey.lua
return {
	{
		"folke/which-key.nvim",
		event = { "VeryLazy" },
		opts = function()
			return {
				preset = "helix",
				icons = {
					mappings = true,
					rules = {
						{ plugin = "undotree", icon = "", color = "blue" },
						{ pattern = "[neo]vim", icon = "", color = "green" },
					},
				},
				defaults = {},
				spec = {
					{
						mode = { "n", "v" },
						{ "[", group = "prev" },
						{ "]", group = "next" },
						{ "z", group = "fold" },
						{ "<leader>b", group = "buffer" },
						{ "<leader>c", group = "code/crates" },
						{ "<leader>d", group = "debug/dotnet" },
						{ "<leader>f", group = "file/find" },
						{ "<leader>g", group = "git" },
						{ "<leader>l", group = "lsp" },
						{ "<leader>n", group = "notifications" },
						{ "<leader>o", group = "obsidian" },
						{ "<leader>p", group = "picker" },
						{ "<leader>q", group = "quit" },
						{ "<leader>r", group = "rust" },
						{ "<leader>s", group = "search" },
						{ "<leader>t", group = "toggle/typescript" },
						{ "<leader>v", group = "neovim" },
						{ "<leader>w", group = "windows/workspace", proxy = "<c-w>" },
						{ "<leader>x", group = "diagnostics/quickfix" },
					},
				},
				triggers = {
					{ "<auto>", mode = "nixsotc" },
					{ "s", mode = { "n", "v" } },
				},
			}
		end,
		config = function(_, opts)
			require("which-key").setup(opts)
		end,
	},
}
