nnoremap <leader>vtc :VimtexClean<CR>
nnoremap <leader>toc :VimtexTocToggle<cr>

let g:vimtex_quickfix_open_on_warning = 1
let g:vimtex_log_ignore=['hbox', 'overfull', 'Overfull', 'underfull', 'Underfull']
let g:vimtex_quickfix_latexlog = {
            \ 'overfull'  : 0 ,
            \ 'Overfull'  : 0 ,
            \ 'underfull' : 0,
            \ 'Underfull' : 0,
            \}
" Necessary if noexpandtab is set
" let g:vimtex_indent_on_ampersand=0
let g:tex_conceal=''

let g:tex_flavor = "latex"
