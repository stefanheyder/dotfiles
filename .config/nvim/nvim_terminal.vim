let mapleader = ","
let maplocalleader = ","
let g:mapleader = ","


" vim-Plugged {{{
call plug#begin('/Users/stefan/.vim/plugged')
" styling plugins
Plug 'rafi/awesome-vim-colorschemes'
"Plug 'crusoexia/vim-monokai'
"Plug 'morhetz/gruvbox'
"Plug 'tomasr/molokai'
"Plug 'altercation/vim-colors-solarized'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"Plug 'dylanaraps/wal.vim'
Plug 'NoahTheDuke/vim-just'

Plug 'plasticboy/vim-markdown'

"Plug 'lervag/vimtex'
"Plug 'brennier/quicktex'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
"
Plug 'justinmk/vim-sneak'

"Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
"Plug 'tpope/vim-commentary'
"Plug 'tpope/vim-unimpaired'
"Plug 'tpope/tpope-vim-abolish'
"Plug 'tpope/vim-projectionist'


" Tmux navigation
Plug 'ervandew/screen'
Plug 'christoomey/vim-tmux-navigator'

"Plug 'kkoomen/vim-doge'

Plug 'edkolev/tmuxline.vim'

Plug 'vim-pandoc/vim-pandoc-syntax'


Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'fannheyward/telescope-coc.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'alexaandru/nvim-lspupdate'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'edluffy/specs.nvim'
call plug#end()   
" }}}


filetype plugin indent on
syntax on

set shellslash

" Sets how many lines of history VIM has to remember
set history=700

" Set to auto read when a file is changed from the outside
set autoread

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Set linenumbers 
" set nu

" Split behavior 
set splitbelow
set splitright


" Turn on the WiLd menu
set wildignore=*.o,*~,*.pyc,*.aux,*.pdf,*.synctex
set wildmode=longest,list,full
set wildmenu

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Search Options
set ignorecase
set smartcase
set hlsearch
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic
"
" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf-8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Tabs and spaces settings
set smarttab
set preserveindent
set softtabstop=0
set shiftwidth=4
set tabstop=4
set expandtab
set listchars=tab:▸\ ,eol:¬
set autoindent 
set smartindent
set wrap 
set lbr

" Specify the behavior when switching between buffers 
try
    set switchbuf=useopen,usetab,newtab
    set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

autocmd BufRead *.tex setlocal spell spelllang=de_de,en_us
autocmd BufRead *.Rnw setlocal spell spelllang=de_de,en_us
autocmd BufRead *.aliases setlocal ft=zsh
autocmd BufRead *.Rnw nmap <leader>ft :set<space>ft=tex<cr>
autocmd BufRead *.Rnw nmap <leader>fr :set<space>ft=rnoweb<cr>
" Remember info about open buffers on close
set viminfo^=%

" Always show the status line
set laststatus=2
" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l
" FUNCTIONS {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" VIM Latex Grep
set grepprg=grep\ -nH\ $*

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! SmoothScroll(up)
    if a:up
        let scrollaction="^Y"
    else
        let scrollaction="^E"
    endif
    exec "normal " . scrollaction
    redraw
    let counter=1
    while counter<&scroll
        let counter+=1
        sleep 10m
        redraw
        exec "normal " . scrollaction
    endwhile
endfunction
" MAPPINGS {{{1
"

" Fast saving
nmap <leader>w :w!<cr>

