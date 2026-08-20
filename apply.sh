# Tip: Start with a blank arch

# Set up Hyprland
# Install Hyprland
sudo pacman -S hyprland
# Copy dotfiles
mkdir -p ~/.config/hypr
cp .config/hypr/hyprland.lua ~/.config/hypr/hyprland.lua

# Hyprland's terminal will be kitty
# Install kitty
sudo pacman -S kitty
# Copy dotfiles
mkdir -p ~/.config/kitty
cp .config/kitty/kitty.conf ~/.config/kitty/kitty.conf

# Default shell will be fish, which Kitty depends on to work
# Install Fish (Friendly Interactive SHell)
sudo pacman -S fish
# Set as default shell
chsh -s "$(command -v fish)"
# Copy dotfiles
mkdir -p ~/.config/fish
cp .config/fish/config.fish ~/.config/fish/config.fish

# Default TUI Text editor will be neovim
sudo pacman -S neovim
# Install a lua language server to have autocomplete when editing hyprland.lua
sudo pacman -S lua-language-server

# TODO: Actually Rice NeoVim
mkdir -p ~/.config/nvim
cp .config/nvim/init.lua ~/.config/nvim/init.lua

# Rice Shell Prompt with Starship
sudo pacman -S starship
cp .config/starship.toml ~/.config/starship.toml
