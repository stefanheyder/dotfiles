# Setup

```bash
git init --bare $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfile/ --work-tree=$HOME'
config config status.showUntrackedFiles no
```

# Installation

```bash
git clone --separate-git-dir=~/.dotfiles https://github.com/stefanheyder/dotfiles.git ~
```

# Further reading

- [This HN article](https://news.ycombinator.com/item?id=11070797)
- [This atlassian blog post](https://www.atlassian.com/git/tutorials/dotfiles)
