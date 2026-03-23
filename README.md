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

- `$ZDOTDIR` is set to `$HOME/.config/zsh`
- stow mpv if needed (`stow mpv`)
- `$ZDOTDIR/.zshrc_local` is sourced, meant for per-machine customisations
- run `abbr import-aliases` to import the aliases as abbrs

### Fish
- Run "fish_update_completions" to update completions from manpages
- Machine specific goes into `~/.config/fish/config.fish`

