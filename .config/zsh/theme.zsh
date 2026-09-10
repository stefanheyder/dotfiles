# Gruvbox dark (medium) for the terminal itself.
#
# nvim paints its own buffers via ellisonleao/gruvbox.nvim (see
# .config/nvim/lua/plugins.lua). Everything else -- the prompt, ls, fzf, git
# diffs, tmux -- only ever asks for "ANSI colour 3" and gets whatever the
# terminal happens to think yellow is. This repaints those 16 slots, plus
# foreground, background and cursor, so the whole terminal agrees with nvim.
#
# Done with OSC escapes rather than a per-emulator config file: one palette
# covers iTerm2, WSL, a Linux box and anything on the far end of an ssh
# session, with no import step and nothing to keep in sync.

# Only paint a real interactive terminal. The tty check also keeps the escapes
# out of pipes -- bin/test-shell.sh runs `zsh -il` with stdout redirected, and
# would otherwise count these bytes as output.
[[ -o interactive ]] || return 0
[[ -t 1 ]]           || return 0

# Skipped inside tmux on purpose: tmux does not forward OSC 4 to the outer
# terminal, and does not need to -- the shell that started tmux already
# painted it. .tmux.conf styles tmux's own chrome to the same palette.
[[ -z $TMUX ]] || return 0

# Terminals with no palette to set, or none we can address.
case $TERM in (dumb|linux|''|cons25|vt*) return 0 ;; esac

# 0-7 normal, 8-15 bright. bg0 as black, fg4 as white, fg1 as bright white --
# gruvbox's own terminal mapping, so `set termguicolors` off still looks right.
() {
  local -a p=(
    282828 cc241d 98971a d79921 458588 b16286 689d6a a89984
    928374 fb4934 b8bb26 fabd2f 83a598 d3869b 8ec07c ebdbb2
  )
  local i
  for i in {1..16}; do
    printf '\e]4;%d;#%s\a' $(( i - 1 )) $p[i]
  done
  printf '\e]10;#ebdbb2\a'  # foreground -> fg1
  printf '\e]11;#282828\a'  # background -> bg0
  printf '\e]12;#ebdbb2\a'  # cursor     -> fg1
}
