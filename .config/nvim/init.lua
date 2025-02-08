-- Function to determine the operating system
local function is_mac()
  return vim.fn.has('macunix') == 1
end

local function is_wsl()
  return vim.fn.has('wsl') == 1
end

vim.cmd('source ~/.config/nvim/_init.vim')

