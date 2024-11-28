apt update
apt install zoxide bat git-delta python3-pip
pip install tldr

# to account for bat conflicting with another package on ubuntu
sudo ln -s /usr/bin/batcat /usr/local/bin/bat
