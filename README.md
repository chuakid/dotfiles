# Dotfiles

## Prerequisites
1. zsh
2. stow
3. git
4. curl

## Description

Kelvin's dotfiles, managed by stow and Nix home-manager.

## Setup Scripts

- `fedora_script.sh`: Post-install script for Fedora (Flatpaks, RPM Fusion, Codecs, Virtualization, AMD Drivers).
- `cachy_script.sh`: Post-install script for CachyOS (Flatpaks, Virt-manager, Native Apps).

## Steps

1. clone the repo `git clone https://github.com/chuakid/dotfiles.git --recurse-submodules --depth 1`
2. Run `./install.sh` (This will stow the common dotfiles and install Nix with home-manager).
3. make a `.gitconfig_local` file with the [user] directive with name and email

## Additional
### ZSH

`$ZDOTDIR` is set to `$HOME/.config/zsh` (via `~/.zshenv`), so zsh reads its
config from there instead of `~/.zshrc`.

`.zshrc` is a thin loader: it initialises the prompt (oh-my-posh) and plugins
(antidote), then auto-sources every `*.zsh` file in `conf.d/` followed by
`conf.d.local/`. To add config, drop a `.zsh` file into one of those
directories — no edits to `.zshrc` needed. Files load in alphabetical order
within each directory.

```
$ZDOTDIR/
├── .zshrc              # loader: prompt + plugins, then sources conf.d/*.zsh, conf.d.local/*.zsh
├── conf.d/             # tracked, shared across machines
│   ├── rc.zsh          # PATH, history, completions, emacs keybindings, zoxide/fzf/direnv
│   ├── aliases.zsh     # shell aliases (git, eza, kubectl, …)
│   └── fnm.zsh         # Node version manager
├── conf.d.local/       # gitignored, per-machine (secrets, work tools, PATH tweaks)
├── antidote/           # plugin manager (submodule)
└── .zsh_plugins.txt    # antidote plugin list
```

- **Shared config** goes in `conf.d/` (committed).
- **Per-machine config** goes in `conf.d.local/` (gitignored) — e.g. AWS
  defaults, `$PATH` additions for local projects, and completions for tools
  that aren't installed everywhere. `compinit` runs in `conf.d/rc.zsh` before
  `conf.d.local/` loads, so `compdef`-based completions work there.
- Plugins are managed by [antidote](https://github.com/mattmc3/antidote); edit
  `.zsh_plugins.txt` to add/remove them.
- stow mpv if needed (`stow mpv`)

### Fish
- Run "fish_update_completions" to update completions from manpages
- Machine specific goes into `~/.config/fish/config.fish`

### KDE 
- Install konsave with `uv tool install konsave` and `konsave -i profile.knsv` to restore it
