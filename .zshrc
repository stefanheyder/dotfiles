# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh not found. Installing..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git fzf)
source $ZSH/oh-my-zsh.sh

# starship
eval "$(starship init zsh)"

# automatically activate venvs
python_venv() {
  MYVENV=./venv
  # when you cd into a folder that contains $MYVENV
  [[ -d $MYVENV ]] && source $MYVENV/bin/activate > /dev/null 2>&1
  # when you cd into a folder that doesn't
  [[ ! -d $MYVENV ]] && deactivate > /dev/null 2>&1
}

# zinit plugins
#zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit load starship/starship
zinit light zsh-users/zsh-syntax-highlighting
zinit light ianthehenry/sd
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light unixorn/fzf-zsh-plugin

autoload -Uz compinit
compinit -C

# starship
eval "$(starship init zsh)"

# fzf
source <(fzf --zsh)

# platform dependent configurations
case "$(uname -s)" in
  Darwin*) source ~/.config/zsh/macos.zsh ;;
  Linux*)
    if [[ -n "$WSL_DISTRO_NAME" ]]; then
      source ~/.config/zsh/wsl.zsh
    else
      source ~/.config/zsh/linux.zsh
    fi
    ;;
esac

# fix starship initial blank line
# see https://www.reddit.com/r/commandline/comments/13r2ou3/comment/kvtv6lw/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
precmd() {
  if [ ! -z "$BUFFER" ]; then
    precmd() {
      precmd() {
        echo
      }
    }
  fi
}

# aliases
alias w="cd ~/workspace"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

case "$OSTYPE" in
  darwin*)
    # ...
  ;;
  linux*)
    # ...
  ;;
esac
