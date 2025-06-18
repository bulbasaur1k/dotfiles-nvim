-- plugins/lint.lua
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        sh = { "shellcheck" },
        dockerfile = { "hadolint" },
        yaml = { "yamllint" },
      }

      -- Создаем автокоманду, которая будет запускать линтинг при сохранении и открытии файла.
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("nvim-lint-autogroup", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
