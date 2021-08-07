" Memo
" text object:
" diw - delete the word that cursor is on
" ciw - edit the word that cursor is on
" ci( - edit the content inside ()
" vip - select the paragraph
"
" surround:
" cs'"  - change surround from ' to "
" ds'   - delete surround '
" ysiw' - add surround around current word
" yss'  - add surround around current line
" ysip' - add surround around current paragraph

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
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-surround'
Plug 'junegunn/gv.vim'
Plug 'mhinz/vim-startify'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
Plug 'prabirshrestha/vim-lsp'
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'lifepillar/vim-solarized8'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }
Plug 'junegunn/fzf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'mmarchini/bpftrace.vim'
Plug 'airblade/vim-rooter'
call plug#end()

" General
syntax on
inoremap jj <ESC>:w<CR>
map ,e :e <C-R>=expand("%:h") . "/" <CR>
map ,s :split <C-R>=expand("%:h") . "/" <CR>
map ,v :vsplit <C-R>=expand("%:h") . "/" <CR>
noremap <Leader>r :source ~/.vimrc<CR>

set exrc secure
set mouse=a
set ttymouse=xterm2
set encoding=utf-8
set fileencodings=utf-8
set autoindent
set smartindent
set nonu
set ruler
set hlsearch
set incsearch
set laststatus=2
set showtabline=2
set backspace=indent,eol,start
set fillchars+=vert:\ 
set updatetime=1000
set signcolumn=auto
set noequalalways
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
set background=dark
colorscheme solarized8
if &background == 'light'
  hi VertSplit guibg=#eee8d5
  hi SignColumn guibg=#eee8d5
elseif &background == 'dark'
  hi VertSplit guibg=#073642
  hi SignColumn guibg=#073642
endif

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
map <C-\> :GtagsCursor<CR>

" Tagbar
let g:tagbar_sort = 0
let g:tagbar_compact = 1
let g:tagbar_indent = 1
let g:tagbar_foldlevel = 0
let g:tagbar_autoshowtag = 1
let g:tagbar_singleclick = 1
"au FileType c,cpp nested :TagbarOpen

" Nerdtree
let NERDTreeShowHidden=1
let NERDTreeMouseMode=3
let NERDTreeMinimalUI=1
let NERDTreeIgnore = ['\.swp$', '.git', '.ccls-cache']

function! s:isNERDTreeOpen()
  return exists("g:NERDTree") && g:NERDTree.IsOpen()
endfunction

function! s:isInsideCwd()
  return -1 != stridx(expand('%:p'), getcwd())
endfunction

function! s:isNERDTree()
  return 0 == match(bufname(''), 'NERD_tree_')
endfunction

function! s:isTagbar()
  return 0 == match(bufname(''), '__Tagbar__')
endfunction

function! SyncNERDTree()
  if &modifiable && !&diff && s:isNERDTreeOpen() && s:isInsideCwd() && !s:isNERDTree() && !s:isTagbar()
    NERDTreeFind | wincmd p
  endif
endfunction

au BufEnter * call SyncNERDTree()

function! OpenNERDTree()
  if exists(':NERDTree')
    NERDTree | wincmd w
  endif
endfunction

" au VimEnter * :call OpenNERDTree()

au BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Lightline
let g:lightline = {}
let g:lightline.colorscheme = 'solarized'
let g:lightline.active = { 'left': [['filename','line']], 'right': [] }
let g:lightline.inactive = { 'left': [['filename','line']], 'right': [] }
let g:lightline.enable = { 'statusline': 1, 'tabline': 1 }
"let g:lightline.separator = { 'left': '', 'right': '' }
"let g:lightline.subseparator = { 'left': '', 'right': '' }
let g:lightline.tabline = { 'left': [['buffers']], 'right': [[]] }
let g:lightline.component_expand = { 'buffers': 'lightline#bufferline#buffers' }
let g:lightline.component_type = { 'buffers': 'tabsel' }
if has('nvim')
let g:lightline.component_raw = {'buffers': 1}
let g:lightline#bufferline#clickable = 1
endif
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#number_map = {
  \ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
  \ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹' }
nmap b1 <Plug>lightline#bufferline#go(1)
nmap b2 <Plug>lightline#bufferline#go(2)
nmap b3 <Plug>lightline#bufferline#go(3)
nmap b4 <Plug>lightline#bufferline#go(4)
nmap b5 <Plug>lightline#bufferline#go(5)
nmap b6 <Plug>lightline#bufferline#go(6)
nmap b7 <Plug>lightline#bufferline#go(7)
nmap b8 <Plug>lightline#bufferline#go(8)
nmap b9 <Plug>lightline#bufferline#go(9)
nmap b0 <Plug>lightline#bufferline#go(10)
nmap d1 <Plug>lightline#bufferline#delete(1)
nmap d2 <Plug>lightline#bufferline#delete(2)
nmap d3 <Plug>lightline#bufferline#delete(3)
nmap d4 <Plug>lightline#bufferline#delete(4)
nmap d5 <Plug>lightline#bufferline#delete(5)
nmap d6 <Plug>lightline#bufferline#delete(6)
nmap d7 <Plug>lightline#bufferline#delete(7)
nmap d8 <Plug>lightline#bufferline#delete(8)
nmap d9 <Plug>lightline#bufferline#delete(9)
nmap d0 <Plug>lightline#bufferline#delete(10)

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
nmap gk <plug>(GitGutterPrevHunk)zz
nmap gj <plug>(GitGutterNextHunk)zz

" Startify
let g:startify_session_dir = '.session'
let g:startify_session_before_save = [
  \ 'silent! NERDTreeClose',
  \ 'silent! TagbarClose'
  \ ]

" UltiSnips
let g:UltiSnipsExpandTrigger="<c-e>"

" Fzf
map ff :Files<CR>
map rg :Rg<CR>
map fb :Buffers<CR>
map fc :Commits<CR>
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden '
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'window': 'enew' }

" VIM-LSP
if executable('ccls')
   au User lsp_setup call lsp#register_server({
      \ 'name': 'ccls',
      \ 'cmd': {server_info->['ccls']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
      \ 'initialization_options': { 'highlight': { 'lsRanges': v:true } },
      \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
      \ })
endif
let g:lsp_diagnostics_enabled = 0
nmap gd :LspDefinition<CR>
nmap gs :LspWorkspaceSymbol<CR>
nmap gr :LspReferences<CR>
nmap gi :LspImplementation<CR>
nmap gt :LspTypeDefinition<CR>
 
" Termdebug
packadd termdebug
function! ExitNormalMode()
    unmap <buffer> <silent> <RightMouse>
    call feedkeys("a")
endfunction

function! EnterNormalMode()
    if &buftype == 'terminal' && mode('') == 't'
        set nonu
        call feedkeys("\<c-w>N")
        call feedkeys("\<c-y>")
        map <buffer> <silent> <RightMouse> :call ExitNormalMode()<CR>
    endif
endfunction

tmap <silent> <ScrollWheelUp> <c-w>:call EnterNormalMode()<CR>

" Rooter
let g:rooter_patterns = ['.git']
