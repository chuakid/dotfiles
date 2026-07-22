if command -v fnm >/dev/null; then
    export PATH="$HOME/.fnm:$PATH"
    eval "$(fnm env --use-on-cd --shell zsh)"
fi
