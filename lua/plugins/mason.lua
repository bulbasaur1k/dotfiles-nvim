-- plugins/mason.lua
return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      ensure_installed = {
        -- LSP серверы
        "phpactor",
        "pyright",
        "tsserver",
        "biome", -- Замена eslint (на Rust)
        "marksman",
        "dockerls",
        "ansiblels",
        "rust_analyzer",
        "lua_ls",

        -- Форматтеры
        "stylua",       -- Lua (на Rust)
        "ruff",         -- Python (на Rust)
        "taplo",        -- TOML (на Rust)
        "biome",        -- JS/TS (на Rust)
        "rustfmt",      -- Rust (на Rust)
        "prettierd",    -- Универсальный (резервный)
        "php-cs-fixer", -- Только для PHP
        "ru",
        "en",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },
}
