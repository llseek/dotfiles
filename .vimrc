" === Text Objects ===
" diw - delete the word that cursor is on
" ciw - edit the word that cursor is on
" ci( - edit the content inside ()
" vip - select the paragraph

" === Vim-plug Options ===
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
Plug 'vim-scripts/a.vim'
Plug 'vim-scripts/taglist.vim'
Plug 'vim-scripts/gtags.vim'
Plug 'vim-scripts/ScrollColors'
Plug 'vim-scripts/ZoomWin'
Plug 'vim-scripts/DrawIt'
Plug 'godlygeek/tabular'
Plug 'scrooloose/nerdtree'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-ruby/vim-ruby'
Plug 'tmux-plugins/vim-tmux'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'michaeljsmith/vim-indent-object'
Plug 'scrooloose/syntastic'
Plug 'vim-scripts/TeTrIs.vim'
Plug 'tpope/vim-fugitive'
Plug 'jiangmiao/auto-pairs'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-obsession'
Plug 'mileszs/ack.vim'
Plug 'junegunn/gv.vim'

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
Plug 'skywind3000/asyncrun.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }
Plug 'junegunn/fzf.vim'
Plug 'llseek/YouCompleteMe', { 'branch': 'prio-c++17' }
Plug 'jeaye/color_coded'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
call plug#end()

" === General Options ===
"let mapleader=" "
syntax on
set exrc secure
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
"set colorcolumn=81

" recommended by solarized8
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
if exists('+termguicolors')
  set termguicolors
else
  set t_Co=256
endif
set background=dark
colorscheme solarized8

" == Record/Replay Options ===
:nnoremap <space> @q

" === Tab/Space Options ===
set tabstop=8
set shiftwidth=8
set softtabstop=8
"set expandtab

" === Fold Options ===
set foldenable
set foldmethod=syntax
set foldcolumn=0
set foldlevel=99
hi Folded ctermbg=none
"nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zC' : 'zO')<CR>
" refer https://upload.wikimedia.org/wikipedia/en/1/15/Xterm_256color_chart.svg for color-number mappings
"if has("autocmd")
"    au BufWinLeave * mkview
"    au BufWinEnter * silent loadview
"    au! BufReadPost,BufWritePost * silent loadview
"endif

" === Split Options ===
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

" === Gtags Options ===
map <C-n> :cn<CR>
map <C-p> :cp<CR>
"map <C-\> :GtagsCursor<CR>

" === Taglist Options ===
map <F9> :TlistToggle<CR>
let TagList_Show_One_File=1
let Tlist_Auto_Open=0
let Tlist_Auto_Update=1
let Tlist_Exit_OnlyWindow=1
let Tlist_GainFocus_On_ToggleOpen=1
let Tlist_File_Fold_Auto_Close=1
let Tlist_Enable_Fold_Colum=1

" === Tagbar Options ===
nmap <F8> :TagbarToggle<CR>
let g:tagbar_left=1
let g:tagbar_width=30
let g:tagbar_autoclose=0
let g:tagbar_sort=0
"au VimEnter * nested :call tagbar#autoopen(1)

" === Nerdtree Options ===
map <F7> :NERDTreeToggle<CR>

" === Airline Options ===
let g:airline_theme='solarized'
let g:airline#extensions#whitespace#mixed_indent_algo=1

" === Mouse Options ===
set mouse=r
set mousehide

" === Quickfix Options ===
"nnoremap <C-q> :cclose<CR> - use togglelist.vim ?
au FileType qf call AdjustWindowHeight(7, 12)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" === AutoCmd Options ===
if has("autocmd")
    filetype plugin indent on
endif

if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

if has("autocmd")
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
endif

"if has("autocmd")
    " delete trailing whitespaces
"    autocmd BufWritePre *.[c|h] :%s/\s\+$//e
"endif

" === Misc Options ===
" Open files in the same directory as the current file
map ,e :e <C-R>=expand("%:h") . "/" <CR>
map ,t :tabe <C-R>=expand("%:h") . "/" <CR>
map ,s :split <C-R>=expand("%:h") . "/" <CR>
map ,v :vsplit <C-R>=expand("%:h") . "/" <CR>
" map Escape key to jj
inoremap jj <ESC>:w<CR>

" === Leader Options ===
"nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) - 5)<CR>
"nnoremap <silent> <Leader>= :exe "resize " . (winheight(0) + 5)<CR>
"nnoremap <silent> <Leader>9 :exe "vertical resize " . (winwidth(0) - 5)<CR>
"nnoremap <silent> <Leader>0 :exe "vertical resize " . (winwidth(0) + 5)<CR>

" === Vim Tmux Navigator Options ===
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>
let g:tmux_navigator_save_on_switch = 1

" === AsyncRun Options ===
let g:asyncrun_open = 6
let g:asyncrun_bell = 1

" === FZF Options ===
map <C-f> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'down': '~20%' }

" === YCM Options ===
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_language_server =
  \ [{
  \   'name': 'ccls',
  \   'cmdline': [ 'ccls'  ],
  \   'filetypes': [ 'c', 'cpp', 'cuda', 'objc', 'objcpp'  ],
  \   'project_root_files': [ '.ccls-root', 'compile_commands.json'  ]
  \ }]
map <C-]> :YcmCompleter GoTo<CR>
map <C-\> :YcmCompleter GoToReferences<CR>

" === TermDebug Options ===
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

" === Color Coded Options ===
hi link Member Normal
hi link Variable Normal
hi Namespace guifg=red
hi link EnumConstant Constant
hi link StructDecl Type
hi link UnionDecl Type
hi link ClassDecl Type
hi link EnumDecl Type
