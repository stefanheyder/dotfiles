# Setup

```bash
git init --bare $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfile/ --work-tree=$HOME'
dotfiles config status.showUntrackedFiles no
```

# Installation

```bash
git clone --bare https://github.com/stefanheyder/dotfiles.git $HOME/.dotfiles
```

Add  the following alias to your shells' configuration:
```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

and run 
```bash
dotfiles config status.showUntrackedFiles no
```

# Further reading

- [This HN article](https://news.ycombinator.com/item?id=11070797)
- [This atlassian blog post](https://www.atlassian.com/git/tutorials/dotfiles)
