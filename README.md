# paulglx's dotfiles

How to restore dotfiles :

```bash
chezmoi init --apply git@github.com:paulglx/dotfiles.git
```

## Homebrew

Packages are captured in `.Brewfile`.

Restore everything on a new machine :

```bash
brew bundle install --file=~/.Brewfile
```

After installing or removing packages, refresh the Brewfile and re-track it :

```bash
brew bundle dump --file=~/.Brewfile --force
chezmoi add ~/.Brewfile
```
