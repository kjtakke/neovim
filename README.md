# NeoVim Installation and Usage Guide
> Run all in bash not zsh
`git clone https://github.com/kjtakke/neovim.git && bash neovim/install.sh && rm -rf neovim`
> - Close Terminal Session
> - Reopen Termina
> - `nvim`
> - `:Lazy` (If not automated)
> - `Shtif + U` to update plugins

This comprehensive guide provides detailed instructions for installing NeoVim, configuring it with plugins, and an extensive list of commands for proficient usage. Adhering to software engineering principles, this document aims to be clear, concise, and structured for ease of understanding and implementation.

## NeoVim Installation Instructions

### Prerequisites

Ensure you have the following prerequisites met before proceeding with the installation:

- A Unix-like operating system (e.g., Linux, macOS)
- `sudo` privileges for installation

### Installation Steps

To install NeoVim and set up the necessary plugins and configurations, execute the following script in your terminal:

```bash
# Update package lists
sudo apt update

#Install Live Grep
sudo apt install ripgrep pylint

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
cp -f ~/nvim-clone/lazy-lock.json ~/.config/nvim/lazy-lock.json
cp -f ~/nvim-clone/lua/cmp.lua.bak ~/.config/nvim/lua/cmp.lua.bak
cp -f ~/nvim-clone/lua/init.lua ~/.config/nvim/lua/init.lua
cp -f ~/nvim-clone/lua/lsp.lua ~/.config/nvim/lua/lsp.lua
cp -f ~/nvim-clone/lua/plugins/init.lua ~/.config/nvim/lua/plugins/init.lua

# Remove temporary clone directory
rm -rf ~/nvim-clone

# Launch NeoVim
nvim
```

### Installing Plugins

Once NeoVim is launched, you can install plugins using the `Lazy` plugin manager:

- Open NeoVim (`nvim` in your terminal).
- Enter the command mode by pressing `:`.
- Type `Lazy` and press Enter to open the plugin manager.
- Use `Shift + I` to install all plugins.
- Use `Shift + U` to update all plugins.

## Update Script

To update your NeoVim configuration, execute the following script in your terminal:

```bash
# Clone the latest configuration
git clone https://github.com/kjtakke/neovim.git ~/nvim-clone

# Update configuration files
cp -f ~/nvim-clone/init.lua ~/.config/nvim/init.lua
cp -f ~/nvim-clone/lazy-lock.json ~/.config/nvim/lazy-lock.json
cp -f ~/nvim-clone/lua/cmp.lua.bak ~/.config/nvim/lua/cmp.lua.bak
cp -f ~/nvim-clone/lua/init.lua ~/.config/nvim/lua/init.lua
cp -f ~/nvim-clone/lua/lsp.lua ~/.config/nvim/lua/lsp.lua
cp -f ~/nvim-clone/lua/plugins/init.lua ~/.config/nvim/lua/plugins/init.lua

# Remove temporary clone directory
rm -rf ~/nvim-clone

# Launch NeoVim to apply changes
nvim
```

## NeoVim Command Reference

Below is a comprehensive list of NeoVim commands categorised by functionality. These commands adhere to the principle of least astonishment, ensuring intuitive and consistent user interactions.

### 🧭 **Navigation**

| Command | Description |
| --- | --- |
| `h` | Move left |
| `j` | Move down |
| `k` | Move up |
| `l` | Move right |
| `gg` | Go to beginning of file |
| `G` | Go to end of file |
| `0` | Move to beginning of line |
| `^` | Move to first non-blank character |
| `$` | Move to end of line |
| `w` | Move to beginning of next word |
| `b` | Move to beginning of previous word |
| `}` | Move to next paragraph |
| `{` | Move to previous paragraph |
| `%` | Jump between matching brackets |

### ✍️ **Editing**

| Command | Description |
| --- | --- |
| `i` | Insert before cursor |
| `I` | Insert at beginning of line |
| `a` | Append after cursor |
| `A` | Append at end of line |
| `o` | Open new line below |
| `O` | Open new line above |
| `r<char>` | Replace single character |
| `R` | Enter replace mode |
| `s` | Delete character and insert |
| `cc` | Change whole line |
| `cw` | Change word |
| `C` | Change to end of line |
| `J` | Join lines |

### ✍️ **Select**

| Command | Description |
| --- | --- |
| `v` | Start visual mode |
| `V` | Start visual line mode |
| `Ctrl-v` | Start visual block mode |
| `viw` | Select inner word |
| `vaw` | Select word with whitespace |
| `Ctrl + Up/Down Arrow` | Multi-cursor select next line |
| `Ctrl + N` | Multi-cursor select next occurrence |
| `*` | Find highlighted word |
| `n` | Next occurrence |
| `N` | Previous occurrence |

### 🔁 **Undo/Redo**

| Command | Description |
| --- | --- |
| `u` | Undo last change |
| `Ctrl-r` | Redo last undone change |
| `U` | Undo all changes on current line |

### 🗂️ **File & Buffer**

| Command | Description |
| --- | --- |
| `:e <file>` | Open/edit file |
| `:w` | Save file |
| `:w <file>` | Save as another file |
| `:q` | Quit |
| `:q!` | Quit without saving |
| `:wq` / `ZZ` | Save and quit |
| `:x` | Like `:wq`, write if changes made |
| `:bn` | Next buffer |
| `:bp` | Previous buffer |
| `:bd` | Delete buffer |
| `:ls` / `:buffers` | List buffers |
| `\x` | New scratch file |

