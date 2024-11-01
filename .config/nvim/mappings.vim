" Fast saving
nmap <leader>w :w!<cr>

" disable highlights
map <silent> <leader>, :noh<cr>

" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **<left><left><left><left>

" Fast access to System Clipboard
vmap <Leader>y "+y
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

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

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Fast Normal Mode
inoremap jj <ESC>
inoremap kk <ESC>
inoremap jk <ESC>
inoremap jJ <ESC>


" switch to current directory
nnoremap <leader>cd :cd<space>%:p:h<cr>

" create file under cursor with gf if it does not exist
map gf :e <cfile><CR>
