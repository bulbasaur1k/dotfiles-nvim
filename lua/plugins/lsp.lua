-- plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp", -- saghen/blink.cmp не является стандартной зависимостью для lspconfig, убедись что она нужна здесь. Она скорее для cmp.
    },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    config = function()
      -- Настройка диагностики
      vim.diagnostic.config({
        virtual_lines = true,
        float = { border = require("util.ui").border },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ", -- Пример с Nerd Font
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      })

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

      -- Возможности LSP
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local servers = {
        bashls = {},
        cssls = {},
        dockerls = {},
        docker_compose_language_service = {},
        html = {},
        jsonls = {
          settings = {
            json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } },
          },
        },
        phpactor = {
          filetypes = { "php" }, -- Только для PHP
          settings = {
            phpactor = {
              languageServer = {
                diagnosticProvider = true,
                completionEnabled = true,
                formattingEnabled = false, -- Форматирование выкл.
              },
            },
          }
        },
        pyright = {},
        tsserver = { filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" } },
        biome = { -- Меняем eslint на Biome (написан на Rust)
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        },
        marksman = {},
        yamlls = {
          settings = {
            yaml = {
              schemaStore = { enable = true, url = "" }, -- Включите schemaStore для автообнаружения
              schemas = vim.tbl_deep_extend("force", require("schemastore").yaml.schemas(), {
                -- Указываем yamlls использовать схему Kubernetes для файлов, которые
                -- содержат 'apiVersion' и 'kind', а также для файлов в директориях k8s.
                ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/v1.27.0/all.json"] = "/*/*k8s*.yml",
                ["kubernetes"] = { "**/templates/*.yaml", "**/templates/*.yml" }, -- Для Helm-чартов
                ["https://json.schemastore.org/gitlab-ci.json"] = "*gitlab-ci*.yml", -- Для GitLab CI
              }),
              format = { enable = true },
              validate = true,
              completion = true,
              hover = true,
            },
          },
        },
        tailwindcss = {
          filetypes_exclude = { "markdown", "php" },
          root_dir = function(fname)
            local pkg = vim.fs.find("package.json", { path = fname, upward = true })[1]
            if not pkg then return nil end
            local dir = vim.fs.dirname(pkg)
            local f = io.open(dir .. "/package.json", "r")
            if not f then return nil end
            local content = f:read("*a")
            f:close()
            -- Check if "tailwindcss" is a dependency or devDependency
            return content:match('"dependencies"%s*:') and content:match('"tailwindcss"%s*:') or
                   content:match('"devDependencies"%s*:') and content:match('"tailwindcss"%s*:') and dir or nil
          end,
        },
        rust_analyzer = {},
        lua_ls = {
          settings = {
            Lua = { workspace = { checkThirdParty = false }, completion = { callSnippet = "Replace" } },
          },
        },
      }

      for name, cfg in pairs(servers) do
        local opts = vim.tbl_deep_extend("force", {
          on_attach = on_attach,
          capabilities = capabilities
        }, cfg or {})
        require("lspconfig")[name].setup(opts)
      end
    end,
  },
}
