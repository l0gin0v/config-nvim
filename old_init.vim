:set mouse
:set number
:set relativenumber
:set smarttab
:set tabstop=2
:set shiftwidth=2
:set softtabstop=2
:set autoindent
:set completeopt-=preview 
set encoding=UTF-8

call plug#begin()

Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/preservim/nerdtree'
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/ap/vim-css-color'
Plug 'https://github.com/rafi/awesome-vim-colorschemes'
Plug 'https://github.com/ryanoasis/vim-devicons'
Plug 'https://github.com/tc50cal/vim-terminal'
Plug 'https://github.com/preservim/tagbar'

call plug#end()

nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nmap <F8> :TagbatToggle<CR> 

let g:python3_host_prog = '/usr/bin/python3'
