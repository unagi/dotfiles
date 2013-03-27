set nocompatible
filetype off
colorscheme desert

set rtp+=~/dotfiles/.vim/neobundle
if has('vim_starting')
  set runtimepath+=~/dotfiles/.vim/neobundle
  call neobundle#rc(expand('~/.vim/'))
endif

NeoBundle 'unagi/vim-moncf'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_auto_completion_start_length = 3

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'tyru/open-browser.vim'

NeoBundle 'h1mesuke/unite-outline'

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

let g:quickrun_config = {}
let g:quickrun_config['markdown'] = {
    \ 'outputter': 'browser'
    \ }

" filetype settings
filetype on
filetype indent on
filetype plugin on
syntax on

autocmd Filetype ruby set ts=2 sts=2 sw=2
autocmd Filetype html set ts=2 sts=2 sw=2
autocmd Filetype css set ts=2 sts=2 sw=2
autocmd Filetype yaml set ts=2 sts=2 sw=2
autocmd Filetype javascript set ts=2 sts=2 sw=2

set completeopt=menuone
