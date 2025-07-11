-- FILE: lua/plugins/blink-cmp.lua
return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"echasnovski/mini.icons",
			"folke/lazydev.nvim",
			"rafamadriz/friendly-snippets",
			"saecki/crates.nvim",
		},
		version = "v1.*",
		event = { "CmdlineEnter", "InsertEnter" },
		opts = {
			cmdline = {
				keymap = {
					preset = "cmdline",
					["<C-Space>"] = {},
					["<esc>"] = { "hide", "fallback" },
					["<C-n>"] = { "show", "select_next", "fallback" },
				},
			},
			keymap = {
				preset = "default",
				["<C-Space>"] = {},
				["<C-n>"] = { "show", "select_next", "fallback" },
				["<C-k>"] = { "snippet_forward", "fallback" },
				["<C-j>"] = { "snippet_backward", "fallback" },
			},
			appearance = { nerd_font_variant = "normal" },
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer", "crates" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					crates = {
						name = "crates",
						module = "blink.compat.source",
						score_offset = 90,
					},
				},
			},
			completion = {
				list = {
					selection = { auto_insert = false },
				},
				menu = {
					auto_show = function(ctx)
						return ctx.mode ~= "cmdline"
					end,
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind" },
						},
						components = {
							kind_icon = {
								ellipsis = false,
								text = function(ctx)
									local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return kind_icon .. " "
								end,
							},
						},
					},
					border = require("util.ui").border,
				},
				documentation = {
					auto_show = true,
					window = { border = require("util.ui").border },
				},
			},
			signature = {
				enabled = true,
				window = { border = require("util.ui").border },
			},
		},
		config = function(_, opts)
			-- Интеграция с crates.nvim
			local crates = require("crates")
			crates.setup({
				completion = {
					crates = {
						enabled = true,
					},
				},
			})

			require("blink.cmp").setup(opts)
		end,
	},
}
