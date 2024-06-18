#!/usr/bin/env bash

# install everything
sudo dnf install $(< home_packages.list)

# Install omz
if [ -d ~/.oh-my-zsh ]; then
    echo "omz already installed"
else
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# install faster-node-manager (fnm)
curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell

# install pyenv
curl https://pyenv.run | bash