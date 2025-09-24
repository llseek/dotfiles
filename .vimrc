" Memo
"
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
" S'    - add surround around selection
"
" window:
" <C-w>hjkl - move to window
" <C-w>n    - new window
" <C-w>o    - close other windows
" <C-w>s    - split horizontally
" <C-w>v    - split vertically
" <C-w>q    - close window
" <C-w>t    - open terminal
" <C-w>T    - open terminal vertically
"
" tab:
" gt - next tab
" gT - previous tab

" Plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
Plug 'vim-scripts/netrw.vim'
Plug 'vim-scripts/a.vim'
Plug 'vim-scripts/gtags.vim'
Plug 'vim-scripts/DrawIt'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
"Plug 'jiangmiao/auto-pairs'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-surround'
Plug 'junegunn/gv.vim'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
Plug 'prabirshrestha/vim-lsp'
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'lifepillar/vim-solarized8'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'mmarchini/bpftrace.vim'
Plug 'airblade/vim-rooter'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'gcmt/taboo.vim'
Plug 'github/copilot.vim'
if has('nvim')
  Plug 'mfussenegger/nvim-dap'
  Plug 'mfussenegger/nvim-dap-python'
  Plug 'rcarriga/nvim-dap-ui'
endif
call plug#end()

" General
syntax on
inoremap jj <ESC>:w<CR>
map ,e :e <C-R>=expand("%:h") . "/" <CR>
map ,s :split <C-R>=expand("%:h") . "/" <CR>
map ,v :vsplit <C-R>=expand("%:h") . "/" <CR>
noremap <Leader>r :source ~/.vimrc<CR>
tnoremap gt <C-w>:tabnext<CR>
tnoremap gT <C-w>:tabprevious<CR>

set exrc secure
set mouse=a
if !has('nvim')
set ttymouse=xterm2
endif
set encoding=utf-8
set fileencodings=utf-8
set autoindent
set smartindent
set number
set ruler
set cursorline
set hlsearch
set incsearch
set laststatus=1
set showtabline=2
set backspace=indent,eol,start
set fillchars+=vert:\ 
set updatetime=1000
set noequalalways
set matchpairs+=<:>
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
au FileType cmake setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab

" Split
set splitbelow
set splitright

" Session
set sessionoptions+=resize,tabpages,globals
au VimLeave * if &filetype !=# 'gitcommit' && &filetype !=# 'gitrebase' | :mks! ~/.vim/session.vim | endif
au VimEnter * if &filetype !=# 'gitcommit' && &filetype !=# 'gitrebase' | :so ~/.vim/session.vim | endif

" Terminal
if has('nvim')
  "tnoremap <C-[> <C-\><C-N>
  tnoremap <C-h> <C-\><C-N><C-w>h
  tnoremap <C-j> <C-\><C-N><C-w>j
  tnoremap <C-k> <C-\><C-N><C-w>k
  tnoremap <C-l> <C-\><C-N><C-w>l
  au TermOpen * startinsert | set nonu
  au TermEnter * set nonu
  au BufEnter * if &buftype == 'terminal' | startinsert | else | set nu | endif
else
  noremap <C-w>t :term<CR>
  noremap <C-w>T :vert term<CR>
  tnoremap <C-w>t <C-w>:term<CR>
  tnoremap <C-w>T <C-w>:vert term<CR>
endif

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

" Airline
let g:airline_theme='solarized'
let g:airline_powerline_fonts = 1
let g:airline_mode_map = {
    \ '__'     : '-',
    \ 'c'      : 'C',
    \ 'i'      : 'I',
    \ 'ic'     : 'I',
    \ 'ix'     : 'I',
    \ 'n'      : 'N',
    \ 'multi'  : 'M',
    \ 'ni'     : 'N',
    \ 'no'     : 'N',
    \ 'R'      : 'R',
    \ 'Rv'     : 'R',
    \ 's'      : 'S',
    \ 'S'      : 'S',
    \ ''     : 'S',
    \ 't'      : 'T',
    \ 'v'      : 'V',
    \ 'V'      : 'V',
    \ ''     : 'V',
    \ }
let g:airline#extensions#default#layout = [[ 'a', 'b', 'c' ], []]
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#tabs_label = ''
let g:airline#extensions#tabline#buffers_label = ''
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_tab_count = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_tab_type = 0

" Quickfix
"nnoremap <C-q> :cclose<CR> - use togglelist.vim ?
au FileType qf call AdjustWindowHeight(7, 12)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" Fugitive
nnoremap gst :Git status<CR>
nnoremap gb :Git blame<CR>
nnoremap gc :Git commit -v<CR>
nnoremap gc! :Git commit --amend<CR>
nnoremap gp :Git push<CR>
nnoremap gup :Git pull --rebase<CR>
nnoremap grbi :Git rebase -i<CR>

" GitGutter
nnoremap ga :GitGutterStageHunk<CR>
nnoremap gu :GitGutterUndoHunk<CR>
nmap gk <plug>(GitGutterPrevHunk)zz
nmap gj <plug>(GitGutterNextHunk)zz

" UltiSnips
let g:UltiSnipsExpandTrigger="<c-e>"

" Fzf
if !has('nvim')
  map ff :Files<CR>
  map rg :Rg<CR>
  map fb :Buffers<CR>
  map fc :Commits<CR>
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden '
  let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit' }
  let g:fzf_layout = { 'window': 'enew' }

  command! -bang -nargs=* RgExact
  \ call fzf#vim#grep(
  \   'rg -F --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

  map fg :execute 'RgExact ' . expand('<cword>') <Cr>
endif

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

if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'initialization_options': { 'highlight': { 'lsRanges': v:true } },
        \ 'allowlist': ['python'],
        \ })
endif

let g:lsp_diagnostics_enabled = 0
nmap gd :LspDefinition<CR>
nmap gs :LspWorkspaceSymbol<CR>
nmap gr :LspReferences<CR>
nmap gi :LspImplementation<CR>
hi LspCxxHlGroupMemberVariable guifg=#93a1a1

" Termdebug
packadd termdebug
if !has('nvim')
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
endif

" Rooter
let g:rooter_patterns = ['compile_commands.json', '.git']

" Clang-format
map <C-f> :pyf /usr/share/vim/addons/syntax/clang-format.py<CR>

" Pandoc
let g:pandoc#spell#enabled = 0

" Taboo
let g:taboo_tabline = 0

" Copilot
let g:copilot_node_command = "~/.nvm/versions/node/v22.19.0/bin/node"

" Nvim-dap
if has('nvim')
  lua require('dap-python').setup('python')
  lua require('dapui').setup()

  nnoremap <silent> <Leader>r <Cmd>lua require'dap'.continue()<CR>
  nnoremap <silent> <Leader>c <Cmd>lua require'dap'.continue()<CR>
  nnoremap <silent> <F6> <Cmd>lua require'dap'.run_last()<CR>
  nnoremap <silent> <Leader>n <Cmd>lua require'dap'.step_over()<CR>
  nnoremap <silent> <Leader>s <Cmd>lua require'dap'.step_into()<CR>
  nnoremap <silent> <Leader>f <Cmd>lua require'dap'.step_out()<CR>
  nnoremap <silent> <Leader>u <Cmd>lua require'dap'.run_to_cursor()<CR>
  nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
  nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.toggle()<CR>
  nnoremap <silent> <Leader>d <Cmd>lua require'dapui'.toggle()<CR>
  nnoremap <silent> <Leader>e <Cmd>lua require'dapui'.eval()<CR>
endif
