if &compatible
  set nocompatible
endif


" -------
" Plugins
" -------
set runtimepath+=~/.vim/repos/github.com/Shougo/dein.vim

let s:dein_dir = expand('~/.vim')

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let s:rc_dir = expand('~/dotfiles/vimrc.d')

  " TOML load
  call dein#load_toml(s:rc_dir . '/dein.toml', {'lazy': 0})
  call dein#load_toml(s:rc_dir . '/dein_lazy.toml', {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype off
colorscheme gruvbox


" --------
" Settings
" --------
" default settings
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
set helplang=ja
set completeopt=menuone
set backspace=indent,eol,start
set background=dark

" filetype settings
filetype on
filetype indent on
filetype plugin on
syntax on

au! BufRead,BufNewFile *.json set filetype=json
au! BufRead,BufNewFile *.ejs set filetype=html
autocmd Filetype ruby set ts=2 sts=2 sw=2
autocmd Filetype eruby set ts=2 sts=2 sw=2
autocmd Filetype html set ts=2 sts=2 sw=2
autocmd Filetype css set ts=2 sts=2 sw=2
autocmd Filetype scss set ts=2 sts=2 sw=2
autocmd Filetype yaml set ts=2 sts=2 sw=2
autocmd Filetype javascript set ts=2 sts=2 sw=2
autocmd Filetype coffee set ts=2 sts=2 sw=2
autocmd Filetype json set ts=2 sts=2 sw=2
autocmd Filetype php set noexpandtab ts=4 sts=4 sw=4

" tab settings
nmap <Tab> [Tag]
map <silent> [Tag]c :tablast <bar> tabnew<CR>
map <silent> [Tag]<RIGHT> :tabnext<CR>
map <silent> [Tag]<LEFT> :tabprevious<CR>
