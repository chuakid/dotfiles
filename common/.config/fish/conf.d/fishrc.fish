oh-my-posh init fish --config $HOME/.config/omp/theme.yaml | source

# 🗃️ PATH and Environment Variables
# Use 'set -x' to export variables in Fish.
set -x PATH $PATH $HOME/.local/bin
set -x EDITOR nvim

# ⚙️ UTIL INTEGRATIONS
# Use 'status is-command' or 'type -q' to check if a command exists.

# Zoxide
if type -q zoxide
    zoxide init fish | source
end

# FZF
if type -q fzf
    fzf --fish | source
end

# Direnv
if type -q direnv
    direnv hook fish | source
end

# The last line remains similar, just converted to Fish syntax:
if test -f "$HOME/.local/bin/env"
    source "$HOME/.local/bin/env"
end

set theme_color_scheme "Catppuccin Mocha"
