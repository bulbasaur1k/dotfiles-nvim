-- File: plugins/none-ls.lua
return {
	{
		"jose-elias-alvarez/null-ls.nvim", -- Используем правильное имя плагина
		dependencies = { "williamboman/mason.nvim" }, -- Убедитесь, что Mason установлен
		opts = function()
			local nls = require("null-ls") -- Подключаем правильный модуль
			nls.setup({
				sources = {
					-- форматтеры
					nls.builtins.formatting.prettier,
					nls.builtins.formatting.black,
					-- диагностика
					nls.builtins.diagnostics.shellcheck,
					-- PHP CS Fixer (уже через Mason-bin)
					nls.builtins.formatting.phpcsfixer.with({
						command = vim.fn.stdpath("data") .. "/mason/bin/php-cs-fixer",
						args = { "fix", "--using-cache=no", "--quiet", "$FILENAME" },
					}),
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = "LspFormatting", buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr })
							end, -- Используем новую функцию форматирования
						})
					end
				end,
			})
		end,
	},
}
