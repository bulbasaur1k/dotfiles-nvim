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
        "typescript-language-server",
        "biome", -- Замена eslint (на Rust)
        "marksman",
        "dockerls",
        "ansiblels",
        "rust_analyzer",
        "lua_ls",
        "yamlls",     -- <-- ДОБАВЛЕНО (для YAML и Kubernetes)
        "helm-ls",    -- <-- ДОБАВЛЕНО (для Helm)
         "roslyn",

        -- Форматтеры
        "stylua",       -- Lua (на Rust)
        "ruff",         -- Python (на Rust)
        "taplo",        -- TOML (на Rust)
        "biome",        -- JS/TS (на Rust)
        "rustfmt",      -- Rust (на Rust)
        "prettierd",    -- Универсальный (резервный)
        "php-cs-fixer", -- Только для PHP
        -- Линтеры для none-ls
        "hadolint",   -- <-- ДОБАВЛЕНО (для Dockerfile)
        "yamllint",   -- <-- ДОБАВЛЕНО (для YAML)
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },
}
