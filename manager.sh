#!/bin/bash

# Script: nvim-takken
# Usage: sudo nvim-takken --install | --upgrade

set -euo pipefail

INSTALL_URL="https://raw.githubusercontent.com/kjtakke/neovim/refs/heads/main/install.sh"
UPGRADE_URL="https://raw.githubusercontent.com/kjtakke/neovim/refs/heads/main/update.sh"

case "${1:-}" in
  --install)
    echo "Running Neovim install script..."
    curl -fsSL "$INSTALL_URL" | bash
    ;;
  --upgrade)
    echo "Running Neovim upgrade script..."
    curl -fsSL "$UPGRADE_URL" | bash
    ;;
  *)
    echo "Usage: sudo nvim-takken --install | --upgrade"
    exit 1
    ;;
esac
