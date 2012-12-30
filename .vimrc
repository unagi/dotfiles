set nocompatible
colorscheme desert

set rtp+=~/dotfiles/.vim/vundle.git/
call vundle#rc()

Bundle 'unagi/vim-moncf'
Bundle 'Shougo/neocomplcache'
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_auto_completion_start_length = 3

Bundle 'Shougo/unite.vim'
Bundle 'thinca/vim-ref'
Bundle 'thinca/vim-quickrun'
Bundle 'tyru/open-browser.vim'

syntax on

set number
set ruler
set laststatus=2
set notitle
set showcmd

set autoindent
set tabstop=4
set shiftwidth=4
set expandtab

set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<

let g:quickrun_config = {}
let g:quickrun_config['markdown'] = {
    \ 'outputter': 'browser'
    \ }

filetype on
filetype indent on
filetype plugin on

autocmd Filetype ruby set ts=2 sts=2 sw=2
autocmd Filetype html set ts=2 sts=2 sw=2
autocmd Filetype css set ts=2 sts=2 sw=2
autocmd Filetype yaml set ts=2 sts=2 sw=2
set completeopt=menuone
