" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="context"

let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']

nnoremap <leader>ue :UltiSnipsEdit<CR>
nnoremap <leader>ueb :UltiSnipsEdit!<CR>
nnoremap <leader>urs :call UltiSnips#RefreshSnippets()<CR>
