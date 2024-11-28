apt update
apt install zsh
# install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

apt install bat git-delta pipx
pipx ensurepath
pipx install tldr

./install.sh
# to account for bat conflicting with another package on ubuntu
sudo ln -s /usr/bin/batcat /usr/local/bin/bat
