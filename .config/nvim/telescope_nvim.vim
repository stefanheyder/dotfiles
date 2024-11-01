" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <leader>tt <cmd>Telescope<cr>
nnoremap <C-P> <cmd>Telescope find_files<cr>
nnoremap <C-B> <cmd>Telescope buffers<cr>

lua <<EOF
require('telescope').load_extension('coc')
EOF
