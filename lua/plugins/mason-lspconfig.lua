-- plugins/mason-lspconfig.lua
return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        "phpactor",
        "pyright",
        "tsserver",
        "biome", -- Замена eslint
        "marksman",
        "dockerls",
        "ansiblels",
        "rust_analyzer",
        "lua_ls",
      },
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end,
  },
}
