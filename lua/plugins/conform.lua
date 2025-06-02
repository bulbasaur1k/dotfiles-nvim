-- plugins/conform.lua
return {
  {
    "stevearc/conform.nvim",
    dependencies = { "folke/snacks.nvim" },
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      -- Убрано format_on_save - будем использовать autocmd
      formatters = {
        pint = {
          command = vim.fn.stdpath("data") .. "/mason/bin/php-cs-fixer",
          args = { "fix", "--using-cache=no", "--quiet", "$FILENAME" },
          -- Добавляем проверку существования бинарника
          condition = function(ctx)
            return vim.fn.executable(ctx.command) == 1
          end
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        rust = { "rustfmt" },
        toml = { "taplo" },
        javascript = { "biome" },
        javascriptreact = { "biome" },
        typescript = { "biome" },
        typescriptreact = { "biome" },
        json = { "biome" },
        css = { "prettierd" },
        html = { "prettierd" },
        markdown = { "prettierd" },
        php = { "pint" },
        nix = { "alejandra" },
        sh = { "shfmt" },
        yaml = { "biome" },
        yml = { "biome" },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      -- Убрано vim.opt.formatexpr - может конфликтовать

      -- Инициализация Snacks
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