### 🔎 **Search**

| Command | Description |
| --- | --- |
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Repeat search in same direction |
| `N` | Repeat search in opposite direction |
| `*` | Search for word under cursor (forward) |
| `#` | Search for word under cursor (backward) |

### 🧹 **Delete/Yank/Put**

| Command | Description |
| --- | --- |
| `x` | Delete character under cursor |
| `dd` | Delete current line |
| `dw` | Delete word |
| `d$` | Delete to end of line |
| `yy` | Yank (copy) current line |
| `yw` | Yank word |
| `p` | Paste after cursor |
| `P` | Paste before cursor |

### 📐 **Visual Mode**

| Command | Description |
| --- | --- |
| `v` | Start visual mode |
| `V` | Start visual line mode |
| `Ctrl-v` | Start visual block mode |
| `y` | Yank selection |
| `d` | Delete selection |
| `>` | Indent selection |
| `<` | Un-indent selection |

### ⌨️ **Command-Line Mode (`:`)**

| Command | Description |
| --- | --- |
| `:help <topic>` | Open help documentation |
| `:set <option>` | Set an option (e.g., `:set number`) |
| `:!<command>` | Run shell command |
| `:syntax on` | Enable syntax highlighting |
| `:noh` | Clear search highlights |

### 🧷 **Basic Tab Commands**

| Command | Description |
| --- | --- |
| `:tabnew` | Open a new tab |
| `:tabnew <file>` | Open a file in a new tab |
| `:tabclose` | Close the current tab |
| `:tabonly` | Close all other tabs |
| `:tabs` | List all tabs and their contents |

### 🔁 **Navigating Tabs**

| Command | Description |
| --- | --- |
| `gt` or `:tabn` | Go to next tab |
| `gT` or `:tabp` | Go to previous tab |
| `:tabfirst` | Go to the first tab |
| `:tablast` | Go to the last tab |
| `:tabnext <N>` | Go to tab number N |

### 🎯 **Moving Tabs**

| Command | Description |
| --- | --- |
| `:tabmove <N>` | Move current tab to position N (0-indexed) |

### 🪟 **Splitting Windows (in a Tab)**

| Command | Description |
| --- | --- |
| `:split` / `:sp` | Horizontal split (same file) |
| `:vsplit` / `:vsp` | Vertical split (same file) |
| `:split <file>` | Horizontal split and open file |
| `:vsplit <file>` | Vertical split and open file |
| `/n` | vsplit new scratch file to the right |

You can also use these in combination, e.g., `:vsp myfile.txt`.

### ↔️ **Navigating Between Splits**

| Command | Description |
| --- | --- |
| `Ctrl-w h` | Move to split left |
| `Ctrl-w j` | Move to split below |
| `Ctrl-w k` | Move to split above |
| `Ctrl-w l` | Move to split right |
| `Ctrl-w w` | Cycle to the next window |
| `Ctrl-w q` | Quit a split |

### 📏 **Resizing Splits**

| Command | Description |
| --- | --- |
| `Ctrl-w >` | Increase width (vertical split) |
| `Ctrl-w <` | Decrease width |
| `Ctrl-w +` | Increase height (horizontal split) |
| `Ctrl-w -` | Decrease height |
| `Ctrl-w =` | Equalise all splits |

### 🖥️ **Opening Terminals in Splits**

| Command | Description |
| --- | --- |
| `:terminal` | Open terminal in current split |
| `:split | terminal` | Open terminal in a new horizontal split |
| `:vsplit | terminal` | Open terminal in a new vertical split |

Once in a terminal:

- Press `Ctrl-\ Ctrl-n` to exit terminal **insert mode** and return to normal mode.
- Use `i` or `a` to go back into terminal input mode.

### 🧼 **Closing Splits and Tabs**

| Command | Description |
| --- | --- |
| `:q` | Close current window/split |
| `:qa` | Quit all tabs and windows |
| `:tabclose` | Close current tab |

### ✍️ **Multi Line Editing**

| Command | Description |
| --- | --- |
| `Ctrl-n` | Select word under cursor & add next matches |
| `n` / `N` | Add next / previous match |
| `Ctrl-Up` / `Ctrl-Down` | Add cursors above / below |
| `Esc` | Exit multi-cursor mode |
| `Ctrl-n` | Start multi-cursor with current word |
| `Ctrl-p` | Skip current match and go to next |
| `Ctrl-x` | Remove current cursor/match |
| `Esc` | Exit multi-cursor mode |

### 🖥️ **Tips**

- **Tabs vs. Buffers**: Tabs are not buffers; each tab can contain multiple splits, each with its own buffer.
- **Combining with Splits**: You can combine tabs and splits, e.g., `:tabnew | split` gives you a split in a new tab.
- **Showing Tabs**: To keep tabs visible, set `set showtabline=2` in your configuration to always show the tabline.

By following this guide, you should be well-equipped to install, configure, and use NeoVim effectively. Remember to refer back to these instructions and command references as needed to enhance your productivity and proficiency with NeoVim.
```
