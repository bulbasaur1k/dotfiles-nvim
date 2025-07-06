-- plugins/obsidian.lua
return {
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		event = {
			"BufReadPre " .. vim.fn.expand("~") .. "/obsidian/docs/work/*.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/obsidian/docs/work/*.md",
			"BufReadPre " .. vim.fn.expand("~") .. "/obsidian/docs/personal/*.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/obsidian/docs/personal/*.md",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MeanderingProgrammer/render-markdown.nvim",
			"MunifTanjim/nui.nvim",
			"folke/noice.nvim",
		},
		keys = {
			{ "<leader>on", "<cmd>ObsidianNew<cr>", desc = "[O]bsidian [N]ew" },
			{ "<leader>oo", "<cmd>ObsidianSearch<cr>", desc = "[O]bsidian [O]pen" },
			{ "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "[O]bsidian [S]witch" },
			{ "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "[O]bsidian [B]acklinks" },
			{ "<leader>ol", "<cmd>ObsidianLink<cr>", desc = "[O]bsidian [L]ink" },
			{ "<leader>oL", "<cmd>ObsidianLinkNew<cr>", desc = "[O]bsidian [L]ink New" },
			{ "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "[O]bsidian [T]oday" },
			{ "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "[O]bsidian [Y]esterday" },
			{ "<leader>op", "<cmd>ObsidianTemplate<cr>", desc = "[O]bsidian [P]aste Template" },
			{ "<leader>ov", "<cmd>ObsidianPreview<cr>", desc = "[O]bsidian Pre[V]iew" },
			{
				"gf",
				mode = "n",
				expr = true,
				desc = "Follow Link",
				function()
					if require("obsidian").util.cursor_on_markdown_link() then
						return "<cmd>ObsidianFollowLink<CR>"
					else
						return "gf"
					end
				end,
			},
		},
		config = function(_, opts)
			-- disable telescope integration, use native vim.ui.select via Noice
			require("noice").setup({})
			require("obsidian").setup(vim.tbl_deep_extend("force", {
				use_advanced_ui = false,
				workspaces = {
					{ name = "work", path = vim.fn.expand("~/obsidian/docs/work") },
					{ name = "personal", path = vim.fn.expand("~/obsidian/docs/personal") },
					{
						name = "no-vault",
						path = function()
							return vim.fs.dirname(vim.api.nvim_buf_get_name(0))
						end,
						strict = true,
						overrides = {
							notes_subdir = vim.NIL,
							new_notes_location = "current_dir",
							disable_frontmatter = true,
							templates = { folder = vim.NIL },
						},
					},
				},
				disable_frontmatter = false,
				templates = { subdir = "templates", date_format = "%Y-%m-%d-%a", time_format = "%H:%M" },
				open_notes_in = "current",
			}, opts))
		end,
	},
}
