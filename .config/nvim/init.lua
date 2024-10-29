if vim.fn.exists('$WSL_DISTRO_NAME') == 1 then
     vim.g.clipboard = {
       name = 'WslClipboard',
       copy = {
	 ['+'] = 'clip.exe',
	 ['*'] = 'clip.exe',
       },
       paste = {
	 ['+'] = 'powershell.exe -c Get-Clipboard',
	 ['*'] = 'powershell.exe -c Get-Clipboard',
       },
       cache_enabled = 0,
     }
end

vim.cmd('source ~/.config/nvim/init.nvim')
