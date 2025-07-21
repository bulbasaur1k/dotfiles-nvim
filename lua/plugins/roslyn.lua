-- FILE: lua/plugins/roslyn.lua
-- plugins/roslyn.lua
return {
	{
		"seblj/roslyn.nvim",
		ft = { "cs", "vb" },
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("roslyn").setup({
				-- Путь к dotnet
				dotnet_cmd = "dotnet",
				-- Путь к roslyn LSP (mason автоматически установит)
				roslyn_version = "4.9.0-3.23604.10",

				-- Настройки для LSP
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

					-- .NET specific keymaps
					map("<leader>dn", function()
						vim.cmd("!dotnet new")
					end, "[D]otnet [N]ew")
					map("<leader>db", function()
						vim.cmd("!dotnet build")
					end, "[D]otnet [B]uild")
					map("<leader>dr", function()
						vim.cmd("!dotnet run")
					end, "[D]otnet [R]un")
					map("<leader>dt", function()
						vim.cmd("!dotnet test")
					end, "[D]otnet [T]est")
					map("<leader>dp", function()
						vim.cmd("!dotnet publish")
					end, "[D]otnet [P]ublish")
					map("<leader>dw", function()
						vim.cmd("!dotnet watch run")
					end, "[D]otnet [W]atch")

					-- Enable inlay hints
					if client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end
				end,

				capabilities = vim.lsp.protocol.make_client_capabilities(),

				-- Настройки для конкретных проектов
				settings = {
					["csharp|background_analysis"] = {
						dotnet_analyzer_diagnostics_scope = "openFiles",
						dotnet_compiler_diagnostics_scope = "openFiles",
					},
					["csharp|inlay_hints"] = {
						dotnet_enable_inlay_hints_for_implicit_object_creation = true,
						dotnet_enable_inlay_hints_for_implicit_variable_types = true,
						dotnet_enable_inlay_hints_for_lambda_parameter_types = true,
						dotnet_enable_inlay_hints_for_types = true,
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,
						csharp_enable_inlay_hints_for_lambda_parameter_types = true,
						csharp_enable_inlay_hints_for_types = true,
					},
					["csharp|code_lens"] = {
						dotnet_enable_references_code_lens = true,
						dotnet_enable_tests_code_lens = true,
					},
				},
			})
		end,
	},
}
