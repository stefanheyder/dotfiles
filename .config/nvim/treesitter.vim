lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disbale = {"latex", "tex"}
  },
  indent = {
    enable = true
  },
  incremental_selection = {
      enable = true
  }
}
EOF
