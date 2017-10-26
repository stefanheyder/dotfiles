
let mapleader = ","
let maplocalleader = ","
let g:mapleader = ","

call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'tomasr/molokai'
Plug 'altercation/vim-colors-solarized'


Plug 'plasticboy/vim-markdown'

Plug 'lervag/vimtex'
Plug 'brennier/quicktex'

Plug 'justinmk/vim-sneak'
Plug 'vimwiki/vimwiki'
Plug 'ctrlpvim/ctrlp.vim'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/tpope-vim-abolish'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'ervandew/screen'
Plug 'christoomey/vim-tmux-navigator'

Plug 'jalvesaq/Nvim-R'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

call plug#end()   
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
set nu

" Split behavior 
set splitbelow
set splitright

" Vertical Split Buffer Mapping
command! -nargs=1 Vbuffer call VerticalSplitBuffer(<f-args>)

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
set tw=500

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

autocmd BufRead *.aliases setlocal ft=zsh
" Remember info about open buffers on close
set viminfo^=%

" Always show the status line
set laststatus=2
" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l
" FUNCTIONS {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

" Vertical Split Buffer Function
function! VerticalSplitBuffer(buffer)
    execute "vert belowright sb" a:buffer 
endfunction

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
map <silent> <leader>ss :setlocal spell!<cr>
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
map <leader>f 1z=

" Fast access to System Clipboard
vmap <Leader>y "+y
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" NAVIGATION {{{2

" Buffers
nnoremap <leader>bb :b#<CR>

" Jump to as t
nmap ü ]
nmap Ü [

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

" Remap VIM 0 to first non-blank character
map 0 ^

" PLUGINS {{{2
" CTRLP {{{3
let g:ctrlp_map = '<C-p>'

" NERDTree {{{3
map <C-n> :NERDTreeToggle<CR>
" }}}

" YouCompleteMe {{{
nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>st :YcmCompleter GetType<CR>
let g:ycm_register_as_syntastic_checker = 0
" }}}

" Syntastic {{{3
nnoremap <leader>sc :SyntasticCheck<cr>
" }}}

" }}}

" searching
map <space> /

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" reload vimrc
nnoremap <leader>rr :so $MYVIMRC<CR>

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
	colorscheme gruvbox
	set background=dark
    set t_Co=256
	set guifont=Hack
	hi MatchParen cterm=bold ctermbg=none ctermfg=magenta
endif
"}}}
" block cursor
"let &t_ti.="\e[1 q"
"let &t_SI.="\e[5 q"
"let &t_EI.="\e[1 q"
"let &t_te.="\e[0 q"

set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:ScreenImpl = 'Tmux'
let vimrplugin_screenvsplit = 1 " For vertical tmux split
let g:ScreenShellInitialFocus = 'shell' 
" instruct to use your own .screenrc file
let g:vimrplugin_noscreenrc = 1
" For integration of r-plugin with screen.vim
let g:vimrplugin_screenplugin = 1
" Don't use conque shell if installed
let vimrplugin_conqueplugin = 0
" map the letter 'r' to send visually selected lines to R 
let g:vimrplugin_map_r = 1
" see R documentation in a Vim buffer
let vimrplugin_vimpager = "no"

func! JSONBeautify() 
	%! python -m json.tool
endfunc

autocmd BufRead *.igxc :call JSONBeautify()
nnoremap <leader>jb :call<space>JSONBeautify()<cr>

" Highlight tabs
set list
set listchars=tab:▸\ ,

source ~/.quicktexrc
let g:vimtex_quickfix_open_on_warning = 0

call vimtex#imaps#add_map({
  \ 'lhs' : '<m-i>',
  \ 'rhs' : '\item ',
  \ 'leader' : '',
  \ 'wrapper' : 'vimtex#imaps#wrap_environment',
  \ 'context' : ["itemize", "enumerate"],
  \})
" Necessary if noexpandtab is set
" let g:vimtex_indent_on_ampersand=0

nnoremap <leader>toc :VimtexTocToggle<cr>

nnoremap <leader>cd :cd<space>%:p:h<cr>

set nofoldenable

" vimwiki/vimwiki
let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
function! CreateHourlyTopics()
	normal! G
	r !date +'= \%H:\%Mh =\%n'
endfunction

command! CreateHourlyTopics call CreateHourlyTopics()

let g:R_tmux_split = 1
let g:R_indent_commented = 0
let g:R_indent_align_args = 0

let r_indent_ess_comments = 0
let g:R_indent_ess_compatible = 0
let r_indent_align_args = 0
let r_indent_ess_compatible = 0

set colorcolumn=80

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

