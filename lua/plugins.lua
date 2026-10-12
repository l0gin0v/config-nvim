-- ~/.config/nvim/lua/plugins.lua

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", 
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Ваши существующие плагины
  'tpope/vim-surround',
  'tpope/vim-commentary', 
  'rafi/awesome-vim-colorschemes',
  'tc50cal/vim-terminal',
  'preservim/tagbar',

  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          diagnostics = "nvim_lsp",
          separator_style = "thin",
        }
      })

      vim.keymap.set('n', '<S-h>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Предыдущая вкладка' })
      vim.keymap.set('n', '<S-l>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Следующая вкладка' })
    end
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'auto',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
        
          lualine_x = {
            {
              require("noice").api.status.mode.get,
              cond = require("noice").api.status.mode.has,
              color = { fg = "#ff9e64" },
            },
            { 'searchcount', maxcount = 999 } 
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
      }
    end
  },

  {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require("notify")
      notify.setup({
        stages = "fade",
        timeout = 3000,
      })

      vim.notify = notify
    end
  },
 
  {
    'mbbill/undotree',
    config = function()
      vim.keymap.set('n', '<F5>', vim.cmd.UndotreeToggle, { desc = 'Дерево изменений (Undo)' })
    end
  },

  {
    'NvChad/nvim-colorizer.lua',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require('colorizer').setup({
        filetypes = { '*' },
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          names = true,
          RRGGBBAA = true,
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          mode = 'background', 
        },
      })
    end
  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    config = function()
      vim.keymap.set('n', '<C-t>', '<cmd>Neotree toggle<CR>', { desc = 'Открыть дерево файлов' })
    end
  }, 

  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local hooks = require("ibl.hooks")

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "CustomIndentColor", { fg = "#2a2f41" })
      end)

      require("ibl").setup({
        indent = {
          char = "│",
          highlight = "CustomIndentColor",
        },
        scope = {
          enabled = true,
          show_start = false,
          show_end = false,
        },
        whitespace = {
          remove_blankline_trail = false,
        },
        exclude = {
          filetypes = { "help", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
        },
      })
    end
  },


  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        check_ts = true,
      })
    end
  },

  {
    'lewis6991/gitsigns.nvim',
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- ========== LSP ПЛАГИНЫ ==========
  -- LSP ядро
  {
    'neovim/nvim-lspconfig',
    event = "BufReadPre",
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    }
  },

  -- Менеджер LSP серверов
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end
  },

  -- Мост между Mason и LSPConfig
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {'clangd', 'pyright', 'rust_analyzer'}
      })
    end
  },

  -- Автодополнение
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else 
                fallback()
              end 
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ select = false }),
          }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })
    end
  },

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')

      telescope.setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
        },
      })

      telescope.load_extension('fzf')

      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Поиск файлов по имени' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Поиск текста внутри файлов (Grep)' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Список открытых буферов (вкладок)' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Поиск по справке и документации' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Поиск по всем горячим клавишам' })
    end
  },

  -- Snippets
  {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end
  },

  {
    'lcroberts/persistent-colorscheme.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      colorscheme = 'github',
    },
  },

  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
  },

  {
    'ThePrimeagen/vim-be-good',
    cmd = "VimBeGood",
  },

  {
    'Eandrju/cellular-automaton.nvim',
    config = function()
      vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Заставить код упасть" })
    end
  },

  {
    'folke/noice.nvim',
    event = "VeryLazy",
    opts = {
      -- Дополнительные настройки можно оставить дефолтными
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    }
  },

  {
    'stevearc/conform.nvim',
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        rust = { "rustfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },

  
  {
    'shellRaining/hlchunk.nvim',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
          style = "#61AFEF",
        },
        indent = { enable = false },
      })
    end
  },

  {
    'folke/zen-mode.nvim',
    opts = {
      window = { width = 120 },
    },
    config = function() 
      vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Режим концентрации (Zen)" })
    end
  },

  {
    'folke/trouble.nvim',
    opts = {},
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Список ошибок (Диагностика)" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix список" },
    },
  },

  {
    'alec-gibson/nvim-tetris',
    cmd = "Tetris",
  },

  {
    'seandewar/nvimesweeper',
    cmd = "Nvimesweeper",
  },

})
