#!/bin/bash

# Arch Linux Package Installation Script
# Installs Firefox, Docker, Yay, and AUR packages (Slack, JetBrains Toolbox)

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    print_error "This script should not be run as root"
    exit 1
fi

# Update system first
print_status "Updating system packages..."
sudo pacman -Syu --noconfirm

# Install official repository packages
OFFICIAL_PACKAGES=(
    "firefox"
    "docker"
    "mariadb"
    "nodejs"
    "npm"
    "code"
    "handbrake"
    "git"
    "hyprshot"
    "hyprpaper"
    "nwg-look"
    "thunar"
    "waybar"
    "qbittorrent"
    "base-devel"
    "ntfs-3g"
    "docker-compose"
    "github-cli"
    "os-prober"
    "libreoffice-still"
    "pipewire-pulse"
    "unrar"
    "audacious"
)

print_status "Installing official packages: ${OFFICIAL_PACKAGES[*]}"
for package in "${OFFICIAL_PACKAGES[@]}"; do
    if pacman -Qi "$package" &> /dev/null; then
        print_warning "$package is already installed"
    else
        print_status "Installing $package..."
        sudo pacman -S --noconfirm "$package"
    fi
done

# Enable Docker service
print_status "Enabling Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Enable Pipewire Pulse service
print_status "Enabling Pipewire Pulse service..."
sudo systemctl enable --now pipewire-pulse.service

# Initialize and enable MariaDB
print_status "Initializing and enabling MariaDB..."
sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable mariadb
sudo systemctl start mariadb

print_warning "Remember to run 'sudo mariadb-secure-installation' to secure your MariaDB installation"

# Add user to docker group
print_status "Adding user to docker group..."
sudo usermod -aG docker "$USER"
# Install Yay AUR helper if not present
if ! command -v yay &> /dev/null; then
    print_status "Installing Yay AUR helper..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay
else
    print_warning "Yay is already installed"
fi
# Install AUR packages
AUR_PACKAGES=(
    "slack-desktop"
    "jetbrains-toolbox"
    "postman-bin"
    "beekeeper-studio-bin"
    "localsend-bin"
)
print_status "Installing AUR packages: ${AUR_PACKAGES[*]}"
for package in "${AUR_PACKAGES[@]}"; do
    if yay -Qi "$package" &> /dev/null; then
        print_warning "$package is already installed"
    else
        print_status "Installing $package from AUR..."
        yay -S --noconfirm "$package"
    fi
done
print_status "Installation complete!"
print_warning "Remember to run 'newgrp docker' after this script"
print_status "All packages installed successfully:"

