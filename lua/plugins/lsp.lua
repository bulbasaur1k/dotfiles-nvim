-- FILE: lua/plugins/lsp.lua
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"b0o/SchemaStore.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			-- Define icons - using dots with different colors
			local icons = {
				Error = "●",
				Warn = "●",
				Hint = "●",
				Info = "●",
			}

			vim.diagnostic.config({
				virtual_lines = false, -- Отключаем автоматический показ
				virtual_text = false, -- Отключаем текст справа от строки
				float = { border = require("util.ui").border },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = icons.Error,
						[vim.diagnostic.severity.WARN] = icons.Warn,
						[vim.diagnostic.severity.HINT] = icons.Hint,
						[vim.diagnostic.severity.INFO] = icons.Info,
					},
				},
			})

			-- Safely enable inlay hints with error handling
			local function safe_enable_inlay_hints(bufnr)
				local ok, err = pcall(function()
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end)
				if not ok then
					vim.notify("Failed to enable inlay hints: " .. tostring(err), vim.log.levels.WARN)
				end
			end

			local on_attach = function(client, buf)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = buf, desc = desc })
				end

				-- Basic LSP bindings
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

				-- Diagnostics bindings
				map("<leader>e", vim.diagnostic.open_float, "Show diagnostics")
				map("ge", vim.diagnostic.open_float, "Show line diagnostics")
				map("]d", vim.diagnostic.goto_next, "Go to next diagnostic")
				map("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")

				-- Workspace
				map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
				map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
				map("<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, "[W]orkspace [L]ist Folders")

				-- Toggle inlay hints manually
				map("<leader>th", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
				end, "[T]oggle Inlay [H]ints")

				-- Enable inlay hints if supported (with error handling)
				if client.server_capabilities.inlayHintProvider then
					-- Delay enabling inlay hints to avoid race conditions
					vim.defer_fn(function()
						safe_enable_inlay_hints(buf)
					end, 100)
				end
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()

			local servers = {
				bashls = {},
				cssls = {},
				dockerls = {},
				ansiblels = {},
				html = {},
				jsonls = {
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
				},
				pyright = {
					settings = {
						python = {
							analysis = {
								autoSearchPaths = true,
								diagnosticMode = "workspace",
								useLibraryCodeForTypes = true,
							},
						},
					},
				},
				ts_ls = {
					filetypes = {
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
					},
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
				biome = {
					filetypes = {
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"json",
						"jsonc",
					},
				},
				eslint = {
					settings = {
						workingDirectory = { mode = "auto" },
					},
				},
				yamlls = {
					settings = {
						yaml = {
							schemaStore = { enable = true, url = "" },
							schemas = vim.tbl_deep_extend("force", require("schemastore").yaml.schemas(), {
								["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/v1.27.0/all.json"] = "/*/*k8s*.yml",
								["kubernetes"] = { "**/templates/*.yaml", "**/templates/*.yml" },
								["https://json.schemastore.org/gitlab-ci.json"] = "*gitlab-ci*.yml",
							}),
							format = { enable = true },
						},
					},
				},
				tailwindcss = {
					filetypes = {
						"html",
						"css",
						"scss",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"vue",
					},
					settings = {
						tailwindCSS = {
							experimental = {
								classRegex = {
									{ "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
									{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
									{ "cn\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
								},
							},
						},
					},
				},
				rust_analyzer = {
					-- Skip setup here as rustaceanvim handles it
					-- This prevents conflict warning
					setup = function() end,
				},
				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							completion = { callSnippet = "Replace" },
							diagnostics = { globals = { "vim" } },
							hint = { enable = true }, -- Enable inlay hints for Lua
						},
					},
				},
				marksman = {
					root_dir = function(fname)
						if not fname then
							return nil
						end
						-- Disable marksman inside ~/obsidian/
						local obs_root = vim.fn.expand("~/obsidian/"):gsub("/$", "")
						if fname:sub(1, #obs_root) == obs_root then
							return nil
						end
						-- Enable if .git or .marksman.toml exists
						return require("lspconfig.util").root_pattern(".git", ".marksman.toml")(fname)
					end,
				},
			}

			for name, cfg in pairs(servers) do
				local opts = vim.tbl_deep_extend("force", {
					on_attach = on_attach,
					capabilities = capabilities,
				}, cfg or {})
				require("lspconfig")[name].setup(opts)
			end

			-- Global keybind to toggle inlay hints for all buffers
			vim.keymap.set("n", "<leader>tH", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, { desc = "[T]oggle Inlay [H]ints (global)" })
		end,
	},
}
