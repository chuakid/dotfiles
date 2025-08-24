# Dotfiles

## Prerequisites
1. zsh
2. stow

## Description

Kelvin's dotfiles, powered by Nix.

## Steps

1. clone the repo `git clone https://github.com/chuakid/dotfiles.git --recurse-submodules --depth 1`
2. `./install.sh`
3. make a `.gitconfig_local` file with the [user] directive with name and email

## Additional

- `$ZDOTDIR` is set to `$HOME/.config/zsh`
- stow mpv if needed
- `$ZDOTDIR/.zshrc_local` and `.gitconfig_local` are sourced, meant for per-machine customisations
- run `abbr import-aliases` to import the aliases as abbrs
