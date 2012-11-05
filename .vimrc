set nocompatible

set rtp+=~/dotfiles/.vim/vundle.git/
call vundle#rc()

Bundle 'unagi/vim-moncf'
Bundle 'Shougo/neocomplcache'
" Use neocomplcache.
let g:NeoComplCache_EnableAtStartup = 1
" Use smartcase.
let g:NeoComplCache_SmartCase = 1
" Use camel case completion.
let g:NeoComplCache_EnableCamelCaseCompletion = 1
" Use underbar completion.
let g:NeoComplCache_EnableUnderbarCompletion = 1
" Set minimum syntax keyword length.
let g:NeoComplCache_MinSyntaxLength = 3
" Set manual completion length.
let g:NeoComplCache_ManualCompletionStartLength = 0

" Print caching percent in statusline.
"let g:NeoComplCache_CachingPercentInStatusline = 1

" Define dictionary.
let g:NeoComplCache_DictionaryFileTypeLists = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions', 
            \ 'scala' : $DOTVIM.'/dict/scala.dict', 
            \ 'ruby' : $DOTVIM.'/dict/ruby.dict'
            \ }

" Define keyword.
if !exists('g:NeoComplCache_KeywordPatterns')
    let g:NeoComplCache_KeywordPatterns = {}
endif
let g:NeoComplCache_KeywordPatterns['default'] = '\v\h\w*'

let g:NeoComplCache_SnippetsDir = $HOME.'/snippets'

Bundle 'Shougo/unite.vim'
Bundle 'thinca/vim-ref'
Bundle 'thinca/vim-quickrun'

syntax on
colorscheme desert

set number
set ruler
set laststatus=2
set title
set showcmd

set autoindent
set tabstop=4
set shiftwidth=4
set expandtab

filetype on
filetype indent on
filetype plugin on
