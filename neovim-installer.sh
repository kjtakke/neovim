#!/bin/bash
sudo apt update
sudo apt install neovim -y
sudo apt install pipx -y
sudo apt-get install xclip -y
pipx ensurepath
pipx install pynvim
mkdir -p ~/.config/nvim/lua/plugins
git clone https://github.com/folke/lazy.nvim ~/.local/share/nvim/lazy/lazy.nvim
sudo apt install npm -y
sudo npm install -g pyright
sudo npm install -g bash-language-server
mkdir -p ~/.config/nvim
mkdir -p ~/.config/nvim/lua
mkdir -p ~/.config/nvim/lua/plugins
git clone https://github.com/kjtakke/neovim.git ~/nvim-clone
cp -f ~/nvim-clone/init.lua ~/.config/nvim/init.lua
cp -f ~/nvim-clone/lazy-lock.json ~/.config/nvim/lazy-lock.json
cp -f ~/nvim-clone/lua/cmp.lua.bak ~/.config/nvim/lua/cmp.lua.bak
cp -f ~/nvim-clone/lua/init.lua ~/.config/nvim/lua/init.lua
cp -f ~/nvim-clone/lua/lsp.lua ~/.config/nvim/lua/lsp.lua
cp -f ~/nvim-clone/lua/plugins/init.lua ~/.config/nvim/lua/plugins/init.lua
rm -rf ~/nvim-clone
