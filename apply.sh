# Tip: Start with a blank arch

# === YAY ===
sudo pacman -S --needed git base-devel go --noconfirm --quiet
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# === HYPRLAND ===
sudo pacman -S hyprland --noconfirm --quiet
mkdir -p ~/.config/hypr
cp .config/hypr/hyprland.lua ~/.config/hypr/hyprland.lua

# === KITTY ===
sudo pacman -S kitty --noconfirm --quiet
mkdir -p ~/.config/kitty
cp .config/kitty/kitty.conf ~/.config/kitty/kitty.conf

# === FISH ===
sudo pacman -S fish --noconfirm --quiet
mkdir -p ~/.config/fish
cp .config/fish/config.fish ~/.config/fish/config.fish
# Make default shell
chsh -s "$(command -v fish)"

# === NEOVIM ===
sudo pacman -S neovim --noconfirm --quiet
mkdir -p ~/.config/nvim
cp .config/nvim/init.lua ~/.config/nvim/init.lua
# Lua Autocompletes
sudo pacman -S lua-language-server --noconfirm --quiet
# QMLJS Autocompletes (https://quickshell.org/docs/v0.3.0/guide/install-setup/#:~:text=Neovim%20has)
nvim --headless "+TSInstall qmljs" +qa

# === STARSHIP ===
sudo pacman -S starship --noconfirm --quiet
cp .config/starship.toml ~/.config/starship.toml

# === SUPERFILE ===
sudo pacman -S superfile --noconfirm --quiet

# === HYPRPAPER ===
sudo pacman -S hyprpaper --noconfirm --quiet
mkdir -p ~/.config/hypr/
cp .config/hypr/hyprpaper.conf ~/.config/hypr/hyprpaper.conf
mkdir -p ~/Ricing/Wallpapers
cp Ricing/Wallpapers/Cedeira.jpg ~/Ricing/Wallpapers/Cedeira.jpg

# === QUTEBROWSER ===
sudo pacman -S qutebrowser --noconfirm --quiet
mkdir -p ~/.config/qutebrowser/userscripts
cp .config/qutebrowser/userscripts/* ~/.config/qutebrowser/userscripts

# === FASTFETCH ===
sudo pacman -S fastfetch --noconfirm --quiet
mkdir -p ~/.config/fastfetch
cp .config/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
mkdir -p ~/Ricing/Custom\ Icons/
cp Ricing/Custom Icons/Arch_Linux_2D_Icon.png ~/Ricing/Custom Icons/Arch_Linux_2D_Icon.png

# === QUICKSHELL ===
sudo pacman -S quickshell --noconfirm --quiet
mkdir -p ~/.config/quickshell
cp .config/quickshell/* ~/.config/quickshell/

# === 1PASSWORD ===
sudo pacman -S jq rofi-wayland wl-clipboard
yay -S 1password-cli --noconfirm --quiet

