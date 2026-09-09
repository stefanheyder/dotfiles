-- Neovim config, text-manipulation first: shell and config files, git commit
-- messages, prose. No LSP, no completion engine, no treesitter -- nvim 0.11
-- already ships `gc` commenting, `[q`/`]q`, `[d`/`]d` and fuzzy `:find`, and
-- language tooling can be added later in three lines with `vim.lsp.enable`.
--
--   init.lua         this file: leader, options, keymaps, autocmds
--   lua/plugins.lua  plugin specs, loaded by lazy.nvim
--   lazy-lock.json   pinned plugin revisions; refresh with `:Lazy sync`
--
-- Note on the predecessor: this replaces a 21-file tree in which the two
-- `source "..."` lines were silently no-ops (a double quote starts a Vimscript
-- comment), so no option or mapping in it had applied since Feb 2025. Lua's
-- `require` fails loudly, which is most of why this file looks like this.

-- Leader first: lazy.nvim binds its own keymaps against it during setup.
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- ── lazy.nvim bootstrap ──────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nclone it by hand into " .. lazypath },
    }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  install = { colorscheme = { "gruvbox" } },
  change_detection = { notify = false },
})

-- ── options ──────────────────────────────────────────────────────────────
local o = vim.opt

o.scrolloff = 7
o.splitbelow = true
o.splitright = true
o.cmdheight = 2
o.showmatch = true
o.matchtime = 2
o.mouse = "n"
o.conceallevel = 0
o.foldenable = false
o.errorbells = false
o.visualbell = false
o.switchbuf = "useopen,usetab,newtab"
o.whichwrap:append("<,>,h,l")

-- searching
o.ignorecase = true
o.smartcase = true

-- completion and command line: fuzzy matching is built in as of 0.11
o.completeopt = "fuzzy,menuone,noselect"
o.wildoptions = "fuzzy,pum,tagfile"
o.wildmode = "longest,list,full"
o.wildignore = "*.o,*~,*.pyc,*.aux,*.pdf,*.synctex"

-- indentation: four spaces
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 0
o.smarttab = true
o.preserveindent = true
o.autoindent = true

-- wrapping: soft, and indent-aware so wrapped prose lines up
o.wrap = true
o.linebreak = true
o.breakindent = true
o.listchars = { tab = "▸ ", eol = "¬" }

-- no backup files, but do keep undo history across sessions
o.backup = false
o.writebackup = false
o.swapfile = false
o.undofile = true

-- ripgrep for :grep (installed; falls back loudly if it ever is not)
o.grepprg = "rg --vimgrep"
o.grepformat = "%f:%l:%c:%m"

o.termguicolors = true
o.fileformats = "unix,dos,mac"

-- ── keymaps ──────────────────────────────────────────────────────────────
local map = vim.keymap.set

-- back to normal mode. `kk` is deliberately absent: it eats words like
-- "bookkeeper", and `jJ` was noise.
map("i", "jj", "<Esc>", { desc = "normal mode" })
map("i", "jk", "<Esc>", { desc = "normal mode" })

map("n", "<leader>w", "<cmd>w!<cr>", { desc = "write" })
map({ "n", "v" }, "<leader>,", "<cmd>noh<cr>", { silent = true, desc = "clear search highlight" })

-- system clipboard, explicitly. `clipboard` is left unset on purpose so the
-- unnamed register stays local and a plain `y` does not reach the pasteboard.
map("v", "<leader>y", '"+y', { desc = "yank to clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "paste from clipboard" })
map({ "n", "v" }, "<leader>P", '"+P', { desc = "paste before from clipboard" })

-- move by display line and to first non-blank -- normal and visual only.
-- Mapping these in operator-pending mode (the old config used bare `map`)
-- turns `dj` charwise and `d0` into `d^`.
map({ "n", "x" }, "j", "gj", { desc = "down one display line" })
map({ "n", "x" }, "k", "gk", { desc = "up one display line" })
map({ "n", "x" }, "0", "^", { desc = "first non-blank character" })

-- search for the visual selection, replacing the old VisualSelection()
-- function. Restores the unnamed register, which that one clobbered.
local function search_selection(backwards)
  return function()
    local saved = vim.fn.getreg('"')
    vim.cmd("normal! gvy")
    local pattern = vim.fn.escape(vim.fn.getreg('"'), [[\/?]]):gsub("\n$", "")
    vim.fn.setreg('"', saved)
    vim.fn.setreg("/", "\\V" .. pattern)
    vim.o.hlsearch = true
    vim.cmd("normal! " .. (backwards and "N" or "n"))
  end
end
map("x", "*", search_selection(false), { desc = "search selection forward" })
map("x", "#", search_selection(true), { desc = "search selection backward" })

-- spelling. `]s`/`[s` and `zg`/`z=` are built in; these are the language
-- switchers. `<leader>sd` is deliberately unused: it shadowed `<leader>sde`.
map("n", "<leader>sen", "<cmd>setlocal spell spelllang=en_us<cr>", { desc = "spell: english" })
map("n", "<leader>sde", "<cmd>setlocal spell spelllang=de_de<cr>", { desc = "spell: german" })
map("n", "<leader>sa", "zg", { desc = "spell: add word" })
map("n", "<leader>ss", "z=", { desc = "spell: suggest" })
map("n", "<leader>sf", "1z=", { desc = "spell: take first suggestion" })

map({ "n", "v" }, "<leader>dg", "<cmd>diffget<cr>", { desc = "diff get" })
map({ "n", "v" }, "<leader>dp", "<cmd>diffput<cr>", { desc = "diff put" })

map("n", "<leader>cd", "<cmd>cd %:p:h<cr>", { desc = "cd to this file's directory" })
map("n", "<leader>mkx", "<cmd>!chmod +x %<cr>", { desc = "chmod +x this file" })
map("n", "<leader>erc", "<cmd>e $MYVIMRC<cr>", { desc = "edit this config" })
map("n", "gf", ":e <cfile><cr>", { desc = "open file under cursor, creating it" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "leave terminal mode" })

-- vimgrep sugar, kept from the old config; <leader>fg is usually better
map("n", "<leader>g", ":vimgrep // **<left><left><left><left>", { desc = "vimgrep" })

-- tabs
map("n", "<C-t>H", "<cmd>tabprevious<cr>", { desc = "previous tab" })
map("n", "<C-t>L", "<cmd>tabnext<cr>", { desc = "next tab" })
map("n", "<C-t>J", "<cmd>tablast<cr>", { desc = "last tab" })
map("n", "<C-t>K", "<cmd>tabrewind<cr>", { desc = "first tab" })

-- ── autocmds ─────────────────────────────────────────────────────────────
local function augroup(name)
  return vim.api.nvim_create_augroup("stefan_" .. name, { clear = true })
end

-- reopen a file where you left it
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_position"),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- prose buffers: spelling in both working languages, soft wrap
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("prose"),
  pattern = { "markdown", "gitcommit", "text" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "de", "en" }
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

-- brief highlight on yank, so you can see what a motion actually took
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("yank_highlight"),
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})
