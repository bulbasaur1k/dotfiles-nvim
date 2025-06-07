-- plugins/roslyn.lua
return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs" }, -- Загружать плагин только для файлов C#
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      -- Опции плагина roslyn.nvim
      -- Путь к dotnet можно оставить по умолчанию, если он в вашем PATH
      dotnet_cmd = "dotnet",
      -- Плагин сам найдет csharp-ls, установленный через Mason
    },
    config = function(_, opts)
      -- Получаем on_attach и capabilities из вашей основной конфигурации LSP
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

      -- Настраиваем roslyn.nvim
      -- Эта функция вызовет require("lspconfig").csharp_ls.setup(...) внутри себя
      -- с правильными параметрами.
      require("roslyn").setup({
        on_attach = on_attach,
        capabilities = capabilities,
        opts = opts,
      })
    end,
  }
}
