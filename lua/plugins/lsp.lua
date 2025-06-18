-- plugins/lsp.lua
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"b0o/SchemaStore.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			vim.diagnostic.config({
				virtual_lines = true,
				float = { border = require("util.ui").border },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.HINT] = " ",
						[vim.diagnostic.severity.INFO] = " ",
					},
				},
			})

			local on_attach = function(_, buf)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = buf, desc = desc })
				end
				map("<leader>ca", vim.lsp.buf.code_action, "Code action")
				map("<leader>cr", vim.lsp.buf.rename, "Rename variable")
				map("gd", vim.lsp.buf.definition, "Go to definition")
				map("K", vim.lsp.buf.hover, "Hover")
				map("gr", vim.lsp.buf.references, "References")
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
				phpactor = {
					filetypes = { "php" },
					settings = {
						phpactor = {
							languageServer = {
								diagnosticProvider = true,
								completionEnabled = true,
								formattingEnabled = false,
							},
						},
					},
				},
				pyright = {},
				ts_ls = {
					filetypes = {
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
					},
				},
				biome = {
					filetypes = {
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
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
					filetypes_exclude = { "markdown", "php" },
				},
				rust_analyzer = {},
				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							completion = { callSnippet = "Replace" },
							diagnostics = { globals = { "vim" } },
						},
					},
				},
				marksman = {
					root_dir = function(fname)
						if not fname then
							return nil
						end
						-- отключаем marksman внутри ~/obsidian/
						local obs_root = vim.fn.expand("~/obsidian/"):gsub("/$", "")
						if fname:sub(1, #obs_root) == obs_root then
							return nil
						end
						-- иначе включаем, если есть .git или .marksman.toml
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
		end,
	},
}
