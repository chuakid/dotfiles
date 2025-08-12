# Install nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix run home-manager/master switch

# stow
stow common --adopt
git restore . # to reset zshrc
