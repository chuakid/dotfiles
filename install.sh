# Install omz
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"

# stow
stow common --adopt
git reset --hard # to reset zshrc
