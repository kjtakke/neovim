# Clone the latest configuration
git clone https://github.com/kjtakke/neovim.git ~/nvim-clone

# Update configuration files
cp -f ~/nvim-clone/init.lua ~/.config/nvim/init.lua
cp -f ~/nvim-clone/search/nsearch.txt ~/.config/nvim/nsearch.txt
cp -f ~/nvim-clone/lazy-lock.json ~/.config/nvim/lazy-lock.json
cp -f ~/nvim-clone/lua/cmp.lua.bak ~/.config/nvim/lua/cmp.lua.bak
cp -f ~/nvim-clone/lua/init.lua ~/.config/nvim/lua/init.lua
cp -f ~/nvim-clone/lua/lsp.lua ~/.config/nvim/lua/lsp.lua
cp -f ~/nvim-clone/lua/plugins/init.lua ~/.config/nvim/lua/plugins/init.lua

# Remove temporary clone directory
rm -rf ~/nvim-clone

# Launch NeoVim to apply changes
nvim
