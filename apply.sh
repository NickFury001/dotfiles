#!/bin/bash
# Tip: Start with a blank arch

# Authenticate upfront
sudo -v

# Temporarily disable sudo password prompts for the installer to prevent TTY corruption
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/$USER-installer" > /dev/null

# Ensure the temporary sudoers file is removed when the script exits (success, failure, or Ctrl+C)
trap 'sudo rm -f "/etc/sudoers.d/$USER-installer"' EXIT

DEBUG=0
if [[ "$1" == "--debug" ]]; then
    DEBUG=1
    echo "Debug mode enabled: pacman will ask for confirmation and show output."
fi

# Set the total number of steps to calculate the percentage
TOTAL_STEPS=14
CURRENT_STEP=0

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

# === YAY ===
draw_progress "Installing yay..."
pacinstall --needed base-devel go
if [[ $DEBUG -eq 1 ]]; then
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si
else
    git clone https://aur.archlinux.org/yay.git > /dev/null 2>&1
    cd yay || exit
    makepkg -si --noconfirm > /dev/null 2>&1
fi
cd ..
rm -rf yay

# === HYPRLAND ===
draw_progress "Installing Hyprland..."
pacinstall hyprland
mkdir -p ~/.config/hypr
cp .config/hypr/hyprland.lua ~/.config/hypr/hyprland.lua

# === KITTY ===
draw_progress "Installing Kitty..."
pacinstall kitty
mkdir -p ~/.config/kitty
cp .config/kitty/kitty.conf ~/.config/kitty/kitty.conf

# === JETBRAINS MONO NERD FONT ===
draw_progress "Installing JetBrains Mono Nerd Font..."
pacinstall ttf-jetbrains-mono-nerd

# === FISH ===
draw_progress "Installing Fish..."
pacinstall fish
mkdir -p ~/.config/fish
cp .config/fish/config.fish ~/.config/fish/config.fish
# Fix: chsh prompts for a password unless run as sudo
if [[ $DEBUG -eq 1 ]]; then
    sudo chsh -s "$(command -v fish)" "$USER"
else
    sudo chsh -s "$(command -v fish)" "$USER" > /dev/null 2>&1
fi

# === NEOVIM ===
draw_progress "Installing Neovim..."
pacinstall neovim
mkdir -p ~/.config/nvim
cp -r .config/nvim/. ~/.config/nvim/
pacinstall lua-language-server
if [[ $DEBUG -eq 1 ]]; then
    nvim --headless "+TSInstall qmljs" +qa
else
    nvim --headless "+TSInstall qmljs" +qa > /dev/null 2>&1
fi

# === STARSHIP ===
draw_progress "Installing Starship..."
pacinstall starship
cp .config/starship.toml ~/.config/starship.toml

# === SUPERFILE ===
draw_progress "Installing Superfile..."
pacinstall superfile

# === HYPRPAPER ===
draw_progress "Installing Hyprpaper..."
pacinstall hyprpaper
mkdir -p ~/.config/hypr/
cp .config/hypr/hyprpaper.conf ~/.config/hypr/hyprpaper.conf
mkdir -p ~/Ricing/Wallpapers
cp Ricing/Wallpapers/Cedeira.jpg ~/Ricing/Wallpapers/Cedeira.jpg

# === QUTEBROWSER ===
draw_progress "Installing Qutebrowser..."
pacinstall qutebrowser
mkdir -p ~/.config/qutebrowser/userscripts
cp .config/qutebrowser/userscripts/* ~/.config/qutebrowser/userscripts

# === FASTFETCH ===
draw_progress "Installing Fastfetch..."
pacinstall fastfetch
mkdir -p ~/.config/fastfetch
cp .config/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
mkdir -p ~/Ricing/Custom\ Icons/
cp Ricing/Custom\ Icons/Arch_Linux_2D_Icon.png ~/Ricing/Custom\ Icons/

# === QUICKSHELL ===
draw_progress "Installing Quickshell..."
pacinstall quickshell
mkdir -p ~/.config/quickshell
cp .config/quickshell/* ~/.config/quickshell/

# === 1PASSWORD ===
draw_progress "Installing 1Password..."
pacinstall jq wl-clipboard
yayinstall 1password-cli
