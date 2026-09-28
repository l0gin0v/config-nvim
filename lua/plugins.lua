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
  'vim-airline/vim-airline',
  'preservim/nerdtree',
  'tpope/vim-surround',
  'tpope/vim-commentary', 
  'ap/vim-css-color',
  'rafi/awesome-vim-colorschemes',
  'ryanoasis/vim-devicons',
  'tc50cal/vim-terminal',
  'preservim/tagbar',

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
})
