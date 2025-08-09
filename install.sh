#!/bin/bash
set -euo pipefail

# ---------------------------
# (Mint-only) enable snapd
# ---------------------------
# Remove block on snapd if present
sudo rm -f /etc/apt/preferences.d/nosnap.pref || true

sudo apt update -y
sudo apt install -y snapd

# start & enable the daemon
sudo systemctl enable --now snapd.socket
sudo systemctl start snapd.apparmor 2>/dev/null || true

# ensure /snap exists
sudo ln -sf /var/lib/snapd/snap /snap

# sanity check
snap version || true

# tectonic via snap (LaTeX-free PDF engine for pandoc)
sudo snap install tectonic --classic
tectonic -V || true

# ---------------------------
# Base tools
# ---------------------------
sudo apt update -y

# Live grep & linters
sudo apt install -y ripgrep pylint shellcheck

# Clipboard support
sudo apt install -y xclip

# pipx for Python tooling and pynvim
sudo apt install -y pipx
pipx ensurepath
pipx install --include-deps pynvim || true

# ---------------------------
# Neovim (prebuilt tarball)
# ---------------------------
curl -L -o /tmp/nvim-linux-x86_64.tar.gz \
  https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz

sudo rm -rf /opt/nvim /opt/nvim-linux-x86_64 2>/dev/null || true
echo 'Installing nvim'
sudo tar -C /opt -xzf /tmp/nvim-linux-x86_64.tar.gz
echo 'Cleaning up'
rm -f /tmp/nvim-linux-x86_64.tar.gz

# Add aliases (idempotent)
grep -q "/opt/nvim-linux-x86_64/bin/nvim" ~/.bashrc || \
  echo "alias nvim='/opt/nvim-linux-x86_64/bin/nvim'" >> ~/.bashrc
grep -q "/opt/nvim-linux-x86_64/bin/nvim" ~/.zshrc  || \
  echo "alias nvim='/opt/nvim-linux-x86_64/bin/nvim'" >> ~/.zshrc

# ---------------------------
# Node tooling for LSPs
# ---------------------------
sudo apt install -y npm
sudo npm install -g pyright bash-language-server tree-sitter-cli

# ---------------------------
# Neovim config
# ---------------------------
mkdir -p ~/.config/nvim/lua/plugins

# lazy.nvim
if [ ! -d ~/.local/share/nvim/lazy/lazy.nvim ]; then
  git clone https://github.com/folke/lazy.nvim ~/.local/share/nvim/lazy/lazy.nvim
fi

# your config
if [ -d ~/.config/nvim/.git ]; then
  git -C ~/.config/nvim pull --ff-only || true
else
  git clone https://github.com/kjtakke/neovim ~/.config/nvim
fi

# Refresh shell aliases in current session (ignore if shells not present)
[ -f ~/.zshrc ] && . ~/.zshrc || true
[ -f ~/.bashrc ] && . ~/.bashrc || true

# ---------------------------
# Done – launch Neovim
# ---------------------------
exec /opt/nvim-linux-x86_64/bin/nvim

