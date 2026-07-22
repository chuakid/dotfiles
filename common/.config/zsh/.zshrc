# Prompt
eval "$(oh-my-posh init zsh --config $HOME/.config/omp/theme.yaml)"

# Plugins (antidote)
source $ZDOTDIR/antidote/antidote.zsh
antidote load

# Auto-source modular config. Committed drop-ins first, then machine-local ones.
# Drop a *.zsh file into conf.d/ (tracked) or conf.d.local/ (gitignored) and it
# loads at startup — no edits to this file needed. Mirrors fish's conf.d.
for _dir in $ZDOTDIR/conf.d $ZDOTDIR/conf.d.local; do
    for _file in $_dir/*.zsh(N); do
        source $_file
    done
done
unset _dir _file
