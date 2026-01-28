syntax on
set number
set showmatch

set termguicolors

set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

let g:plug_url_formt = 'https://gitclone.com/github.com/%s.git'

call plug#begin ('~/.vim/plugged/')

Plug 'morhetz/gruvbox'
" Plug 'ycm-core/YouCompleteMe', {'do':'/install.py --all'}
Plug 'neoclide/coc.nvim', {'branch':'release'}

call plug#end()
colorscheme gruvbox
set background=dark
