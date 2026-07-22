# PATH and environment
PATH="$PATH:$HOME/.local/bin"
export EDITOR=nvim

# History
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

# Completions (case-insensitive matching). Run the full audit+rebuild at most
# once a day; otherwise reuse the cached dump (-C skips the audit and staleness
# check) for fast startup. The glob matches the dump only if it's >24h old.
autoload -Uz compinit
_zcompdump_stale=(${ZDOTDIR:-$HOME}/.zcompdump(Nmh+24))
if (( $#_zcompdump_stale )); then
    compinit
else
    compinit -C
fi
unset _zcompdump_stale
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Emacs keybindings + word navigation
bindkey -e
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word
bindkey '^H' backward-kill-word # Ctrl + Backspace to delete word

# Ctrl-x Ctrl-e: edit the current command line in $EDITOR (nvim)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Tool integrations
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)"
command -v fzf >/dev/null && source <(fzf --zsh)
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

[[ ! -f "$HOME/.local/bin/env" ]] || . "$HOME/.local/bin/env"
