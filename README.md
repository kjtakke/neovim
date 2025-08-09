# Neovim Starter Guide

| Section | Link |
|---------|------|
| Overview | [#overview](#overview) |
| Files | [#files](#files) |
| Installation | [#installation](#installation) |
| Linux Debian (apt) | [#linux-debian-apt](#linux-debian-apt) |
| Linux Red Hat (yum/dnf) | [#linux-red-hat-yumdnf](#linux-red-hat-yumdnf) |
| macOS (Homebrew) | [#macos-homebrew](#macos-homebrew) |
| Windows (Chocolatey) | [#windows-chocolatey](#windows-chocolatey) |
| Linux Arch (pacman) | [#linux-arch-pacman](#linux-arch-pacman) |
| Directory Structure | [#directory-structure](#directory-structure) |
| Root Directory: `~/.config/nvim` | [#root-directory-confignvim](#root-directory-confignvim) |
| `lua/` – Core Lua Configuration Files | [#lua--core-lua-configuration-files](#lua--core-lua-configuration-files) |
| `lua/config/` – Core Neovim Behaviour Configuration | [#luaconfig--core-neovim-behaviour-configuration](#luaconfig--core-neovim-behaviour-configuration) |
| `lua/plugins/` – Plugin Management and Configuration | [#luaplugins--plugin-management-and-configuration](#luaplugins--plugin-management-and-configuration) |
| `lua/custom/` – Custom Utilities and Extensions | [#luacustom--custom-utilities-and-extensions](#luacustom--custom-utilities-and-extensions) |
| `spell/` – Spellchecking Data | [#spell--spellchecking-data](#spell--spellchecking-data) |
| AI UI Module Workflow | [#ai-ui-module-workflow](#ai-ui-module-workflow) |
| Installation Steps | [#installation-steps](#installation-steps) |
| Customisation Guidelines | [#customisation-guidelines](#customisation-guidelines) |

## Overview

This project is a structured Neovim configuration designed for maintainability, modularity, and ease of extension. It leverages Lua for configuration, uses the Lazy.nvim plugin manager for package handling, and incorporates additional custom utilities, including an AI-assisted interface (`ai_ui`) that integrates with an external HTTP API.

The configuration is organised into logical directories for different concerns: core settings, plugin specifications, plugin configurations, and custom utility scripts. Each Lua file is responsible for a distinct part of the editor’s behaviour.

## Files
```txt
~/.config/nvim/
├─ init.lua
├─ lua/
│  ├─ utils.lua
│  ├─ config/
│  │  ├─ options.lua
│  │  ├─ appearance.lua
│  │  ├─ autocmds.lua
│  │  ├─ keymaps.lua
│  ├─ plugins/
│  │  ├─ init.lua
│  │  ├─ spec.lua
│  │  ├─ cfg/
│  │  │  ├─ catppuccin.lua
│  │  │  ├─ cmp.lua
│  │  │  ├─ lualine.lua
│  │  │  ├─ markdown_preview.lua
│  │  │  ├─ mason.lua
│  │  │  ├─ mason_lspconfig.lua
│  │  │  ├─ telescope.lua
│  │  │  ├─ todo_comments.lua
│  │  │  ├─ treesitter.lua
│  │  │  └─ nvim_tree.lua
│  └─ custom/
│     ├─ ai_ui.lua           ← Requires AI endpoints at http://localhost:5001
│     ├─ lint.lua
│     ├─ spell.lua
│     ├─ telescope_extras.lua
│     ├─ nsearch.lua
│     ├─ cursor.lua
│     └─ multicursor.lua
└─ spell/
   └─ en.utf-8.add           (auto-created if missing)

```
* * *

## Installation

Supported platforms
- Ubuntu 22.04+ or Linux Mint 21+ (x86_64)
- Systemd-enabled environment (required for snapd)
- Internet access and sudo privileges

Quick start
- Download or clone this repository.
- Open a terminal in the repository root.
- Run: chmod +x install.sh && ./install.sh
- The script will finish by launching Neovim.

What the installer does
- Enables snapd on Linux Mint (removes nosnap.pref, enables snapd.socket, sets up /snap).
- Installs base tools via apt: ripgrep, pylint, shellcheck, xclip, cloc, npm, pipx, pandoc, wkhtmltopdf.
- Installs Tectonic via snap (for LaTeX-free PDF generation with Pandoc).
- Sets up Python tooling with pipx and installs pynvim.
- Installs Neovim (latest stable prebuilt x86_64 tarball) into /opt/nvim-linux-x86_64.
- Adds an alias to nvim in your ~/.bashrc and ~/.zshrc: alias nvim='/opt/nvim-linux-x86_64/bin/nvim'.
- Installs Node-based tooling globally: pyright, bash-language-server, tree-sitter-cli.
- Bootstraps lazy.nvim and clones/updates your Neovim config into ~/.config/nvim (https://github.com/kjtakke/neovim).
- Reloads your shell rc files and then execs Neovim.

Notes
- If you are on Linux Mint, snapd is unblocked and started automatically.
- You may need to start a new shell for pipx PATH changes to take effect; the script calls pipx ensurepath and reloads rc files where possible.
- The script is idempotent where practical: it checks for existing lazy.nvim, only appends the nvim alias if missing, and pulls your config if already a git repo.
- On environments without systemd/snap (e.g. some WSL setups), snap-related steps may fail; enable systemd in WSL or remove those sections before running.

### Linux Debian (apt)

```bash
# 1) Prerequisites
sudo apt update -y
sudo apt install -y git curl

# Mint only: unblock and enable snapd (for Tectonic)
sudo rm -f /etc/apt/preferences.d/nosnap.pref || true
sudo apt install -y snapd
sudo systemctl enable --now snapd.socket
sudo ln -sf /var/lib/snapd/snap /snap || true

# 2) Base tools
sudo apt install -y ripgrep pylint shellcheck xclip pipx cloc npm pandoc wkhtmltopdf

# 3) Tectonic (via snap; apt may also provide 'tectonic' on newer releases)
sudo snap install tectonic --classic || sudo apt install -y tectonic || true

# 4) Python tooling for Neovim
pipx ensurepath
pipx install --include-deps pynvim || true

# 5) Install Neovim (latest stable prebuilt tarball)
curl -L -o /tmp/nvim-linux-x86_64.tar.gz \
  https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim /opt/nvim-linux-x86_64 2>/dev/null || true
sudo tar -C /opt -xzf /tmp/nvim-linux-x86_64.tar.gz
rm -f /tmp/nvim-linux-x86_64.tar.gz
# Add alias (idempotent)
grep -q "/opt/nvim-linux-x86_64/bin/nvim" ~/.bashrc || \
  echo "alias nvim='/opt/nvim-linux-x86_64/bin/nvim'" >> ~/.bashrc
grep -q "/opt/nvim-linux-x86_64/bin/nvim" ~/.zshrc  || \
  echo "alias nvim='/opt/nvim-linux-x86_64/bin/nvim'" >> ~/.zshrc

# 6) Node-based tooling (LSPs, tree-sitter)
sudo npm install -g pyright bash-language-server tree-sitter-cli

# 7) Neovim plugin manager (lazy.nvim)
mkdir -p ~/.local/share/nvim/lazy
[ -d ~/.local/share/nvim/lazy/lazy.nvim ] || \
  git clone https://github.com/folke/lazy.nvim ~/.local/share/nvim/lazy/lazy.nvim

# 8) Neovim config
if [ -d ~/.config/nvim/.git ]; then
  git -C ~/.config/nvim pull --ff-only || true
else
  git clone https://github.com/kjtakke/neovim ~/.config/nvim
fi

# 9) Refresh shell and launch
[ -f ~/.bashrc ] && . ~/.bashrc || true
[ -f ~/.zshrc ]  && . ~/.zshrc  || true
nvim
```

### Linux Red Hat (yum/dnf)

```bash
# 1) Pick your package manager
PKG=$(command -v dnf || command -v yum)

# 2) Prerequisites and EPEL (RHEL/CentOS)
sudo "$PKG" -y install epel-release || true
sudo "$PKG" -y install git curl

# 3) Base tools
# Package names may vary slightly by distro release
sudo "$PKG" -y install neovim ripgrep shellcheck xclip cloc nodejs npm pandoc wkhtmltopdf || true
sudo "$PKG" -y install python3-pipx || sudo "$PKG" -y install pipx || true
sudo "$PKG" -y install python3-pylint || true

# 4) Tectonic (Fedora provides 'tectonic'; RHEL/CentOS may need cargo)
sudo "$PKG" -y install tectonic || true
# Fallback via Rust (optional):
# sudo "$PKG" -y install rust cargo && cargo install tectonic

# 5) Python tooling for Neovim
pipx ensurepath || true
pipx install --include-deps pynvim || true

# 6) Node-based tooling (LSPs, tree-sitter)
sudo npm install -g pyright bash-language-server tree-sitter-cli

# 7) Neovim plugin manager (lazy.nvim)
mkdir -p ~/.local/share/nvim/lazy
[ -d ~/.local/share/nvim/lazy/lazy.nvim ] || \
  git clone https://github.com/folke/lazy.nvim ~/.local/share/nvim/lazy/lazy.nvim

# 8) Neovim config
if [ -d ~/.config/nvim/.git ]; then
  git -C ~/.config/nvim pull --ff-only || true
else
  git clone https://github.com/kjtakke/neovim ~/.config/nvim
fi

# 9) Launch
nvim
```

### macOS (Homebrew)

```bash
# 1) Install Homebrew (if missing)
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)"
fi

# 2) Base tools
brew update
brew install neovim ripgrep shellcheck pipx cloc node pandoc wkhtmltopdf tectonic git

# 3) Python tooling for Neovim
pipx ensurepath
pipx install --include-deps pynvim || true

# 4) Node-based tooling (LSPs, tree-sitter)
npm install -g pyright bash-language-server tree-sitter-cli

# 5) Neovim plugin manager (lazy.nvim)
mkdir -p ~/.local/share/nvim/lazy
[ -d ~/.local/share/nvim/lazy/lazy.nvim ] || \
  git clone https://github.com/folke/lazy.nvim ~/.local/share/nvim/lazy/lazy.nvim

# 6) Neovim config
if [ -d ~/.config/nvim/.git ]; then
  git -C ~/.config/nvim pull --ff-only || true
else
  git clone https://github.com/kjtakke/neovim ~/.config/nvim
fi

# 7) Launch
nvim
```

### Windows (Chocolatey)

```powershell
# Run in an elevated PowerShell

# 1) Install Chocolatey (if missing)
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
  Set-ExecutionPolicy Bypass -Scope Process -Force
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# 2) Base tools
choco install -y git neovim ripgrep nodejs-lts pandoc wkhtmltopdf shellcheck cloc python

# 3) pipx
choco install -y pipx -y 2>$null
python -m pip install --user --upgrade pipx 2>$null

# 4) Ensure PATH for pipx and install pynvim
pipx ensurepath | Out-Null
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ';' + [System.Environment]::GetEnvironmentVariable("Path","User")
pipx install --include-deps pynvim | Out-Null

# 5) Node-based tooling (LSPs, tree-sitter)
npm install -g pyright bash-language-server tree-sitter-cli

# 6) Neovim plugin manager (lazy.nvim)
$lazyDir = Join-Path $env:LOCALAPPDATA 'nvim-data\lazy\lazy.nvim'
if (-not (Test-Path $lazyDir)) { git clone https://github.com/folke/lazy.nvim $lazyDir }

# 7) Neovim config
$nvimConf = Join-Path $env:LOCALAPPDATA 'nvim'
if (Test-Path (Join-Path $nvimConf '.git')) {
  git -C $nvimConf pull --ff-only
} else {
  if (-not (Test-Path $nvimConf)) { New-Item -ItemType Directory -Path $nvimConf | Out-Null }
  git clone https://github.com/kjtakke/neovim $nvimConf
}

# 8) Launch
nvim
```

### Linux Arch (pacman)

```bash
# 1) Update and install base tools
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm git curl neovim ripgrep shellcheck xclip python-pipx cloc nodejs npm pandoc wkhtmltopdf tectonic python-pylint

# 2) Python tooling for Neovim
pipx ensurepath
pipx install --include-deps pynvim || true

# 3) Node-based tooling (LSPs, tree-sitter)
sudo npm install -g pyright bash-language-server tree-sitter-cli

# 4) Neovim plugin manager (lazy.nvim)
mkdir -p ~/.local/share/nvim/lazy
[ -d ~/.local/share/nvim/lazy/lazy.nvim ] || \
  git clone https://github.com/folke/lazy.nvim ~/.local/share/nvim/lazy/lazy.nvim

# 5) Neovim config
if [ -d ~/.config/nvim/.git ]; then
  git -C ~/.config/nvim pull --ff-only || true
else
  git clone https://github.com/kjtakke/neovim ~/.config/nvim
fi

# 6) Launch
nvim

* * *
## Directory Structure

### Root Directory: `~/.config/nvim`

- **init.lua**  
    The main entry point for Neovim’s configuration. This file requires other configuration modules, sets up the runtime path, and initialises all settings, plugins, and custom logic.

* * *

### `lua/` – Core Lua Configuration Files

Contains reusable Lua modules and subdirectories that handle various aspects of Neovim’s behaviour.

#### `utils.lua`

Utility functions used throughout the configuration. Common helper functions are stored here to avoid repetition and centralise logic.

* * *

### `lua/config/` – Core Neovim Behaviour Configuration

- **options.lua**  
    Sets general Neovim options, such as line numbering, indentation rules, mouse support, and clipboard behaviour.
    
- **appearance.lua**  
    Configures the visual presentation of Neovim, including colour schemes, status lines, and theme integration.
    
- **autocmds.lua**  
    Defines auto commands to automate tasks such as reloading files, highlighting yanks, and applying file-type specific behaviour.
    
- **keymaps.lua**  
    Contains all keybinding definitions, including the AI UI keymap that integrates the custom AI interface module. This ensures user-defined mappings are grouped in a single place for maintainability.
    

* * *

### `lua/plugins/` – Plugin Management and Configuration

- **init.lua**  
    Loads and initialises the Lazy.nvim plugin manager, specifying which plugin specification files should be used.
    
- **spec.lua**  
    Lists all plugins to be installed, including their configuration loading paths and any conditional loading rules.
    
- **cfg/** – Plugin-specific configuration files. Each file is dedicated to configuring a single plugin:
    
    - `catppuccin.lua` – Catppuccin theme configuration.
        
    - `cmp.lua` – Completion framework setup.
        
    - `lualine.lua` – Statusline configuration.
        
    - `markdown_preview.lua` – Markdown preview integration.
        
    - `mason.lua` – Package manager for LSP servers, linters, and formatters.
        
    - `mason_lspconfig.lua` – Mason LSP configuration integration.
        
    - `telescope.lua` – Telescope fuzzy finder setup.
        
    - `todo_comments.lua` – Highlight and manage TODO, FIXME, and other comment tags.
        
    - `treesitter.lua` – Syntax highlighting and parsing via Tree-sitter.
        
    - `nvim_tree.lua` – File explorer integration.
        

* * *

### `lua/custom/` – Custom Utilities and Extensions

- **ai_ui.lua**  
    The AI-assisted interface module.  
    This script creates a dual-pane popup interface in Neovim to interact with an AI API running locally on `http://localhost:5001`.  
    Features include:
    
    - Opening a question buffer and an answer buffer in floating windows.
        
    - Sending a question to the AI API and receiving responses.
        
    - Clearing conversation history.
        
    - Toggling the visibility of the question buffer.
        
    - Loading AI conversation history from the API.
        
    - Inserting content from the previously active buffer into the question buffer.
        
    - Listing available AI models and changing the active model.
        
    
    **Integration with Keymaps**  
    The keybinding to open the AI UI is defined in `lua/config/keymaps.lua` and calls `require("custom.ai_ui").set_last_buf()` followed by `require("custom.ai_ui").open_ui()`.
    
- **lint.lua**  
    Custom linting logic and configuration.
    
- **spell.lua**  
    Spell-checking customisations and additional dictionary settings.
    
- **telescope_extras.lua**  
    Extended Telescope commands and search functionality.
    
- **nsearch.lua**  
    Alternative search implementations and enhancements.
    
- **cursor.lua**  
    Custom cursor movement and highlighting logic.
    
- **multicursor.lua**  
    Multiple cursor simulation and manipulation functionality.
    

* * *

### `spell/` – Spellchecking Data

- **en.utf-8.add**  
    User-added dictionary words for spellchecking. Automatically created if it does not exist.

* * *

## AI UI Module Workflow

The AI UI module (`ai_ui.lua`) is a local Neovim interface for interacting with an AI assistant via REST endpoints.

**Supported Commands**:

- **Open UI** – Creates a floating question box and answer box.
    
- **Submit Question** – Sends text from the question box to the AI server and displays the response.
    
- **Clear Chat** – Clears both local buffers and server history.
    
- **Insert Current File** – Appends the contents of the last active buffer to the question box.
    
- **Toggle Question Box** – Hides or restores the question window to focus on answers.
    
- **Load History** – Loads past conversations from the AI server.
    
- **Show Models** – Displays available AI models.
    
- **Change Model** – Switches the AI model in use.
    

**Backend Requirements**:

- API endpoints provided at:
    
    - `POST /ask` – Send a question.
        
    - `POST /clear_assistant` – Clear conversation history.
        
    - `GET /history` – Retrieve conversation history.
        
    - `GET /list_models` – Retrieve available models.
        
    - `POST /change_model` – Switch the active AI model.
        

* * *

## Installation Steps

1.  Clone the repository:  
    `git clone https://github.com/kjtakke/neovim ~/.config/nvim`
    
2.  Install dependencies:
    
    - `ripgrep` for live grep searches.
        
    - `pylint` and `shellcheck` for linting.
        
    - Node.js and npm for language servers.
        
    - Python `pipx` with `pynvim` for Python integration.
        
    - Optional: `tectonic` for LaTeX-based PDF exports via Pandoc.
        
3.  Launch Neovim:  
    Run `nvim` to allow Lazy.nvim to install plugins.
    

* * *

## Customisation Guidelines

- All Neovim-specific behaviour should be placed in `lua/config/`.
    
- Plugin-specific settings must be in `lua/plugins/cfg/`.
    
- New custom tools or utilities should be placed under `lua/custom/` with their logic fully encapsulated.
    
- Keymaps should reference modules using `require("custom.module_name")` to maintain a clear namespace.
