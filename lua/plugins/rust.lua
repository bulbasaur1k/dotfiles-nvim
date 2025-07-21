-- FILE: lua/plugins/rust.lua
-- plugins/rust.lua
return {
	-- Основной плагин для Rust
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		lazy = false,
		ft = { "rust" },
		config = function()
			vim.g.rustaceanvim = {
				-- Настройки LSP
				server = {
					on_attach = function(client, bufnr)
						-- Стандартные LSP биндинги
						local map = function(keys, func, desc)
							vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
						end

						-- Основные LSP команды
						map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
						map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
						map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
						map("go", vim.lsp.buf.type_definition, "[G]oto Type Definition")
						map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
						map("gs", vim.lsp.buf.signature_help, "[G]et [S]ignature Help")
						map("K", vim.lsp.buf.hover, "Hover Documentation")
						map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
						map("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
						map("<leader>cf", vim.lsp.buf.format, "[C]ode [F]ormat")

						-- Rust specific
						map("<leader>rr", function()
							vim.cmd.RustLsp("run")
						end, "[R]ust [R]un")
						map("<leader>rd", function()
							vim.cmd.RustLsp("debuggables")
						end, "[R]ust [D]ebug")
						map("<leader>rt", function()
							vim.cmd.RustLsp("testables")
						end, "[R]ust [T]est")
						map("<leader>re", function()
							vim.cmd.RustLsp("explainError")
						end, "[R]ust [E]xplain Error")
						map("<leader>rc", function()
							vim.cmd.RustLsp("openCargo")
						end, "[R]ust Open [C]argo.toml")
						map("<leader>rp", function()
							vim.cmd.RustLsp("parentModule")
						end, "[R]ust [P]arent Module")
						map("<leader>rj", function()
							vim.cmd.RustLsp("joinLines")
						end, "[R]ust [J]oin Lines")
						map("<leader>ra", function()
							vim.cmd.RustLsp({ "hover", "actions" })
						end, "[R]ust Hover [A]ctions")
						map("<leader>rm", function()
							vim.cmd.RustLsp("expandMacro")
						end, "[R]ust Expand [M]acro")
						map("<leader>rR", function()
							vim.cmd.RustLsp("runnables")
						end, "[R]ust [R]unnables")

						-- Enable inlay hints
						if client.server_capabilities.inlayHintProvider then
							vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
						end
					end,

					-- Настройки rust-analyzer
					default_settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
								loadOutDirsFromCheck = true,
								buildScripts = {
									enable = true,
								},
							},
							checkOnSave = {
								allFeatures = true,
								command = "clippy",
								extraArgs = { "--no-deps" },
							},
							procMacro = {
								enable = true,
								ignored = {
									["async-trait"] = { "async_trait" },
									["napi-derive"] = { "napi" },
									["async-recursion"] = { "async_recursion" },
								},
							},
							lens = {
								enable = true,
								run = { enable = true },
								debug = { enable = true },
								implementations = { enable = true },
								references = {
									adt = { enable = true },
									enumVariant = { enable = true },
									method = { enable = true },
									trait = { enable = true },
								},
							},
							inlayHints = {
								bindingModeHints = { enable = true },
								chainingHints = { enable = true },
								closingBraceHints = {
									enable = true,
									minLines = 25,
								},
								closureReturnTypeHints = { enable = "always" },
								lifetimeElisionHints = {
									enable = "always",
									useParameterNames = true,
								},
								maxLength = 25,
								parameterHints = { enable = true },
								reborrowHints = { enable = "always" },
								renderColons = true,
								typeHints = {
									enable = true,
									hideClosureInitialization = false,
									hideNamedConstructor = false,
								},
							},
							completion = {
								callable = {
									snippets = "fill_arguments",
								},
								postfix = {
									enable = true,
								},
							},
							diagnostics = {
								enable = true,
								experimental = {
									enable = true,
								},
							},
						},
					},
				},

				-- Настройки инструментов
				tools = {
					hover_actions = {
						auto_focus = true,
					},
					inlay_hints = {
						auto = true,
						show_parameter_hints = true,
					},
					code_actions = {
						ui_select_fallback = true,
					},
				},

				-- DAP (Debug Adapter Protocol) configuration
				dap = {
					adapter = {
						type = "executable",
						command = "lldb-vscode",
						name = "lldb",
					},
				},
			}
		end,
	},

	-- Дополнительные инструменты для Rust
	{
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			vim.g.rustfmt_autosave = 1
		end,
	},
}
