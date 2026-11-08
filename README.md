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
- `iterm2` - iTerm2 profile (macOS, not stowed — see [iTerm2](#iterm2))

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

# 5. iTerm2 profile (macOS) — run from Terminal.app with iTerm2 closed
./iterm2/iterm.sh install
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

## iTerm2

`iterm2/profile.json` is the **single** iTerm2 profile ("Auto (Light/Dark)").
It uses separate colors for light and dark mode, so iTerm2 follows the macOS
appearance automatically:

- **Light**: same terminal palette as Cursor's *Cursor Light* theme
  (`theme-cursor/themes/cursor-light-color-theme.json`).
- **Dark**: iTerm2's built-in *Regular* preset.

It isn't stowed: iTerm2 keeps its profiles inside its preferences plist, which
it rewrites on quit, so a symlink would not work. Instead, `iterm2/iterm.sh`
writes the profile into the preferences:

```bash
# Apply profile.json as the ONLY profile and make it the default.
# iTerm2 must be closed (run it from Terminal.app).
./iterm2/iterm.sh install

# Changed something in iTerm2 → Settings → Profiles? Save it back to the repo:
./iterm2/iterm.sh export
git diff iterm2/profile.json
```

After `git pull` on another machine, run `./iterm2/iterm.sh install` again
(with iTerm2 closed) to pick up profile changes.

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