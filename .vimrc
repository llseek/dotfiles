" Memo
" diw - delete the word that cursor is on
" ciw - edit the word that cursor is on
" ci( - edit the content inside ()
" vip - select the paragraph

" Plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
Plug 'vim-scripts/a.vim'
Plug 'vim-scripts/gtags.vim'
Plug 'vim-scripts/DrawIt'
Plug 'godlygeek/tabular'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-ruby/vim-ruby'
Plug 'tmux-plugins/vim-tmux'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'michaeljsmith/vim-indent-object'
Plug 'scrooloose/syntastic'
Plug 'vim-scripts/TeTrIs.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-obsession'
Plug 'mileszs/ack.vim'
Plug 'junegunn/gv.vim'
Plug 'mhinz/vim-startify'

" default snippets (under .vim/bundle/vim-snippets/)
"   contents:
"   - snippets/*: snippets using snipMate format
"   - UltiSnips/*: snippets using UltiSnips format
Plug 'honza/vim-snippets'
" snippet engine(python), supports all snippets in above repo
"Plug 'SirVer/ultisnips'
" snippet engine(VimL), supports snippets/*
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'lifepillar/vim-solarized8'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }
Plug 'junegunn/fzf.vim'
Plug 'llseek/YouCompleteMe', { 'branch': 'prio-c++17' }
Plug 'jeaye/color_coded'
Plug 'voldikss/vim-floaterm'
call plug#end()

" General
syntax on
inoremap jj <ESC>:w<CR>
noremap <Leader>r :source ~/.vimrc<CR>

set exrc secure
set mouse=a
set encoding=utf-8
set fileencodings=utf-8
set autoindent
set smartindent
set number
set ruler
set hlsearch
set incsearch
set laststatus=2
set backspace=indent,eol,start
set fillchars+=vert:│
set updatetime=1000
" :help last-position-jump
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Colorscheme
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
if exists('+termguicolors')
  set termguicolors
else
  set t_Co=256
endif
set background=light
colorscheme solarized8

" Clipboard
if has('clipboard')
    if has('unnamedplus') " On Linux, use + register
        set clipboard=unnamed,unnamedplus
    else        " On Mac and Windows, use * register
        set clipboard=unnamed
    endif
endif

" Indentation
filetype plugin indent on
au FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
au FileType groovy setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
au FileType xml setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
au FileType json setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
au FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
au FileType sh setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
au FileType yaml setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
au FileType cpp setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
"make.inc is detected as pov filetype, set syntax to Makefile
au FileType pov set syntax=make
au BufRead,BufNewFile *.jelly set syntax=html

" Split
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l
tnoremap <C-h> <C-w>h
set splitbelow
set splitright

" Gtags
map <C-n> :cn<CR>
map <C-p> :cp<CR>
"map <C-\> :GtagsCursor<CR>

" Tagbar
let g:tagbar_position = 'right'
let g:tagbar_autoclose = 0
let g:tagbar_sort = 0
let g:tagbar_compact = 1
let g:tagbar_indent = 1
let g:tagbar_foldlevel = 0
let g:tagbar_autoshowtag = 1
let g:tagbar_singleclick = 1
au FileType c,cpp nested :TagbarOpen

" Nerdtree
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.swp$']

" returns true iff is NERDTree open/active
function! IsNTOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" returns true iff focused window is NERDTree window
function! IsNTFocused()
  return -1 != match(expand('%'), 'NERD_Tree')
endfunction

" returns true iff focused window contains a file in current pwd
function! IsInsideCwd()
  return -1 != stridx(expand('%:p'), getcwd())
endfunction

function! s:isTagbar()
  return 0 == match(bufname(''), '__Tagbar__')
endfunction

" calls NERDTreeFind iff NERDTree is active, current window contains a modifiable file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNTOpen() && !IsNTFocused() && strlen(expand('%')) > 0 && !&diff && IsInsideCwd() && !s:isTagbar()
    NERDTreeFind
    wincmd p
  endif
endfunction

au BufEnter * call SyncTree()

function! OpenNERDTree()
  if exists(':NERDTree')
    NERDTree | wincmd w
  endif
endfunction

au VimEnter * :call OpenNERDTree()
au BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Airline
let g:airline_theme='solarized'
let g:airline#extensions#whitespace#mixed_indent_algo=1
let g:airline#extensions#tabline#enabled = 1

" Quickfix
"nnoremap <C-q> :cclose<CR> - use togglelist.vim ?
au FileType qf call AdjustWindowHeight(7, 12)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" Tmux navigator
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>
let g:tmux_navigator_save_on_switch = 1

" Fugitive
nnoremap gst :Git status<CR>
nnoremap gb :Git blame<CR>
nnoremap gc :Gcommit -v<CR>
nnoremap gc! :Gcommit --amend<CR>
nnoremap gp :Git push<CR>
nnoremap gup :Git pull --rebase<CR>
nnoremap grbi :Git rebase -i<CR>

" GitGutter
nnoremap ga :GitGutterStageHunk<CR>
nnoremap gu :GitGutterUndoHunk<CR>

" Fzf
map <C-f> :Files<CR>
map <C-g> :Rg<CR>
let $FZF_DEFAULT_COMMAND = 'ack -g ""'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'window': 'enew' }

" YCM
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_language_server =
  \ [{
  \   'name': 'ccls',
  \   'cmdline': [ 'ccls'  ],
  \   'filetypes': [ 'c', 'cpp', 'cuda', 'objc', 'objcpp'  ],
  \   'project_root_files': [ '.ccls-root', 'compile_commands.json'  ]
  \ }]
let g:ycm_auto_hover = ''
nmap <leader>d <plug>(YCMHover)
nmap gd :YcmCompleter GoTo<CR>
nmap gy :YcmCompleter GoToType<CR>
nmap gi :YcmCompleter GoToImplementation<CR>
nmap gr :YcmCompleter GoToReferences<CR>
nmap gs :YcmCompleter GoToSymbol 

" Termdebug
packadd termdebug
let g:termdebug_wide = 1
tnoremap <silent> <C-a>[ <C-w>N:set nonu<cr>
nnoremap <silent> <C-a>r :Run<CR>
nnoremap <C-a>a :Arguments
nnoremap <silent> <C-a>b :Break<CR>
nnoremap <silent> <C-a>d :Clear<CR>
nnoremap <silent> <C-a>s :Step<CR>
nnoremap <silent> <C-a>n :Over<CR>
nnoremap <silent> <C-a>f :Finish<CR>
nnoremap <silent> <C-a>c :Continue<CR>
nnoremap <silent> <C-a>p :Eval<CR>

" Color_coded
hi link Member Normal
hi link Variable Normal
hi Namespace guifg=red
hi link EnumConstant Constant
hi link StructDecl Type
hi link UnionDecl Type
hi link ClassDecl Type
hi link EnumDecl Type

" Floaterm
let g:floaterm_keymap_toggle = '<Leader>t'
let g:floaterm_autoclose=2
