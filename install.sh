# Update package lists
sudo apt update

#Install Live Grep
sudo apt install ripgrep pylint shellcheck

# Install NeoVim
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
echo 'Installing nvim'
sudo tar -C /opt -xzf ./nvim-linux-x86_64.tar.gz
echo 'Cleaning up'
rm nvim-linux-x86_64.tar.gz
echo "alias nvim='/opt/nvim-linux-x86_64/bin/nvim'" >> ~/.bashrc
echo "alias nvim='/opt/nvim-linux-x86_64/bin/nvim'" >> ~/.zshrc
# Install pipx for Python package management
sudo apt install pipx -y

# Install xclip for clipboard support
sudo apt-get install xclip -y

# Ensure pipx is in your PATH
pipx ensurepath

# Install pynvim for Python support in NeoVim
pipx install pynvim

# Create directories for NeoVim configuration
mkdir -p ~/.config/nvim/lua/plugins

# Clone and install lazy.nvim plugin manager
git clone https://github.com/folke/lazy.nvim ~/.local/share/nvim/lazy/lazy.nvim

# Install Node.js package manager
sudo apt install npm -y

# Install TypeScript and Bash language servers
sudo npm install -g pyright
sudo npm install -g bash-language-server

# Clone configuration repository and set up NeoVim
git clone https://github.com/kjtakke/neovim.git ~/nvim-clone
cp -f ~/nvim-clone/init.lua ~/.config/nvim/init.lua
cp -f ~/nvim-clone/search/nsearch.txt ~/.config/nvim/nsearch.txt
cp -f ~/nvim-clone/lazy-lock.json ~/.config/nvim/lazy-lock.json
cp -f ~/nvim-clone/lua/cmp.lua.bak ~/.config/nvim/lua/cmp.lua.bak
cp -f ~/nvim-clone/lua/init.lua ~/.config/nvim/lua/init.lua
cp -f ~/nvim-clone/lua/lsp.lua ~/.config/nvim/lua/lsp.lua
cp -f ~/nvim-clone/lua/plugins/init.lua ~/.config/nvim/lua/plugins/init.lua

# Remove temporary clone directory
rm -rf ~/nvim-clone

source ~/.zshrc
source ~/.bashrc
# Launch NeoVim
nvim
