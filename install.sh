# Install home manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# home-manager switch
home-manager switch -f home.nix

# stow
stow common --adopt
git restore . # to reset zshrc
