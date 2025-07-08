-- FILE: lua/plugins/package-info.lua
return {
	{
		"vuki656/package-info.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		ft = { "json" },
		config = function()
			require("package-info").setup({
				hide_up_to_date = true,
				package_manager = "auto",
			})

			-- Keymaps for package.json
			vim.api.nvim_create_autocmd("BufRead", {
				group = vim.api.nvim_create_augroup("PackageInfoKeymaps", { clear = true }),
				pattern = "package.json",
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
					end

					map("<leader>ns", function()
						require("package-info").show()
					end, "[N]pm [S]how")
					map("<leader>nc", function()
						require("package-info").hide()
					end, "[N]pm [C]lose")
					map("<leader>nt", function()
						require("package-info").toggle()
					end, "[N]pm [T]oggle")
					map("<leader>nu", function()
						require("package-info").update()
					end, "[N]pm [U]pdate")
					map("<leader>nd", function()
						require("package-info").delete()
					end, "[N]pm [D]elete")
					map("<leader>ni", function()
						require("package-info").install()
					end, "[N]pm [I]nstall")
					map("<leader>np", function()
						require("package-info").change_version()
					end, "[N]pm Change [P]ackage version")
				end,
			})
		end,
	},
}
