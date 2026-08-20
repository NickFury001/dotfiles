# Start with a blank arch

# Install dependencies and apps 
sudo pacman -S hyprland kitty neovim lua-language-server git wl-copy qutebrowser

# Clone the repo w/ the dotfiles
git clone https://github.com/NickFury001/dotfiles

cd dotfiles



mkdir -p ~/.config/nvim
touch ~/.config/nvim/init.lua
