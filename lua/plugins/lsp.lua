-- File: plugins/lsp.lua
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"b0o/SchemaStore.nvim",
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		config = function()
			-- diagnostics UI
			vim.diagnostic.config({
				virtual_lines = true,
				float = { border = require("util.ui").border },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
						[vim.diagnostic.severity.INFO] = " ",
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

			-- Capabilities for LSP clients (no cmp-nvim-lsp, using default)
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			local servers = {
				bashls = {},
				cssls = {},
				dockerls = {},
				docker_compose_language_service = {},
				html = {},
				jsonls = {
					settings = {
						json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } },
					},
				},
				phpactor = { filetypes = { "php", "blade" } },
				pyright = {},
				tsserver = { filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" } },
				eslint = { settings = { format = { enable = true }, codeActionsOnSave = { enable = true } } },
				marksman = {},
				yamlls = {
					settings = {
						yaml = {
							schemaStore = { enable = false, url = "" },
							schemas = require("schemastore").yaml.schemas(),
						},
					},
				},
				tailwindcss = {
					filetypes_exclude = { "markdown", "php" },
					root_dir = function(fname)
						local pkg = vim.fs.find("package.json", { path = fname, upward = true })[1]
						if not pkg then
							return nil
						end
						local dir = vim.fs.dirname(pkg)
						local f = io.open(dir .. "/package.json", "r")
						if not f then
							return nil
						end
						local content = f:read("*a")
						f:close()
						return content:match('"tailwindcss"%s*:') and dir or nil
					end,
				},
				rust_analyzer = {},
				lua_ls = {
					settings = {
						Lua = { workspace = { checkThirdParty = false }, completion = { callSnippet = "Replace" } },
					},
				},
			}

			for name, cfg in pairs(servers) do
				local opts =
					vim.tbl_deep_extend("force", { on_attach = on_attach, capabilities = capabilities }, cfg or {})
				require("lspconfig")[name].setup(opts)
			end
		end,
	},
}
