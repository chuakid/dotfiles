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

# Completions: case-insensitive matching. compinit itself runs once in .zshrc.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Force-rebuild the completion cache. The compinit in .zshrc rebuilds its dump
# at most once a day, so newly added completions won't appear until then — run
# this to pick them up immediately.
rebuild-completions() {
    rm -f $ZDOTDIR/.zcompdump*
    autoload -Uz compinit && compinit -d $ZDOTDIR/.zcompdump
}

# Word navigation (vi-mode owns the base keymap; these run after it via
# ZVM_INIT_MODE=sourcing, so they augment insert mode rather than get clobbered).
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
