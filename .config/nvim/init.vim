" vim:fileencoding=utf-8:fdm=expr
" vim:fde=getline(v\:lnum)=~'^"#'?'>'.(matchend(getline(v\:lnum),'"#*')-1)\:'='

"# Plugins
" Bootstrap vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs
              \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

"## User Interface
Plug 'rafi/awesome-vim-colorschemes'
Plug 'chriskempson/base16-vim'
Plug 'airblade/vim-gitgutter'

"## Tools
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'tpope/vim-fugitive'

"## Editor
Plug 'mg979/vim-visual-multi'
Plug 'raimondi/delimitmate'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'

"## Development
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi'
" Plug 'zchee/deoplete-clang'
Plug 'deoplete-plugins/deoplete-tag'
Plug 'vim-syntastic/syntastic'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

"## Languages

"### A solid Language pack
Plug 'sheerun/vim-polyglot'

"### Fennel
Plug 'bakpakin/fennel.vim'

"### Smali
Plug 'kelwin/vim-smali'

"### C/C++
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'dr-kino/cscope-maps'

call plug#end()

"# User functions

"## Format buffer using clang-format
function! FormatBuffer()
    if empty(findfile('.clang-format', '.;'))
        set et ts=2 sts=2 sw=2
    endif

    let cursor_pos = getpos('.')
    :%!clang-format
    call setpos('.', cursor_pos)
endfunction

"## Strip trailing whitespaces
function! TrimSpaces()
    " Save cursor position
    let l:save = winsaveview()
    " Remove trailing whitespace
    %s/\s\+$//e
    " Move cursor to original position
    call winrestview(l:save)
    echo 'Stripped trailing whitespace'
endfunction


"## Terminal toggle
let g:term_win = 0
let g:term_buf = 0

function! TerminalToggle(height)
    if win_gotoid(g:term_win)
        hide
        let g:term_win = 0
    else
        if !buffer_exists(g:term_buf)
            let g:term_buf = 0
        endif
        if !g:term_buf
            exec 'botright new term://$SHELL'
            let g:term_buf = bufnr('')
        else
            exec 'botright sbuffer' .  g:term_buf
        endif
        startinsert!
        exec 'resize' . a:height

        let g:term_win = win_getid()
    endif
endfunction

"# Generals

" Encoding
set encoding=utf-8
set termencoding=utf-8

" Useless
set noswapfile
set nobackup

" Enable persistent undo
set undofile

" Shrink command history
set history=1000

" Allow expression to be set in the modeline
set modelineexpr

" Lower delay before diagnostics messages will be shown
set updatetime=1600

" Time for key combo waiting
set timeoutlen=300

"# Behaviour

" Hide annoying messages
set shortmess=actIF

" Search options
set incsearch
set smartcase

" A buffer becomes hidden when it is abandoned
set hidden

" Disable line wrapping
set nowrap

" Wrap size according to columnwidth
set textwidth=99

" Split vertical windows right to the current windows
set splitright

" Split horizontal windows below to the current windows
set splitbelow

" Completion
set completeopt=noinsert,menuone,noselect
set pumheight=14

" Caps guard
command! WQ wq
command! Wq wq
command! W w
command! Q q

"# Editing
set autoindent

" Smart autoindenting when starting a new line.
set smartindent

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Tab key
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" /g by default
set gdefault

" Use system clipboard
set clipboard^=unnamed,unnamedplus

"# Appearance
" Should accelerate UI
set lazyredraw

set cursorline
set mouse=a
set relativenumber
set number

" Show tabs and trailing whitespaces
set listchars=tab:▏\ ,eol:\ ,extends:,precedes:,space:\ ,trail:⋅
set list

" Vertical split line appearance
set fillchars=eob:\ ,fold:\ ,vert:\ 
" set fillchars=eob:\ ,fold:\ ,vert:\│

set foldcolumn=0
set signcolumn=yes
set colorcolumn=100

" Statusline
set laststatus=2

