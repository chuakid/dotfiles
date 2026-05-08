#!/bin/bash
# Refined CachyOS KDE Post-Install Script

# Check for sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo (or use paru which handles it)"
    exit 1
fi

color_echo() {
    echo -e "\033[1;33m$1\033[0m"
}

# 1. Update everything
color_echo "Updating system..."
paru -Syu --noconfirm

# 2. Setup Flatpak
color_echo "Setting up Flathub..."
paru -S --needed --noconfirm flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 3. Install Native Apps 
native_apps=(
    # Virtualization
    virt-manager 
    qemu-desktop 
    libvirt 
    
    # Social/Gaming
    discord 
    qbittorrent 
    lutris 
    steam
    tailscale
)

color_echo "Installing native apps..."
paru -S --needed --noconfirm "${native_apps[@]}"

# 3.5 Install wezterm
color_echo "Installing wezterm-nightly-bin..."
paru -Sy wezterm-nightly-bin

# 4. Enable Services
color_echo "Enabling services..."
systemctl enable --now libvirtd
systemctl enable --now tailscaled

# 5. Install Flatpaks
flatpak_apps=(
    com.github.tchx84.Flatseal
    net.davidotek.pupgui2
    it.mijorus.gearlever
    org.telegram.desktop
)

for app in "${flatpak_apps[@]}"; do
    color_echo "Installing Flatpak: $app"
    flatpak install flathub "$app" -y
done

# 6. Firewall for KDE Connect
color_echo "Configuring firewall for KDE Connect..."
sudo ufw allow 1714:1764/udp
sudo ufw allow 1714:1764/tcp
sudo ufw reload

color_echo "CachyOS KDE setup complete!"