" Diff Leader commandes
nnoremap <leader>nf ]c
nnoremap <leader>pf [c
nnoremap <leader>dg :diffg<cr>
nnoremap <leader>dp :diffpu<cr>
vnoremap <leader>dg :diffg<cr>
vnoremap <leader>dp :diffpu<cr>

" disable highlights
map <silent> <leader>, :noh<cr>

" Close the current buffer
map <leader>bd :Bclose<cr>

" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **<left><left><left><left>

" display grep results
nnoremap <leader>cc :botright cope<cr>

" Spell Checking
map <leader>sen :setlocal spell spelllang=en_us<cr>
map <leader>sde :setlocal spell spelllang=de_de<cr>
let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'

" next/previous error
map <leader>sn ]s
map <leader>sp [s

" add / remove word under cursor
map <leader>sa zg
map <leader>sd z=

" find suggestions
map <leader>sf 1z=

" Fast access to System Clipboard
vmap <Leader>y "+y
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" NAVIGATION {{{2

" Buffers
"nnoremap <leader>bb :b#<CR>

" next/previous cope item
nnoremap <leader>n :cn<cr>
nnoremap <leader>pr :cp<cr>

" next/previous list item
nnoremap <leader>ln :lnext<cr>
nnoremap <leader>lp :lprevious<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

tmap <C-j> <C-W>j
tmap <C-k> <C-W>k
tmap <C-h> <C-W>h


" Remap VIM 0 to first non-blank character
map 0 ^

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" reload vimrc
nnoremap <leader>rr :so ~/.vimrc<CR>
nnoremap <leader>erc :e ~/.vimrc<CR>
nnoremap <leader>vrc :vsp ~/.vimrc<CR>
nnoremap <leader>src :sp ~/.vimrc<CR>

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Add new line without entering insert mode
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>
vmap <leader>rv *N:%s/<C-R>///g<left><left>
nnoremap <leader>rw *N:%s/<C-R>///g<left><left>

" Fast Normal Mode
inoremap jj <ESC>
inoremap kk <ESC>
inoremap jk <ESC>
inoremap jJ <ESC>
" GUI STUFF {{{1

" Enable syntax highlighting


" Set extra options when running in GUI mode
if has("gui_running")
	colorscheme solarized
	set guifont=Bitstream\ Vera\ Sans\ Mono\ 11
	set background=dark
    set guioptions-=T
    set guioptions-=m
    set t_Co=256
    set guitablabel=%M\ %t
else
    "colo seoul256
	"colorscheme gruvbox
    colorscheme wal
    "set termguicolors
    set colorcolumn=80
	set background=dark
    set t_Co=256
	hi MatchParen cterm=underline,bold ctermbg=none ctermfg=none
endif
"}}}
" block cursor
"let &t_ti.="\e[1 q"
"let &t_SI.="\e[5 q"
"let &t_EI.="\e[1 q"
"let &t_te.="\e[0 q"


" Highlight tabs
set list
set listchars=tab:▸\ ,

nnoremap <leader>cd :cd<space>%:p:h<cr>

set nofoldenable

function! CurrentDate()
    r !date +'\%Y-\%m-\%d'
endfunction

nnoremap <leader>mkx :!<space>chmod<space>+x<space>%<CR><CR>

command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
            \ | diffthis | wincmd p | diffthis

nnoremap <leader>rnw :e%:r.Rnw<CR>
nnoremap <leader>tex :e%:r.tex<CR>
nnoremap <leader>ss :%s/ß/\\ss{}/g<CR>


hi clear SpellBad
hi SpellBad cterm=underline

autocmd FileType qf 5wincmd_

set fillchars+=vert:\│
hi VertSplit ctermfg=Black ctermbg=DarkGray

nnoremap <C-t>K :tabr<cr>
nnoremap <C-t>J :tabl<cr>
noremap <C-t>H :tabp<cr>
noremap <C-t>L :tabn<cr>

nnoremap <leader>b :buffer *
nnoremap <leader>mm :mak<CR>

set completeopt=noinsert

tnoremap <Esc> <C-\><C-n>
autocmd FileType r setlocal formatoptions+=r
autocmd FileType r setlocal colorcolumn=120
autocmd FileType Rnw setlocal colorcolumn=120
autocmd FileType python setlocal colorcolumn=120

set mouse=n
map gf :e <cfile><CR>

" Plugin specific configurations
"
" rafi/awesome-vim-colorschemes
" altercation/vim-colors-solarized
" vim-airline/vim-airline
source ~/.config/nvim/airline.vim
" dylanaraps/wal.vim
" plasticboy/vim-markdown
" lervag/vimtex
source ~/.config/nvim/vimtex.vim
" junegunn/fzf
" junegunn/fzf.vim
source ~/.config/nvim/fzf.vim
" tpope/vim-repeat
" tpope/vim-surround
" ervandew/screen
" christoomey/vim-tmux-navigator
" jalvesaq/R-Vim-runtime
" jalvesaq/Nvim-R
source ~/.config/nvim/nvim_R.vim
" jalvesaq/vimcmdline
" kkoomen/vim-doge
" SirVer/ultisnips
source ~/.config/nvim/ultisnip.vim
" edkolev/tmuxline.vim
" kovetskiy/sxhkd-vim
" vim-pandoc/vim-pandoc-syntax
" mboughaba/i3config.vim
" editorconfig/editorconfig-vim
" neoclide/coc.nvim
source ~/.config/nvim/coc_nvim.vim
source ~/.config/nvim/telescope_nvim.vim
"source ~/.config/nvim/treesitter.vim
" hkupty/iron.nvim 
" source ~/.config/nvim/init.vim
 source ~/.config/nvim/specs.nvim.vim
set conceallevel=0

lua << EOF
require'lspconfig'.r_language_server.setup{}
EOF
