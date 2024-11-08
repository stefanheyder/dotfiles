let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if exists('g:vscode')
	let mapleader=","
	let leader=","
	nmap k gk
	nmap j gj
	nmap <leader>rh <Cmd>call VSCodeNotify('r.helpPanel.openForSelection')<CR>
	nmap <C-j> <Cmd>call VSCodeNotify('notebook.focusNextEditor')<CR>

	nnoremap <C-l> <Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>
	nnoremap <C-h> <Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
	
	set clipboard=unnamedplus
	call plug#begin('/Users/stefan/.vim/plugged')

	Plug 'tpope/vim-surround'
	Plug 'justinmk/vim-sneak'
	"Plug 'lervag/vimtex'

	call plug#end()
	finish "VSCode"
endif

" Mappings
inoremap jj <ESC>
"source "~/.config/nvim/nvim_terminal.vim"
source "~/.config/nvim/mappings.vim"
source "~/.config/nvim/standard_settings.vim"



" Plugins
call plug#begin('/Users/stefan/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'justinmk/vim-sneak'
Plug 'lervag/vimtex'

call plug#end()


