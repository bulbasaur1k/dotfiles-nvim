-- plugins/obsidian.lua
return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MeanderingProgrammer/render-markdown.nvim", -- Интеграция с вашим markdown рендерером
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/docs/personal",  -- УКАЖИТЕ ПУТЬ К ВАШЕМУ ХРАНИЛИЩУ OBSIDIAN
        },
      },
      disable_frontmatter = false,
      note_id_func = function(title)
        return title and title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower() or tostring(os.time())
      end,
      note_frontmatter_func = function(note)
        return {
          id = note.id,
          aliases = note.aliases,
          tags = note.tags,
        }
      end,
      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },
      open_notes_in = "current",
      picker = {
        name = "snacks",
        mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
      },
      -- Интеграция с вашим LSP
      completion = {
        nvim_cmp = false, -- Disable built-in cmp integration (Исправлено: комментарий изменен или перемещен)
        min_chars = 2,
      },
      -- Интеграция с render-markdown.nvim
      ui = {
        enable = true,
        update_debounce = 200,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" }, -- Предполагаются символы Nerd Font
          ["x"] = { char = "", hl_group = "ObsidianDone" }, -- Предполагаются символы Nerd Font
        },
      },
    },
    keys = {
      -- Основные команды
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "[O]bsidian [N]ew" },
      { "<leader>oo", "<cmd>ObsidianSearch<cr>", desc = "[O]bsidian [O]pen" },
      { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "[O]bsidian [S]witch" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "[O]bsidian [B]acklinks" },

      -- Работа с ссылками
      -- Строка с пробелами удалена
      { "<leader>ol", "<cmd>ObsidianLink<cr>", desc = "[O]bsidian [L]ink" },
      { "<leader>oL", "<cmd>ObsidianLinkNew<cr>", desc = "[O]bsidian [L]ink New" },
      { "gf", function()
          if require("obsidian").util.cursor_on_markdown_link() then
            return "<cmd>ObsidianFollowLink<CR>"
          else
            return "gf"
          end
        end, desc = "Follow Link", mode = "n", expr = true },

      -- Дополнительные функции
      { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "[O]bsidian [T]oday" },
      { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "[O]bsidian [Y]esterday" },
      { "<leader>op", "<cmd>ObsidianTemplate<cr>", desc = "[O]bsidian [P]aste Template" },
      { "<leader>ov", "<cmd>ObsidianPreview<cr>", desc = "[O]bsidian Pre[V]iew" },
    },
    config = function(_, opts)
      require("obsidian").setup(opts)

      -- Кастомизация snacks для Obsidian
      local snacks = require("snacks")

      snacks.register_source("obsidian", {
        show = function(query, ctx)
          local client = require("obsidian").client
          local notes = client:list_notes(query)

          local items = {}
          for _, note in ipairs(notes) do
            table.insert(items, {
              value = note.id,
              display = note.name,
              path = note.path,
            })
          end

          return snacks.show_picker(items, ctx)
        end,
        select = function(item, ctx)
          vim.cmd("edit " .. item.path)
        end,
      })

      -- Интеграция с render-markdown.nvim
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          require("render-markdown").setup({
            headings = {
              enabled = true,
              level_colors = false,
              -- Используем ваши иконки из mini.icons (Предполагаются символы Nerd Font)
              icons = {
                h1 = "",
                h2 = "",
                h3 = "",
                h4 = "",
                h5 = "",
                h6 = "",
              },
            },
            code_blocks = {
              enabled = true,
              highlight = true,
              languages = {
                lua = require("mini.icons").get("file", "lua"), -- Исправлено: добавлен тип "file"
                python = require("mini.icons").get("file", "py"), -- Исправлено: добавлен тип "file"
                javascript = require("mini.icons").get("file", "js"), -- Исправлено: добавлен тип "file"
                typescript = require("mini.icons").get("file", "ts"), -- Исправлено: добавлен тип "file"
              },
            },
          })
        end,
      })
    end,
  }
}
