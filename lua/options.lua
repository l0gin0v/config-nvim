-- ~/.config/nvim/lua/options.lua

local opt = vim.opt
local g = vim.g

-- Базовые настройки (аналог :set)
opt.mouse = 'a'                    -- :set mouse=a
opt.number = true                  -- :set number
opt.relativenumber = true          -- :set relativenumber
opt.smarttab = true                -- :set smarttab
opt.tabstop = 2                    -- :set tabstop=2
opt.shiftwidth = 2                 -- :set shiftwidth=2
opt.softtabstop = 2                -- :set softtabstop=2
opt.autoindent = true              -- :set autoindent
opt.completeopt = 'menu,menuone,noselect' -- :set completeopt-=preview
opt.encoding = 'UTF-8'             -- set encoding=UTF-8

-- Дополнительные улучшения (опционально)
opt.expandtab = true               -- Заменять табы на пробелы
opt.smartindent = true             -- Умные отступы
-- opt.wrap = false                   -- Не переносить длинные строки
opt.swapfile = false               -- Не создавать swap файлы
opt.backup = false                 -- Не создавать backup файлы
opt.incsearch = true               -- Поиск при наборе
opt.hlsearch = true                -- Подсветка результатов поиска
opt.ignorecase = true              -- Игнорировать регистр при поиске
opt.smartcase = true               -- Умный регистр при поиске
opt.termguicolors = true           -- True color поддержка
