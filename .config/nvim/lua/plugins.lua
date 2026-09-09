-- Plugin specs for lazy.nvim. Seven entries, deliberately few: this config is
-- for moving text around, not for programming. Nothing here needs a compiler,
-- a language server or a node runtime.
--
-- `lazy = false` throughout: plugin loading cannot be tested in the offline
-- sandbox this config is authored in, so predictable eager loading beats a
-- lazy-loading scheme nobody has watched work. Revisit if startup ever
-- becomes noticeable (`:Lazy profile`).

return {
  -- Colours. Loaded first and at high priority so no other plugin paints
  -- itself in the default scheme before gruvbox lands.
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      terminal_colors = true,
      contrast = "",       -- "hard" | "soft" | "" (medium)
      italic = { strings = false, comments = true },
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.o.background = "dark"
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- ys/cs/ds to add, change and delete surroundings, and `.` to repeat them.
  -- vim-repeat is what makes that repeat work; the previous config had
  -- dropped it, so `.` after `cs"'` had been silently broken.
  { "tpope/vim-surround", lazy = false, dependencies = { "tpope/vim-repeat" } },

  -- s/S: two-character jump-anywhere motion.
  { "justinmk/vim-sneak", lazy = false },

  -- <C-h/j/k/l> moves between nvim splits and tmux panes with one set of
  -- keys. The tmux half of this lives in .tmux.conf; the plugin's own
  -- mappings intentionally win over anything set here.
  { "christoomey/vim-tmux-navigator", lazy = false },

  -- File switching. <C-p> is a frecency-weighted blend of open buffers,
  -- recently used files and project files -- it surfaces the file you meant
  -- before you finish typing. Only snacks' picker module is enabled.
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 900,
    opts = {
      picker = { enabled = true },
    },
    keys = {
      { "<C-p>",      function() Snacks.picker.smart() end,     desc = "find file (smart)" },
      { "<C-b>",      function() Snacks.picker.buffers() end,   desc = "buffers" },
      { "<leader>ff", function() Snacks.picker.files() end,     desc = "find files" },
      { "<leader>fg", function() Snacks.picker.grep() end,      desc = "grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end,   desc = "buffers" },
      { "<leader>fh", function() Snacks.picker.help() end,      desc = "help tags" },
      { "<leader>fr", function() Snacks.picker.resume() end,    desc = "resume last picker" },
    },
  },
}
