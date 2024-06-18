# Install omz
if [ -d ~/.oh-my-zsh ]; then
    echo "omz already installed"
else
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

./stow_all.sh
