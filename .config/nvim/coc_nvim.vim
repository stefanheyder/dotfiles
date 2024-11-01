let coc_data_home = '~/.cache/coc'

" "g" (go to or show)
nmap gd <Plug>(coc-definition)
nmap gD <Plug>(coc-declaration)
nmap ge <Plug>(coc-diagnostic-next)
nmap gE <Plug>(coc-diagnostic-next)
nmap gr <Plug>(coc-references)
nmap gh <Plug>(coc-action-doHover)
nmap gi <Plug>(coc-diagnostic-info)

" Coc configuration is json + comments
autocmd FileType json syntax match Comment +\/\/.\+$+

" Use <Tab> for trigger snippet expand.
imap <Tab> <Plug>(coc-snippets-expand)

" Use <Tab> for select text for visual placeholder of snippet.
vmap <Tab> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<C-b>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<C-B>'

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)
