set nocompatible
filetype off
set rtp+=~/dotfiles/.vim/vundle.git/
call vundle#rc()

Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/unite.vim'
Bundle 'thinca/vim-ref'
Bundle 'thinca/vim-quickrun'

filetype plugin indent on

syntax on
colorscheme desert

set number
set ruler
set laststatus=2
set title
set showcmd

set tabstop=4
set softtabstop=4
set expandtab
