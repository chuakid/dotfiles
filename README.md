# Dotfiles

## Description

Kelvin's dotfiles, powered by Nix.

## Prerequisites

2. stow

## Steps

1. clone the repo `git clone https://github.com/chuakid/dotfiles.git --recurse-submodules --depth 1`
2. Bootstrap the home-manager repo with stow `stow common`
3. `./install_nix.sh` and run the command to start the nix daemon
4. `./install.sh`
5. `home-manager switch`
6. make a `.gitconfig_local` file with the [user] directive with name and email

## Additional

- stow mpv if needed
- `~/.zshrc_local` and `.gitconfig_local` are sourced, meant for per-machine customisations
- run `abbr import-aliases` to import the aliases as abbrs
