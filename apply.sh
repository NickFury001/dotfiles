#!/bin/bash
# Tip: Start with a blank arch
# Update to the latest everything on a clean arch install
sudo pacman -Syu

# Default behavior is not to use debug
DEBUG=0

if [[ "$1" == "--debug" ]]; then
	DEBUG=1
	echo "Debug mode enabled: pacman will ask for confirmation."
fi

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
		yay -S --noconfirm --quiet "$@"
	fi
}


# === YAY ===
pacinstall --needed base-devel go
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# === HYPRLAND ===
pacinstall hyprland
mkdir -p ~/.config/hypr
cp .config/hypr/hyprland.lua ~/.config/hypr/hyprland.lua

# === KITTY ===
pacinstall kitty
mkdir -p ~/.config/kitty
cp .config/kitty/kitty.conf ~/.config/kitty/kitty.conf

# === FISH ===
pacinstall fish
mkdir -p ~/.config/fish
cp .config/fish/config.fish ~/.config/fish/config.fish
# Make default shell
chsh -s "$(command -v fish)"

# === NEOVIM ===
pacinstall neovim
mkdir -p ~/.config/nvim
cp .config/nvim/init.lua ~/.config/nvim/init.lua
# Lua Autocompletes
pacinstall lua-language-server
# QMLJS Autocompletes (https://quickshell.org/docs/v0.3.0/guide/install-setup/#:~:text=Neovim%20has)
nvim --headless "+TSInstall qmljs" +qa

# === STARSHIP ===
pacinstall starship
cp .config/starship.toml ~/.config/starship.toml

# === SUPERFILE ===
pacinstall superfile

# === HYPRPAPER ===
pacinstall hyprpaper
mkdir -p ~/.config/hypr/
cp .config/hypr/hyprpaper.conf ~/.config/hypr/hyprpaper.conf
mkdir -p ~/Ricing/Wallpapers
cp Ricing/Wallpapers/Cedeira.jpg ~/Ricing/Wallpapers/Cedeira.jpg

# === QUTEBROWSER ===
pacinstall qutebrowser
mkdir -p ~/.config/qutebrowser/userscripts
cp .config/qutebrowser/userscripts/* ~/.config/qutebrowser/userscripts

# === FASTFETCH ===
pacinstall fastfetch
mkdir -p ~/.config/fastfetch
cp .config/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
mkdir -p ~/Ricing/Custom\ Icons/
cp Ricing/Custom\ Icons/Arch_Linux_2D_Icon.png ~/Ricing/Custom\ Icons/

# === QUICKSHELL ===
pacinstall quickshell
mkdir -p ~/.config/quickshell
cp .config/quickshell/* ~/.config/quickshell/

# === 1PASSWORD ===
pacinstall jq wl-clipboard
yayinstall 1password-cli

