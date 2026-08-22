# Dotfiles

## Prerequisites
1. zsh
2. stow
3. git
4. curl

## Description

Kelvin's dotfiles, managed by stow and Nix home-manager, with
[mise](https://mise.jdx.dev) for language runtimes and per-project environments.

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
│   ├── rc.zsh          # PATH, history, completions, emacs keybindings, zoxide/fzf
│   ├── aliases.zsh     # shell aliases (git, eza, kubectl, …)
│   └── mise.zsh        # activates mise (go/rust/node + per-project runtimes)
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

### Language runtimes & project env (mise)

[mise](https://mise.jdx.dev) manages language runtimes and per-project
environments, replacing `fnm` and `direnv` entirely.

- **Global tools** are pinned in `~/.config/mise/config.toml` (`go`, `rust`,
  `node`) and activated by `conf.d/mise.zsh`.
- **Per-project** config lives in a `mise.local.toml` at the project root. It is
  gitignored globally (via `~/.config/git/ignore`) so machine-specific env and
  secrets stay untracked — the role the old `.envrc` files played. Example:

  ```toml
  [env]
  SOME_SECRET = "…"
  _.python.venv = { path = ".venv" }   # auto-activates the venv on cd
  ```

  The venv path is relative to the config file, so it must be per-project — a
  global config can't express "activate whatever project I'm in".
- **Gotcha:** mise won't load a new or changed config file until it's trusted.
  If activation is silently skipped, run `mise trust` in the project.

### Fish
- Run "fish_update_completions" to update completions from manpages
- Machine specific goes into `~/.config/fish/config.fish`

### KDE 
- Install konsave with `uv tool install konsave` and `konsave -i profile.knsv` to restore it
