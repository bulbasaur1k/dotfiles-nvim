-- plugins/conform.lua
return {
  {
    "stevearc/conform.nvim",
    dependencies = { "folke/snacks.nvim" },
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      -- Настраиваем форматтеры, которые будут запускаться для каждого типа файла.
      -- conform.nvim сам найдет исполняемые файлы, установленные через Mason.
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "black" }, -- Можно указать несколько, black будет запасным
        rust = { "rustfmt" },
        toml = { "taplo" },
        cs = { "csharpier" },

        -- Форматтеры из вашего null-ls и другие
        javascript = { "biome" },
        javascriptreact = { "biome" },
        typescript = { "biome" },
        typescriptreact = { "biome" },
        json = { "biome" },
        yaml = { "prettierd" },
        sh = { "shfmt" },
        php = { "php-cs-fixer" },

        -- Остальные
        css = { "prettierd" },
        html = { "prettierd" },
        markdown = { "prettierd" },
        nix = { "alejandra" },
      },

      -- Включаем автоматическое форматирование при сохранении.
      -- Это более надежный способ, чем ручная настройка autocmd.
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true, -- Если conform не справился, пробуем LSP
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      -- Инициализация Snacks для переключения форматирования
      local snacks = require("snacks")
      snacks.toggle
          .new({
            name = "formatting",
            get = function() return not vim.b.disable_autoformat end,
            set = function(state) vim.b.disable_autoformat = not state end,
          })
          :map("<leader>tf")

      -- Ручное форматирование
      vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format buffer" })
    end,
  },
}
