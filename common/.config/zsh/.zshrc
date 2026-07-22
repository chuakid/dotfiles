# Prompt
eval "$(oh-my-posh init zsh --config $HOME/.config/omp/theme.yaml)"

# fpath must include our generated _command completion dirs BEFORE the first
# compinit, otherwise a command name we ship (e.g. `watcher`) can be claimed by
# a system completion that also lists it (e.g. `_openstack`), and the later
# compinit in conf.d won't override an already-registered association.
fpath=($ZDOTDIR/completions $ZDOTDIR/conf.d.local/completions $fpath)
autoload -Uz compinit && compinit

# Plugins (antidote, static bundle). Regenerate the bundle only when the plugin
# list changes, then source the static file — avoids re-bundling every startup.
zsh_plugins=$ZDOTDIR/.zsh_plugins
if [[ ! $zsh_plugins.zsh -nt $zsh_plugins.txt ]]; then
    source $ZDOTDIR/antidote/antidote.zsh
    antidote bundle <$zsh_plugins.txt >|$zsh_plugins.zsh
fi
source $zsh_plugins.zsh
unset zsh_plugins

# Auto-source modular config. Committed drop-ins first, then machine-local ones.
# Drop a *.zsh file into conf.d/ (tracked) or conf.d.local/ (gitignored) and it
# loads at startup — no edits to this file needed. Mirrors fish's conf.d.
for _dir in $ZDOTDIR/conf.d $ZDOTDIR/conf.d.local; do
    for _file in $_dir/*.zsh(N); do
        source $_file
    done
done
unset _dir _file
