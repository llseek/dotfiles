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
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'scrooloose/nerdtree'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-ruby/vim-ruby'
Plug 'michaeljsmith/vim-indent-object'
Plug 'scrooloose/syntastic'
Plug 'vim-scripts/TeTrIs.vim'
Plug 'tpope/vim-fugitive'
Plug 'jiangmiao/auto-pairs'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-obsession'

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
Plug 'flazz/vim-colorschemes'
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/asyncrun.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }
Plug 'junegunn/fzf.vim'

" iOS development specific
"Plug 'Rip-Rip/clang_complete'
"Plug 'guns/ultisnips'
"Plug 'terhechte/syntastic'
"Plug 'b4winckler/vim-objc'
"Plug 'eraserhd/vim-ios.git'
call plug#end()

" === General Options ===
"let mapleader=" "
syntax on
set encoding=utf-8
set fileencodings=utf-8
set autoindent
set smartindent
set number
set ruler
set hlsearch
set incsearch
set t_Co=256
set laststatus=2
set colorcolumn=81
colorscheme default
hi Search cterm=underline ctermfg=yellow ctermbg=none
hi Visual cterm=underline ctermfg=yellow ctermbg=none
hi Pmenu cterm=none ctermfg=yellow ctermbg=darkblue
hi PmenuSel cterm=none ctermfg=darkblue ctermbg=yellow

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
map <C-\> :GtagsCursor<CR>

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
let g:airline_theme='papercolor'
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

" === Clang Complete Options ===
" Disable auto completion, always <C-X> <C-O> to complete
"let g:clang_complete_auto=1
"let g:clang_use_library=1
"let g:clang_periodic_quickfix=0
"let g:clang_close_preview=1
" For Objective-C, this needs to be active, otherwise multi-parameter
" methods won't be completed correctly
"let g:clang_snippets=1
" Snipmate does not work anymore, ultisnips is the recommended plugin
"let g:clang_snippets_engine='ultisnips'
" This might change depending on your installation
"let g:clang_exec='/usr/bin/clang'
"let g:clang_library_path="/usr/local/Cellar/llvm/HEAD/lib/libclang.dylib"
"let g:clang_library_path="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/"

" === Syntastic Options ===
" Show sidebar signs.
"let g:syntastic_enable_signs=1
" Read the clang complete file
"let g:syntastic_objc_config_file = '.clang_complete'
" Status line configuration
"set statusline+=%#warningmsg#  " Add Error ruler.
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"nnoremap <silent> ` :Errors<CR>
" Tell it to use clang instead of gcc
"let g:syntastic_objc_checker = 'clang'
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs = 0

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

" === Gutentags Options ===
let g:gutentags_project_root = ['.git', '.svn', '.hg']
let g:gutentags_modules = []
if executable('ctags')
	let g:gutentags_modules += ['ctags']
endif
if executable('gtags-cscope') && executable('gtags')
	let g:gutentags_modules += ['gtags_cscope']
endif

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
