# dotfiles

Personal macOS setup, managed with [chezmoi](https://www.chezmoi.io/).

## New machine

```sh
brew install chezmoi
chezmoi init --ssh jorcalle11   # SSH so you can push from ~/.local/share/chezmoi
```

Then **quit iTerm2**, open **Terminal.app** and run:

```sh
chezmoi apply
```

(The iTerm2 step refuses to run while iTerm2 is open — see [iTerm2](#iterm2).)

## Layout

```
.
├── .chezmoiroot              # "home": only home/ is mapped onto ~
├── home/                     # chezmoi source state → ~
│   └── .chezmoiscripts/      # setup scripts run by `chezmoi apply`
│       └── run_onchange_after_iterm2.sh.tmpl
└── iterm2/                   # read/written directly by iTerm2 (not copied to ~)
    └── com.googlecode.iterm2.plist
```

- **`home/`** is chezmoi's source directory (set by `.chezmoiroot`). Files here use
  chezmoi naming (`dot_zshrc` → `~/.zshrc`, `private_`, `.tmpl`, …). Add new
  configs with `chezmoi add ~/.something`.
- **Top-level folders** (like `iterm2/`) are for apps that sync their own
  settings from a folder. They stay in the repo and the app points at them, so
  there is nothing to copy.

## iTerm2

All iTerm2 settings (profiles, keys, appearance, AI, pointer actions, …) live in
`iterm2/com.googlecode.iterm2.plist`. On macOS, `chezmoi apply` runs
`run_onchange_after_iterm2.sh.tmpl`, which points iTerm2's built-in
*Settings → General → Settings → Load settings from a custom folder* at this
folder and sets **Save changes: Automatically**.

That means:

- **Change something in iTerm2** → it is written to the plist in the repo right
  away. Review and commit it:
  ```sh
  chezmoi cd
  git diff iterm2/ && git commit -am "iterm2: …" && git push
  ```
- **Pull on another machine** (`chezmoi update`) → restart iTerm2 to load it.
  If iTerm2 was open while the file changed, it asks whether to overwrite;
  choose *Discard Local Changes* to keep the pulled version.

iTerm2 only syncs portable settings: it skips keys starting with `NS`, `SU` and
`NoSync` (window positions, update checks, per-machine state), so diffs stay
small. API keys for the AI features are stored in the Keychain, not here.

### Current profile

A single profile, **Auto (Light/Dark)**, that follows the macOS appearance:

- **Light**: Cursor's *Cursor Light* terminal palette
  (`theme-cursor/themes/cursor-light-color-theme.json` inside Cursor.app).
  Translucent colors (selection, bright black) are pre-blended over the
  `#F3F3F3` background, since iTerm2 ignores alpha for them.
- **Dark**: iTerm2's built-in *Regular* preset.

## Why chezmoi

Compared with the previous GNU Stow setup:

- **Copies instead of symlinks**, so apps that replace their config file
  atomically don't break the link.
- **Templates and OS conditions** (`{{ if eq .chezmoi.os "darwin" }}`) for
  per-machine differences without one branch per machine.
- **Scripts** (`run_once_`, `run_onchange_`) for setup that isn't a file, such
  as `defaults write`.
- **Secrets** from 1Password, Bitwarden or the Keychain via templates, so they
  never get committed.
- **One-command bootstrap** on a new machine (`chezmoi init --apply`).

Stow is simpler but has no templates, scripts or secret handling. yadm turns
`~` itself into a git repo and only supports per-OS alternate files.
