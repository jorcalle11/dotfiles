# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

- `zsh` - Zsh configuration
- `git` - Git configuration
- `cursor` - Editor settings (macos/linux)
- `opencode` - OpenCode config and skills
- `ssh` - SSH config and known hosts
- `hosts` - System hosts file

## Setup

```bash
# Clone the repo
git clone git@github.com:jorcalle11/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Stow packages (macOS)
stow zsh git cursor/macos opencode ssh

# Stow hosts (requires sudo)
sudo stow hosts -t /

# Stow packages (Linux)
stow zsh git cursor/linux opencode ssh
```

## Syncing Changes

After modifying any config file:

```bash
cd ~/dotfiles
git add .
git commit -m "update"
git push
```

On another machine:

```bash
cd ~/dotfiles
git pull
stow -R .  # restow to refresh symlinks
```