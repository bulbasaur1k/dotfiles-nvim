return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = require("mason")._opts.ensure_installed,
				run_on_start = true, -- будет срабатывать при каждом старте Neovim
				auto_update = false, -- не обновлять версии автоматически
			})
		end,
	},
}
