# 📦 Nix Profile
if test -d ~/.nix-profile/bin
    fish_add_path ~/.nix-profile/bin
end

oh-my-posh init fish --config $HOME/.config/omp/theme.yaml | source
fish_vi_key_bindings
set fish_greeting ""

# 🗃️ PATH and Environment Variables
# Use 'set -x' to export variables in Fish.
fish_add_path $HOME/.local/bin
set -gx EDITOR nvim

# ⚙️ UTIL INTEGRATIONS
# Use 'status is-command' or 'type -q' to check if a command exists.

# Zoxide
if type -q zoxide
    zoxide init fish --cmd cd | source
end

# FZF
if type -q fzf
    fzf --fish | source
end

# Direnv
if type -q direnv
    direnv hook fish | source
end

fish_config theme choose catppuccin-mocha
