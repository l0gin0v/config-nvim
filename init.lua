-- ~/.config/nvim/init.lua

-- Загрузка базовых настроек
require('options')

-- Загрузка настроек плагинов  
require('plugins')

-- Клавиши для плагинов
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Перейти в левое окно' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Перейти в нижнее окно' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Перейти в верхнее окно' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Перейти в правое окно' })
vim.keymap.set('n', '<F8>', ':TagbarToggle<CR>')

-- Настройка Python (аналог let g:python3_host_prog)
vim.g.python3_host_prog = '/usr/bin/python3'

-- Настройка Rust (через плагин rustaceanvim)
vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ['rust_analyzer'] = {
        checkOnSave = {
          command = 'clippy',
        },
        cargo = {
          allFeatures = true,
        },
        procMacro = {
          enable = true,
        },
      },
    },
  },
}

-- ========== LSP НАСТРОЙКИ ==========
local lspconfig = require('lspconfig')

-- Автокоманды для LSP
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Включить completion при подключении LSP
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Клавиши для LSP
    local opts = { buffer = ev.buf }
    
    -- ПОКАЗАТЬ ОШИБКУ ПОД КУРСОРОМ
    vim.keymap.set('n', '<A-d>', vim.diagnostic.open_float, opts)  -- Alt + d
    
    -- ПЕРЕЙТИ К СЛЕДУЮЩЕЙ ОШИБКЕ
    vim.keymap.set('n', '<A-n>', vim.diagnostic.goto_next, opts)   -- Alt + n
    
    -- ПЕРЕЙТИ К ПРЕДЫДУЩЕЙ ОШИБКЕ
    vim.keymap.set('n', '<A-p>', vim.diagnostic.goto_prev, opts)   -- Alt + p
    
    -- ОТКРЫТЬ СПИСОК ВСЕХ ОШИБОК
    vim.keymap.set('n', '<A-l>', vim.diagnostic.setloclist, opts)  -- Alt + l
    
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- Настройка LSP серверов
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- LSP для C/C++
lspconfig.clangd.setup({
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--suggest-missing-includes",
    "--clang-tidy",
    "--header-insertion=never",
  },
  filetypes = {"c", "cpp", "objc", "objcpp"},
})

-- LSP для Python
lspconfig.pyright.setup({
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true
      }
    }
  }
})
