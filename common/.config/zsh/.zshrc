# Prompt
eval "$(oh-my-posh init zsh --config $HOME/.config/omp/theme.yaml)"

# Plugins (antidote, static bundle). Regenerate the bundle only when the plugin
# list changes, then source the static file — avoids re-bundling every startup.
zsh_plugins=$ZDOTDIR/.zsh_plugins
if [[ ! $zsh_plugins.zsh -nt $zsh_plugins.txt ]]; then
    source $ZDOTDIR/antidote/antidote.zsh
    antidote bundle <$zsh_plugins.txt >|$zsh_plugins.zsh
fi
source $zsh_plugins.zsh
unset zsh_plugins

# Completions. Run compinit ONCE, after plugins, so plugin-provided completion
# dirs are already on fpath. Our own completion dirs are prepended so a command
# we ship (e.g. `watcher`) wins over a system completion that also lists it
# (`_openstack`). Rebuild the dumpfile at most once a day; otherwise -C reuses
# the cache and skips the slow insecure-directory security audit.
fpath=($ZDOTDIR/completions $ZDOTDIR/conf.d.local/completions $fpath)
autoload -Uz compinit
if [[ -n $ZDOTDIR/.zcompdump(#qNmh+24) ]]; then
    compinit
else
    compinit -C
fi

# Auto-source modular config. Committed drop-ins first, then machine-local ones.
# Drop a *.zsh file into conf.d/ (tracked) or conf.d.local/ (gitignored) and it
# loads at startup — no edits to this file needed. Mirrors fish's conf.d.
for _dir in $ZDOTDIR/conf.d $ZDOTDIR/conf.d.local; do
    for _file in $_dir/*.zsh(N); do
        source $_file
    done
done
unset _dir _file