set statusline=%#Visual#
set statusline+=\ %f
set statusline+=\ %*
" set statusline+=\ %#LineNr#
set statusline+=\ %{fugitive#statusline()}
set statusline+=%m
set statusline+=%=
set statusline+=\%{&filetype}
set statusline+=\ \|
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ (%{&fileformat})
set statusline+=\ \ %p%%
set statusline+=\ \ %l:%c
set statusline+=\ %#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Colorscheme
set termguicolors

if $IS_BASH
    set bg=dark
    colorscheme alduin
else
    set bg=light
    colorscheme solarized8
endif

" Color overrides
hi! link VertSplit Normal
hi! link StatusLine LineNr
hi! link StatusLineNC CursorColumn

hi! link SignColumn LineNr
hi! link CursorLineNr LineNr
hi! link NormalNC ColorColumn

"# Autocommands
"## Filetypes
autocmd Filetype c,cpp,make,cmake,go,sh set noet colorcolumn=100
autocmd FileType python set et colorcolumn=80 textwidth=79
autocmd Filetype lua,lisp,js,html,css set et ts=2 sw=2 sts=2
autocmd Filetype markdown,csv set conceallevel=0
autocmd Filetype org set conceallevel=0 et ts=2 sw=2
autocmd BufNewFile,BufRead *.qss,*.rasi setfiletype css

"## Misc
" Automatically open the quickfix window after silent command execution
autocmd QuickFixCmdPost * :copen

" Disable automatic comment insertion
autocmd FileType * setlocal formatoptions-=cro

" Clean up terminal window
autocmd TermOpen * | setlocal nonu nornu signcolumn=no

" Reload Neovim config on write
" autocmd BufWritePost ~/.config/nvim/init.vim source %

"# Key mappings
let mapleader = ' '

" IH8 these
noremap <F1> <Esc>
inoremap <F1> <Esc>
noremap <RightMouse> <nop>
inoremap <RightMouse> <nop>

" Leave cursor after the new text
nnoremap p gp
nnoremap P gP
nnoremap gp p
nnoremap gP P

" Paste and indent
nnoremap =p p=']
nnoremap =P P=']
nnoremap =gP gPmz'[=']`z
nnoremap =gp gpmz'[=']`z

" Better wrap navigation
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" Tabs
nnoremap <silent> <M-h> :tabprevious<CR>
nnoremap <silent> <M-l> :tabnext<CR>
nnoremap <silent> <leader>t :tabnew<CR>
nnoremap <silent> <leader>w :tabclose<CR>

" Buffers
nnoremap <silent> <S-h> :bprevious<CR>
nnoremap <silent> <S-l> :bnext<CR>
nnoremap <silent> <leader>d :bdelete!<CR>

" Windows
nnoremap <silent> <Tab> <c-w><c-w>
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l
nnoremap <silent> <leader>q :q!<CR>

" Resize with arrows
" Using alt for vertical size, because conflict with multiple cursors mappings
nnoremap <silent> <M-Up> :resize +2<CR>
nnoremap <silent> <M-Down> :resize -2<CR>
nnoremap <silent> <M-Left> :vertical resize -2<CR>
nnoremap <silent> <M-Right> :vertical resize +2<CR>

" Move visual blocks up and down with <M-j> and <M-k>
nnoremap <M-k> :m .-2<CR>==
nnoremap <M-j> :m .+1<CR>==
inoremap <M-k> <Esc>:m .-2<CR>==gi
inoremap <M-j> <Esc>:m .+1<CR>==gi
vnoremap <M-k> :m '<-2<CR>gv=gv
vnoremap <M-j> :m '>+1<CR>gv=gv

" Jumping to errors
nnoremap <silent> ]e :lnext<CR>
nnoremap <silent> [e :lprev<CR>

" Set working directory to the current file
nnoremap <silent> cd :cd %:p:h<CR>:pwd<CR>

" Insert selection into command line
vnoremap ; y:<C-r>"<C-b>

" Shorts
nnoremap <Esc><Esc> :noh<CR>
nnoremap <leader>a ggVG<CR>
nnoremap <BS> ``
nnoremap . f.w
nnoremap gd <C-]>
nnoremap <leader>, :lopen<CR>
nnoremap <leader>. :copen<CR>

" Tired of holding modifier keys
inoremap hl λ
inoremap kj ()<Left>
inoremap jk ""<Left>
inoremap ;; :
nnoremap ; :
nnoremap `` @@

" Utils
nnoremap <leader>b :Git branch<CR>
nnoremap <leader>m :make<Space>
nnoremap <silent> <leader>= :call FormatBuffer()<CR>

" grep word under cursor
nnoremap <silent> <leader>g :Grep '\b<C-R><C-W>\b'<CR>:cw<CR>

" Terminal toggle 
nnoremap <silent> <F4> :call TerminalToggle(14)<CR>
tnoremap <silent> <F4> <C-\><C-n> :call TerminalToggle(14)<CR>
tnoremap <silent> <S-F4> <C-\><C-n>

"# Plugins config

"## Builtin
let g:python3_host_prog = '/usr/bin/python3'

" Use ripgrep by default
if executable('rg')
    set grepprg=rg\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

" Silent grep
command! -nargs=1 Grep execute 'silent grep ' . <q-args> 

" Add .tags to lookup path
" set tags=./tags;,tags

" Put cscope output in quickfix
" set cscopequickfix=s-,c-,d-,i-,t-,e-

