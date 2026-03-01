" Requires Vim 8.1+, vim-plug, node, and The Silver Searcher
"
" brew install the_silver_searcher

" Plugin Manager
" vim-plug config. Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'

" Install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" File System Sidebar
Plug 'scrooloose/nerdtree'
" Dark color scheme
Plug 'joshdick/onedark.vim'
" Ctrl-p file fuzzy search
Plug 'kien/ctrlp.vim'
" Lean status bar
Plug 'vim-airline/vim-airline'
" Shows symbols for git diffs in the gutter (where the line numbers are)
Plug 'airblade/vim-gitgutter'
" Intuitive commands for quoting/parenthesizing/surrounding some word/text
Plug 'tpope/vim-surround'
" Syntax highlighting for like all languages
Plug 'pangloss/vim-javascript'
" Typescript
Plug 'leafgarland/typescript-vim'
" React jsx/tsx indentation
Plug 'maxmellon/vim-jsx-pretty'
" Add brackets, parens, quotes in pairs
Plug 'jiangmiao/auto-pairs'
" use gcc to comment out a line, or gc to comment out a block
Plug 'tpope/vim-commentary'
" Automatically adds the 'end' keyword in ruby files
Plug 'tpope/vim-endwise'
" Vim git plugin
Plug 'tpope/vim-fugitive'

" Language Server (Intellisense) Engine
" Need to install language servers if on a new machine. For example - :CocInstall coc-pyright coc-tsserver coc-json coc-html coc-css coc-eslint coc-prettier
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Plugin system end
call plug#end()

filetype plugin indent on

" ======================================
" = Environment Specific Configuration =
" ======================================

" Change cursor shape between insert and normal mode in iTerm2.app
if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif

" ======================================
" ======= User Interface/Style  ========
" ======================================

" Basic Setup - colors, tabs, line numbers
syntax on
set redrawtime=10000
set t_Co=256
set t_ut=
colorscheme onedark
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set number
set relativenumber
set linebreak

" Show whitespace characters
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set list

" Make the active split more obvious by making the status bar lighter
hi StatusLine   ctermfg=15  guifg=#ffffff ctermbg=239 guibg=#4e4e4e cterm=bold gui=bold

" Search config, highlighting, show match as I'm typing
set showmatch
set incsearch
set hlsearch

" ======================================
" ==== Quality of Life/Ease of Use =====
" ======================================

" Automatically enters NERDTree on vim command
autocmd vimenter * NERDTree

" autosave
set autowriteall

" Autosave on insert mode exit
autocmd InsertLeave * write

" Spell check on markdown files
autocmd FileType markdown setlocal spell spelllang=en_us

" Make backspace work as intended
set backspace=indent,eol,start

" Config for new splits opening to the right and bottom
set splitright
set splitbelow

" Opens buffers from quickfix in a new tab by default or switches to the
" existing tab if it is already open
set switchbuf+=usetab,newtab

" Ignore node_modules in file searches
set wildignore+=**/node_modules/**
set wildmenu

" Turn off auto-indent when pasting in insert mode
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

" Quality of life improvement for copy pasting
" https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" ======================================
" ==== Custom Commands and Hotkeys =====
" ======================================

" Ctrl hjkl to move between splits
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Ctrl-C copies selection to the system clipboard
vnoremap <C-c> :w !pbcopy<CR><CR>

" ======================================
" ========= Plugin Enhancements ========
" ======================================

" ===== CoC.nvim Config =====
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" For coc-prettier, enables :Prettier command and <leader>f command
command! -nargs=0 Prettier :CocCommand prettier.formatFile
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Faster buffer update time, for gitgutter, coc.nvim, but affects the whole
" environment
set updatetime=300

" The Silver Searcher
if executable('ag')
    " Use ag over grep, ignore node_modules, dist and build folders when
    " searching
    set grepprg=ag\ --nogroup\ --nocolor\ --ignore={'*node_modules*','*dist*','*build*'}

    " Bind K to grep word under cursor (only works w/ TSS)
    nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

    " Enable Search command to search project for string
    command -nargs=+ -complete=file -bar Search silent! grep! <args>|cwindow|redraw!

    " Use ag in CtrlP for listing files
    " let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesnt need to cache. Also not caching
    " allows you to find newly created files without restarting vim
    let g:ctrlp_use_caching = 0

    " Configure ctrlp to only search under vim's current working directory
    " Useful for monorepos
    " let g:ctrlp_working_path_mode = ''
endif

" ignore node_modules and other files when using ctrl-p
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|\.git$\'

" Bind F to :NERDTreeFind which finds the current file in the tree.
nnoremap F :NERDTreeFind<CR>

" ======================================
" ========Javascript Specific ==========
" ======================================

" Filetype detection for jsx/tsx
augroup JsxTsxSyntaxSettings
  autocmd!
  autocmd BufNewFile,BufRead *.tsx set filetype=typescriptreact
  autocmd BufNewFile,BufRead *.jsx set filetype=javascriptreact
augroup END

" for jsx linting to be enabled in regular .js files
let g:jsx_ext_required = 0

" gf command (go to file) working for node_modules ES6 imports
" Works as a fallback, so at worst in other languages gf returns 'file not found'.
set path=.,src,$PWD/**,node_modules
set suffixesadd=.js,.jsx,.tsx
" allows @ to be recognized as a character
set isfname+=@-@
function! LoadMainNodeModule(fname)
    let nodeModules = "./node_modules/"
    let packageJsonPath = nodeModules . a:fname . "/package.json"

    if filereadable(packageJsonPath)
        return nodeModules . a:fname . "/" . json_decode(join(readfile(packageJsonPath))).main
    else
        return nodeModules . a:fname
    endif
endfunction
set includeexpr=LoadMainNodeModule(v:fname)

" Enable Enter to select autocompletion
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
