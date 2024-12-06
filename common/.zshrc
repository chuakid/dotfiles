# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

PATH="$PATH:~/.local/bin"
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
zstyle ':completion:*' menu select

# plugins
for plugin_folder in $(ls ~/.zsh_plugins) 
do
source ~/.zsh_plugins/$plugin_folder/$plugin_folder.plugin.zsh
done

# aliases
source ~/.zsh_aliases

# Local Configs
[[ ! -f ~/.zshrc_local ]] || source ~/.zshrc_local

# alias home manager
alias switch="home-manager switch -f ~/dotfiles/home.nix"

# zoxide
if command -v zoxide >/dev/null 
then 
  eval "$(zoxide init zsh)"
fi

# Ctrl + arrow key
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Powerlevel10k
source ~/.powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export EDITOR=vim