"## gitgutter
let g:gitgutter_sign_added = '│'
let g:gitgutter_sign_modified = '│'
let g:gitgutter_sign_removed = '│'
let g:gitgutter_sign_modified_removed = '│'

"## fzf.vim
let g:fzf_layout = { 'down': '~30%' }

" TODO: vs code style menu
" let g:fzf_layout = { 'window': { 'width': 0.6, 'height': 0.8 } }

nnoremap <C-p> :Files<CR>
nnoremap <silent> <leader>r :History<CR>
nnoremap <silent> <leader><leader> :Buf<CR>
nnoremap <silent> <leader>f :Rg<CR>
nnoremap <silent> <leader>/ :BLines<CR>
nnoremap <silent> <leader>j :Tags<CR>
nnoremap <silent> <leader>u :BTags<CR>
nnoremap <silent> <leader>s :GFiles?<CR>
nnoremap <silent> <leader>c :Commits<CR>
nnoremap <silent> <Space> :Maps<CR>
nnoremap <silent> : :Commands<CR>
nnoremap q; :History:<CR>
nnoremap q/ :History/<CR>

autocmd! User FzfStatusLine setlocal statusline=%#NonText#

"## Tagbar
let g:tagbar_compact = 1
let g:tagbar_autoclose = 0

nnoremap <leader>[ :TagbarToggle<CR>

"## NERDTree
let g:NERDTreeMinimalUI = 1
let g:NERDTreeStatusline = '%#Visual# NERDTree %*'
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeCascadeSingleChildDir = 0
let g:NERDTreeHighlightFolders = 1
let g:NERDTreeHighlightFoldersFullName = 1

" Replace arrows with folders glyphs
let g:NERDTreeDirArrowExpandable = ' 🗀 '
let g:NERDTreeDirArrowCollapsible = ' 🗁 '

" Use `trash-cli` when deleting files and folders.
let g:NERDTreeRemoveDirCmd = 'trash '
let g:NERDTreeRemoveFileCmd = 'trash '

" Hide some files and folders.
let g:NERDTreeIgnore = [
    \ '^\.DS_Store$[[file]]',
    \ '^\.git$[[dir]]',
    \ '^node_modules$[[dir]]'
\ ]

augroup nerdtreeui
  autocmd!
  autocmd FileType nerdtree setlocal scl=no conceallevel=3 concealcursor=n
  autocmd FileType nerdtree syntax match NERDTreeHideCWD #^[</].*$# conceal
augroup end

" (old) Hide CWD line
" hi! link NERDTreeCWD Ignore

" Hide slashes after each directory node
hi! link NERDTreeDirSlash Ignore

" Change directory name color
hi! link NERDTreeDir Comment

" hi! link NERDTreeStatusLine Statusline

nnoremap <leader>e :NERDTreeToggle<CR>

"## NERDCommenter

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

nnoremap <silent> <C-/> :call nerdcommenter#Comment('n', 'Toggle')<CR>
vnoremap <silent> <C-/> :call nerdcommenter#Comment('x', 'Toggle')<CR>

"## deoplete
let g:deoplete#enable_at_startup = 1

inoremap <expr> <CR> (pumvisible() ? '<C-y>' : '<CR>')
inoremap <expr> <Tab> pumvisible() ? '<C-n>' : '<Tab>'
inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'

"## Language Client
" TODO compile_commands.json finder
let g:LanguageClient_serverCommands = {
    \ 'cpp': ['clangd', '-log=error', '--background-index'],
    \ 'c':   ['clangd', '-log=error', '--background-index'],
    \ }

nnoremap <silent> <leader>l :call LanguageClient_contextMenu()<CR>
nnoremap <silent> <leader>k :call LanguageClient#textDocument_hover()<CR>

" nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
" nnoremap <silent> gi :call LanguageClient#textDocument_implementation()<CR>
" nnoremap <silent> gt :call LanguageClient#textDocument_typeDefinition()<CR>
" nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
" nnoremap <silent> <leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>
" nnoremap <silent> <leader>la :call LanguageClient#textDocument_codeAction()<CR>
" nnoremap <silent> <leader>lf :call LanguageClient#textDocument_formatting()<CR>
" nnoremap <silent> <leader>ln :call LanguageClient#textDocument_rename()<CR>
" nnoremap <silent> <leader>lh :call LanguageClient#textDocument_signatureHelp()<CR>
" nnoremap <silent> <leader>le :call LanguageClient#explainErrorAtPoint()<CR>
" nnoremap <silent> ]e :call LanguageClient#diagnosticsNext()<CR>
" nnoremap <silent> [e :call LanguageClient#diagnosticsPrevious()<CR>

augroup lsp_nvim
    autocmd!
    autocmd CursorHold * call LanguageClient#textDocument_hover()
augroup end

"## syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" let g:syntastic_python_checkers = ['mypy']
