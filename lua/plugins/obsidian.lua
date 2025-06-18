-- plugins/obsidian.lua
return {
	{
		"epwalsh/obsidian.nvim",
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MeanderingProgrammer/render-markdown.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "work",
					path = vim.fn.expand("~/obsidian/docs/work"),
				},
				{
					name = "personal",
					path = vim.fn.expand("~/obsidian/docs/personal"),
				},
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
						templates = { subdir = vim.NIL },
					},
				},
			},
			disable_frontmatter = false,
			note_id_func = function(title)
				return title and title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower() or tostring(os.time())
			end,
			note_frontmatter_func = function(note)
				return { id = note.id, aliases = note.aliases, tags = note.tags }
			end,
			templates = {
				subdir = "templates",
				date_format = "%Y-%m-%d-%a",
				time_format = "%H:%M",
			},
			open_notes_in = "current",
			picker = {
				name = "snacks",
				mappings = {
					new = "<C-x>",
					insert_link = "<C-l>",
				},
			},
			completion = {
				nvim_cmp = false,
				min_chars = 2,
			},
			ui = {
				enable = true,
				update_debounce = 200,
				checkboxes = {
					[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
					["x"] = { char = "", hl_group = "ObsidianDone" },
				},
			},
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
			require("obsidian").setup(opts)
			-- ваша интеграция render-markdown.nvim и snacks остаётся без изменений
		end,
	},
}
