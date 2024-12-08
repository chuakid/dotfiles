# Description
Kelvin's dotfiles, powered by Nix.

# Mac
// TODO

# Prerequisites
1. zsh
2. stow

# Steps
1. clone the repo `git clone https://github.com/chuakid/dotfiles.git --recurse-submodules --depth 1`
2. install zsh
3. Create `username.nix` with the username of the system if not using existing profiles
3. `./install_nix.sh` and run the command to start the nix daemon
4. `./install.sh`
5. make a `.gitconfig_local` file with the [user] directive with name and email

# Additional
- stow mpv if needed
- `.zshrc_local` file in $HOME is sourced, meant for per-machine customisations

## Package list
- [Delta](https://github.com/dandavison/delta)
- [Bat](https://github.com/sharkdp/bat)
- [Zoxide](https://github.com/ajeetdsouza/zoxide)
- [tldr](https://github.com/tldr-pages/tldr)

