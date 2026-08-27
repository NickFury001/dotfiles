#!/bin/bash
# Tip: Start with a blank arch

# # # set -euo pipefail

if [[ ! -d .config || ! -d Ricing ]]; then
    echo "Error: Run this script from the root of the dotfiles repository."
    exit 1
fi

# Authenticate upfront
sudo -v

# Temporarily disable sudo password prompts for the installer to prevent TTY corruption
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/$USER-installer" > /dev/null

# Ensure the temporary sudoers file is removed when the script exits (success, failure, or Ctrl+C)
trap 'sudo rm -f "/etc/sudoers.d/$USER-installer"' EXIT

DEBUG=0
if [[ "${1:-}" == "--debug" ]]; then
    DEBUG=1
    echo "Debug mode enabled: pacman will ask for confirmation and show output."
fi

# Set the total number of steps to calculate the percentage
TOTAL_STEPS=13
CURRENT_STEP=0

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
HOME_DIR="$HOME"

# Progress bar function suitable for TTY
draw_progress() {
    local message="$1"
    ((CURRENT_STEP++))
    
    # If in debug mode, just print the step instead of the bar
    if [[ $DEBUG -eq 1 ]]; then
        echo -e "\n---> Step $CURRENT_STEP/$TOTAL_STEPS: $message <---"
        return
    fi

    local width=40
    local percent=$(( CURRENT_STEP * 100 / TOTAL_STEPS ))
    local filled=$(( percent * width / 100 ))
    local empty=$(( width - filled ))
    
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="#"; done
    for ((i=0; i<empty; i++)); do bar+=" "; done
    
    # \r moves cursor to the beginning of the line
    # \033[2K clears the current line in the TTY
    printf "\r\033[2K[%s] %3d%% | %s" "$bar" "$percent" "$message"
    
    if [[ $CURRENT_STEP -eq $TOTAL_STEPS ]]; then
        echo -e "\nInstallation complete!"
    fi
}

pacinstall() {
    if [[ $DEBUG -eq 1 ]]; then
        sudo pacman -S "$@"
    else
        sudo pacman -S --noconfirm "$@" > /dev/null 2>&1
    fi
}

yayinstall() {
    if [[ $DEBUG -eq 1 ]]; then
        yay -S "$@"
    else
        yay -S --noconfirm --quiet "$@" > /dev/null 2>&1
    fi
}

# === UPDATE SYSTEM ===
draw_progress "Updating system..."
if [[ $DEBUG -eq 1 ]]; then
    sudo pacman -Syu
else
    sudo pacman -Syu --noconfirm > /dev/null 2>&1
fi

PACMAN_PACKAGES=(
	# SysInfo Fetcher
	fastfetch imagemagick
	# Shell
	fish
	# Window Manager
	hyprland
	# Launcher
	hyprlauncher
	# Polkit
	hyprpolkitagent
	# XDG Portal
	xdg-desktop-portal-hyprland
	# Wallpaper
	hyprpaper
	# Font
	ttf-jetbrains-mono-nerd
	# Terminal
	kitty
	# Editor
	neovim lua-language-server tree-sitter-cli
	# Custom UI
	quickshell networkmanager brightnessctl
	# Browser
	qutebrowser
	# Shell Prompt
	starship
	# File Manager
	superfile
	# Clipboard
	wl-clipboard
	# Other
	openssh
	less
	fzf
	btop
	man-db tldr bat
	# Remaps
	keyd
	# 1password dep
	jq
)

# === INSTALL PACMAN PACKAGES ===
draw_progress "Installing Official Packages..."
pacinstall "${PACMAN_PACKAGES[@]}"

# === FASTFETCH ===
draw_progress "Configuring Fastfetch..."
mkdir -p "$CONFIG_DIR/fastfetch"
cp .config/fastfetch/config.jsonc "$CONFIG_DIR/fastfetch/"
mkdir -p "$HOME/Ricing/Custom Icons/"
cp Ricing/Custom\ Icons/Arch_Linux_2D_Icon.png "$HOME/Ricing/Custom Icons/"

# === FISH ===
draw_progress "Configuring Fish..."
mkdir -p "$CONFIG_DIR/fish"
cp .config/fish/config.fish "$CONFIG_DIR/fish/"
# Fix: chsh prompts for a password unless run as sudo
if [[ $DEBUG -eq 1 ]]; then
    sudo chsh -s "$(command -v fish)" "$USER"
else
    sudo chsh -s "$(command -v fish)" "$USER" > /dev/null 2>&1
fi

# === HYPRLAND ===
draw_progress "Configuring Hyprland..."
mkdir -p "$CONFIG_DIR/hypr"
cp .config/hypr/hyprland.lua "$CONFIG_DIR/hypr/"

# === HYPRPAPER ===
draw_progress "Configuring Hyprpaper..."
mkdir -p "$CONFIG_DIR/hypr/"
cp .config/hypr/hyprpaper.conf "$CONFIG_DIR/hypr/"
mkdir -p "$HOME/Ricing/Wallpapers"
cp Ricing/Wallpapers/Cedeira.jpg "$HOME/Ricing/Wallpapers/"

# === KITTY ===
draw_progress "Configuring Kitty..."
mkdir -p "$CONFIG_DIR/kitty"
cp .config/kitty/kitty.conf "$CONFIG_DIR/kitty/"

# === NEOVIM ===
draw_progress "Configuring Neovim..."
mkdir -p "$CONFIG_DIR/nvim"
cp -r .config/nvim/. "$CONFIG_DIR/nvim/"
if [[ $DEBUG -eq 1 ]]; then
    nvim --headless "+TSInstall qmljs" +qa
else
    nvim --headless "+TSInstall qmljs" +qa > /dev/null 2>&1
fi

# === QUICKSHELL ===
draw_progress "Configuring Quickshell..."
mkdir -p "$CONFIG_DIR/quickshell"
cp -r .config/quickshell/. "$CONFIG_DIR/quickshell/"

# === QUTEBROWSER ===
draw_progress "Configuring Qutebrowser..."
mkdir -p "$CONFIG_DIR/qutebrowser/userscripts"
cp -r .config/qutebrowser/userscripts/. "$CONFIG_DIR/qutebrowser/userscripts/"

# === STARSHIP ===
draw_progress "Configuring Starship..."
cp .config/starship.toml "$CONFIG_DIR/"

# === KEYD ===
draw_progress "Configuring keyd..."
sudo mkdir -p /etc/keyd
sudo cp etc/keyd/default.conf /etc/keyd/default.conf

# === YAY ===
draw_progress "Installing yay..."
pacinstall --needed base-devel go
if [[ $DEBUG -eq 1 ]]; then
	git clone https://aur.archlinux.org/yay.git /tmp/yay
else
	git clone https://aur.archlinux.org/yay.git /tmp/yay > /dev/null 2>&1
fi
cd /tmp/yay
if [[ $DEBUG -eq 1 ]]; then
	makepkg -si
else
	makepkg -si --noconfirm > /dev/null 2>&1
fi
rm -rf /tmp/yay

YAY_PACKAGES=(
	# Password Manager
	1password-cli 1password
	# Image Viewer
	qview
	# Window Switcher
	snappy-switcher
	# Phone Connect
	valent
)

yayinstall "${YAY_PACKAGES[@]}"


# When the setup is complete, go into hyprland
draw_progress "Cleaning up..."
cd ..
rm -rf dotfiles
sleep 2
start-hyprland
