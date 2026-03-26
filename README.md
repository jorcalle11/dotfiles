# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Prerequisites

Install GNU Stow:
- **macOS**: `brew install stow`
- **Linux**: `sudo apt install stow` or `sudo yum install stow`

## Packages

- `zsh` - Zsh configuration
- `git` - Git configuration
- `cursor` - Editor settings (macos/linux)
- `opencode` - OpenCode config and skills
- `ssh` - SSH config and known hosts
- `hosts` - System hosts file

## Initial Setup (Fresh Machine)

```bash
# 1. Clone the repo
git clone git@github.com:jorcalle11/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Install stow (if not already installed)
# macOS:
brew install stow
# Linux:
sudo apt install stow

# 3. Stow packages
# macOS:
stow zsh git opencode ssh
stow -d cursor -t ~/Library/Application\ Support/Cursor macos

# Linux:
stow zsh git opencode ssh
stow -d cursor -t ~/.config/Cursor linux

# 4. Stow hosts (requires sudo)
sudo stow hosts -t /
```

## Syncing Changes

After modifying any config file on machine A:

```bash
cd ~/dotfiles
git add .
git commit -m "update dotfiles"
git push
```

On machine B:

```bash
cd ~/dotfiles
git pull
stow -R .    # restow all packages to refresh symlinks
```

## Troubleshooting

### Conflicts during stow
If you get "cannot stow over existing target" errors, the original files weren't removed before stowing. Remove them first:
```bash
rm ~/.zshrc ~/.gitconfig
rm -rf ~/.config/opencode ~/.agents
# For cursor on macOS:
rm ~/Library/Application\ Support/Cursor/User/settings.json
# For cursor on Linux:
rm ~/.config/Cursor/User/settings.json
```

Then run stow again.

### Check symlinks
```bash
ls -la ~/.zshrc ~/.gitconfig ~/.agents ~/.config/opencode/
```
Files should point to `dotfiles/...` paths.