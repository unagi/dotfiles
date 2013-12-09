set nocompatible
filetype off
colorscheme desert

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif
call neobundle#rc(expand('~/.vim/'))

" -------
" Plugins
" -------
" Plugin base
NeoBundle 'Shougo/vimproc'

" Plugin neocomplecache
NeoBundle 'Shougo/neocomplcache', {
    \ 'autoload' : {
    \   'insert' : 1,
    \ }}
NeoBundle 'Shougo/neosnippet', {
    \ 'autoload' : {
    \   'insert' : 1,
    \ }}
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_auto_completion_start_length = 3
let g:neocomplcache_enable_underbar_completion = 1
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
NeoBundle 'Shougo/neocomplcache-rsense', {
    \ 'depends' : 'Shougo/neocomplcache',
    \ 'autoload': { 'filetypes': 'ruby' }}
NeoBundleLazy 'taichouchou2/rsense-0.3', {
    \ 'build' : {
    \   'mac' : 'ruby etc/config.rb > ~/.rsense',
    \ }}
let g:neocomplcache#sources#rsense#home_directory = '/usr/local/Cellar/rsense/0.3/libexec'

" Plugin for endwise
NeoBundleLazy 'tpope/vim-endwise', {
    \ 'autoload' : {
    \    'insert': 1,
    \ }}

NeoBundle 'h1mesuke/vim-alignta'

NeoBundle 'itchyny/lightline.vim'
let g:lightline = {
    \ 'colorscheme': 'solarized'
    \ }

" Plugin ruby
NeoBundleLazy 'vim-ruby/vim-ruby', {
    \ 'autoload' : { 'filetypes': ['ruby', 'eruby', 'haml'] } }
NeoBundleLazy 'skwp/vim-rspec', {
    \ 'autoload' : { 'filetypes': ['ruby', 'eruby', 'haml'] } }
NeoBundleLazy 'ruby-matchit', {
    \ 'autoload' : { 'filetypes': ['ruby', 'eruby', 'haml'] } }
NeoBundleLazy 'ngmy/vim-rubocop', {
    \ 'autoload' : { 'filetypes': ['ruby', 'eruby', 'haml'] } }

" Plugin jedi
NeoBundleLazy 'davidhalter/jedi-vim', {
    \ 'autoload' : { 'filetypes': 'python' }}
autocmd FileType python let b:did_ftplugin = 1
let g:jedi#show_function_definition = 0
let g:jedi#popup_select_first = 0
let g:jedi#popup_on_dot = 0

" Plugin quickrun
NeoBundle 'thinca/vim-quickrun'
let g:quickrun_config = {}
let g:quickrun_config['markdown'] = {
    \ 'outputter': 'browser'
    \ }

" Plugin for filer
NeoBundle 'scrooloose/nerdtree'
let file_name = expand("%:p")
if has('vim_starting') && file_name == ""
    autocmd VimEnter * execute 'NERDTree ./'
endif

" Plugin for syntax check
NeoBundle 'scrooloose/syntastic'
let g:syntastic_enable_signs = 1
let g:syntastic_enable_highlighting = 1

" Plugin for JSON
NeoBundle 'JSON.vim', {
    \ 'autoload' : { 'filetypes': 'json' }}

" Plugin others
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'thinca/vim-ref'
NeoBundle 'unagi/vim-moncf'
NeoBundle 'hallison/vim-markdown'
NeoBundle 'Yggdroot/indentLine'
let g:indentLine_color_term = 239

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

" filetype settings
filetype on
filetype indent on
filetype plugin on
syntax on

au! BufRead,BufNewFile *.json set filetype=json
autocmd Filetype ruby set ts=2 sts=2 sw=2
autocmd Filetype eruby set ts=2 sts=2 sw=2
autocmd Filetype html set ts=2 sts=2 sw=2
autocmd Filetype css set ts=2 sts=2 sw=2
autocmd Filetype yaml set ts=2 sts=2 sw=2
autocmd Filetype javascript set ts=2 sts=2 sw=2
autocmd Filetype json set ts=2 sts=2 sw=2

" tab settings
nmap <Tab> [Tag]
map <silent> [Tag]c :tablast <bar> tabnew<CR>
map <silent> [Tag]<RIGHT> :tabnext<CR>
map <silent> [Tag]<LEFT> :tabprevious<CR>
