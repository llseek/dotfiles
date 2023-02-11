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
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'lighttiger2505/deoplete-vim-lsp'
Plug 'lifepillar/vim-solarized8'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }
Plug 'junegunn/fzf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'mmarchini/bpftrace.vim'
Plug 'airblade/vim-rooter'
Plug 'ryanoasis/vim-devicons'
Plug 'bagrat/vim-buffet'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
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
nmap bd :bdelete<CR>
nmap bn :bnext<CR>
nmap bp :bprevious<CR>

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
set hlsearch
set incsearch
set laststatus=1
set showtabline=2
set backspace=indent,eol,start
set fillchars+=vert:\ 
set updatetime=1000
set signcolumn=auto
set noequalalways
set wildmode
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
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
set splitbelow
set splitright

" Terminal
if has('nvim')
  tnoremap <Esc> <C-\><C-N>
  tnoremap <C-[> <C-\><C-N>
  tnoremap <C-h> <C-\><C-N><C-w>h
  tnoremap <C-j> <C-\><C-N><C-w>j
  tnoremap <C-k> <C-\><C-N><C-w>k
  tnoremap <C-l> <C-\><C-N><C-w>l
  au TermOpen * startinsert
  au TermOpen * set nonu
  au BufEnter * if &buftype == 'terminal' | startinsert | endif
else
  tnoremap <Esc> <C-w>N
  tnoremap <C-[> <C-w>N
  tnoremap <C-j> <C-w>j
  tnoremap <C-k> <C-w>k
  tnoremap <C-l> <C-w>l
  tnoremap <C-h> <C-w>h
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

if has('nvim')
  function! CreateCenteredFloatingWindow()
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
  endfunction
  let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }
else
  let g:fzf_layout = { 'window': 'enew' }
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
nmap gt :LspTypeDefinition<CR>
hi LspCxxHlGroupMemberVariable guifg=#93a1a1

" Deoplete
let g:deoplete#enable_at_startup = 1
 
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

" Buffet
let g:buffet_always_show_tabline = 1
let g:buffet_powerline_separators = 1
let g:buffet_use_devicons = 1
let g:buffet_tab_icon = ''
function! g:BuffetSetCustomColors()
  hi! BuffetCurrentBuffer guibg=#268bd2 guifg=#002b36
  hi! BuffetActiveBuffer guibg=#268bd2 guifg=#002b36
  hi! BuffetBuffer guibg=#002b36 guifg=#839496
  hi! BuffetTab guibg=#268bd2 guifg=#002b36
  hi! BuffetTrunc guibg=#b58900
endfunction

" Clang-format
map <C-f> :pyf /usr/share/vim/addons/syntax/clang-format.py<CR>

" Pandoc
let g:pandoc#spell#enabled = 0

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
