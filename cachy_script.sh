#!/bin/bash
# Optimized CachyOS Post-Install Script

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
    virt-manager 
    qemu-desktop 
    libvirt 
    discord 
    qbittorrent 
    lutris 
    steam
    dolphin


    qt5ct 
    qt6ct-kde
    adw-gtk-theme
)


color_echo "Installing native apps..."
paru -S --needed --noconfirm "${native_apps[@]}"

# 3.5 install wezterm from aur
paru -Sy wezterm-nightly-bin

# 4. Enable Virtualization service
systemctl enable --now libvirtd

# 5. Install Flatpaks
flatpak_apps=(
    com.github.tchx84.Flatseal
    net.davidotek.pupgui2
    it.mijorus.gearlever
    com.microsoft.Edge
)

for app in "${flatpak_apps[@]}"; do
    flatpak install flathub "$app" -y
done

color_echo "CachyOS setup complete!"
