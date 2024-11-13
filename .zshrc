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
autoload -U add-zsh-hook
add-zsh-hook chpwd python_venv
python_venv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
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
