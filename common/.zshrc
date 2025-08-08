eval "$(oh-my-posh init zsh --config $HOME/.config/omp/theme.yaml)"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
source $ZDOTDIR/antidote/antidote.zsh
antidote load


PATH="$PATH:$HOME/.local/bin"
# History settings
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Case sensitive completions
autoload -U compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Highlight when tabbing through files/folders
# zstyle ':completion:*' menu select
# zstyle ':completion:*' list-colors 'ma=48;2;76;86;106' 


# UTIL INTEGRATIONS
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)" 
command -v fzf >/dev/null && source <(fzf --zsh)
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

export EDITOR=nvim

# aliases
source ~/.zsh_aliases

# Local Configs
[[ ! -f ~/.zshrc_local ]] || source ~/.zshrc_local

[[ ! -f "$HOME/.local/bin/env" ]] || . "$HOME/.local/bin/env"
