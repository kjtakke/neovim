## NeoVim Installation Instructions
> Install Plugins: `nvim` => :`Lazy` => `Shift + I` => `Shift + U`

## Install Script

```bash
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
nvim
```
## Update Script
```bash
git clone https://github.com/kjtakke/neovim.git ~/nvim-clone
cp -f ~/nvim-clone/init.lua ~/.config/nvim/init.lua
cp -f ~/nvim-clone/lazy-lock.json ~/.config/nvim/lazy-lock.json
cp -f ~/nvim-clone/lua/cmp.lua.bak ~/.config/nvim/lua/cmp.lua.bak
cp -f ~/nvim-clone/lua/init.lua ~/.config/nvim/lua/init.lua
cp -f ~/nvim-clone/lua/lsp.lua ~/.config/nvim/lua/lsp.lua
cp -f ~/nvim-clone/lua/plugins/init.lua ~/.config/nvim/lua/plugins/init.lua
rm -rf ~/nvim-clone
nvim
```
### 🧭 **Navigation**

| Command | Description |
| --- | --- |
| `h` | Move left |
| `l` | Move right |
| `j` | Move down |
| `k` | Move up |
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

* * *

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
| `fg` | Live Grep |
| `ff` | File Grep |
| `zc` | Collapse Code |
| `zo` | Open Code |
| `:%s/# Build/## Build/g` | Find and Replace |
| `Shift + V` | Select (Multi Line) |
| `gc` | Toggle Comment on highlighted lines |
| `za` | Toggle fold at the cursor |
| `zc` | Close fold at the cursor |
| `zo` | Open fold at the cursor |
| `zm` | Close more folds (increase level) |
| `zr` | Open more folds (reduce level) |
| `zM` | Close all folds in module |
| `zR` | Opens all folds in module |

* * *

### ✍️ **Select**

| Command | Description |
| --- | --- |
| `v` | Select |
| `viw` | Select Inner Word |
| `vaw` | Select word with white space |
| `CtrL + U/D Arrow` | Multi Cursor select next Line |
| `CtrL + N` | Multi Cursor select next occurrence |
| `*` | Find Highlighted Word |
| `n` | Next Occurrence |
| `N` | Previous Occurrence |

* * *

### 🔁 **Undo/Redo**

| Command | Description |
| --- | --- |
| `u` | Undo last change |
| `Ctrl-r` | Redo last undone change |
| `U` | Undo all changes on current line |

* * *

### 🗂️ **File & Buffer**

| Command | Description |
| --- | --- |
| `:e <file>` | Open/edit file |
| `:w` | Save file |
| `:w <file>` | Save as another file |
| `:q` | Quit |
| `:qall!` | Quit (Kill all Processes) |
| `:q!` | Quit without saving |
| `:wq` / `ZZ` | Save and quit |
| `:x` | Like `:wq`, write if changes made |
| `:bn` | Next buffer |
| `:bp` | Previous buffer |
| `:bd` | Delete buffer |
| `:ls` / `:buffers` | List buffers |
| `\x` | New Scratch File |

* * *

### 🔎 **Search**

| Command | Description |
| --- | --- |
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Repeat search in same direction |
| `N` | Repeat search in opposite direction |
| `*` | Search for word under cursor (forward) |
| `#` | Search for word under cursor (backward) |

* * *

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

* * *

### 📐 **Visual Mode**

| Command | Description |
| --- | --- |
| `v` | Start visual mode |
| `V` | Start visual line mode |
| `Ctrl-v` | Start visual block mode |
| `y` | Yank selection |
| `d` | Delete selection |
| `>` / `<` | Indent / un-indent selection |

* * *

### ⌨️ **Command-Line Mode (`:`)**

| Command | Description |
| --- | --- |
| `:help <topic>` | Open help documentation |
| `:set <option>` | Set an option (e.g., `:set number`) |
| `:!<command>` | Run shell command |
| `:syntax on` | Enable syntax highlighting |
| `:noh` | Clear search highlights |

&nbsp;

### 🧷 **Basic Tab Commands**

| Command | Description |
| --- | --- |
| `:tabnew` | Open a new tab |
| `:tabnew <file>` | Open a file in a new tab |
| `:tabclose` | Close the current tab |
| `:tabonly` | Close all other tabs |
| `:tabs` | List all tabs and their contents |

* * *

### 🔁 **Navigating Tabs**

| Command | Description |
| --- | --- |
| `gt` or `:tabn` | Go to next tab |
| `gT` or `:tabp` | Go to previous tab |
| `:tabfirst` | Go to the first tab |
| `:tablast` | Go to the last tab |
| `:tabnext <N>` | Go to tab number N |

* * *

### 🎯 **Moving Tabs**

| Command | Description |
| --- | --- |
| `:tabmove <N>` | Move current tab to position N (0-indexed) |

&nbsp;

### 🪟 **Splitting Windows (in a Tab)**

| Command | Description |
| --- | --- |
| `:split` / `:sp` | Horizontal split (same file) |
| `:vsplit` / `:vsp` | Vertical split (same file) |
| `:split <file>` | Horizontal split and open file |
| `:vsplit <file>` | Vertical split and open file |
| `/n` | vsplit new scratch file to the right |

You can also use these in combination, e.g.:

`:vsp myfile.txt`

* * *

### ↔️ **Navigating Between Splits**

| Command | Description |
| --- | --- |
| `Ctrl-w h` | Move to split left |
| `Ctrl-w l` | Move to split right |
| `Ctrl-w j` | Move to split below |
| `Ctrl-w k` | Move to split above |
| `Ctrl-w w` | Cycle to the next window |
| `Ctrl-w q` | Quit a split |

* * *

### 📏 **Resizing Splits**

| Command | Description |
| --- | --- |
| `Ctrl-w >` | Increase width (vertical split) |
| `Ctrl-w <` | Decrease width |
| `Ctrl-w +` | Increase height (horizontal split) |
| `Ctrl-w -` | Decrease height |
| `Ctrl-w =` | Equalise all splits |

* * *

### 🖥️ **Opening Terminals in Splits**

| Command | Description |
| --- | --- |
| `:terminal` | Open terminal in current split |
| \`:split | terminal\` |
| \`:vsplit | terminal\` |

Once in a terminal:

- Press `Ctrl-\ Ctrl-n` to exit terminal **insert mode** and return to normal mode.
    
- Use `i` or `a` to go back into terminal input mode.
    

* * *

### 🧼 **Closing Splits and Tabs**

| Command | Description |
| --- | --- |
| `:q` | Close current window/split |
| `:qa` | Quit all tabs and windows |
| `:tabclose` | Close current tab |

* * *

### 🧭 **Navigation**

| Command | Description |
| --- | --- |
| `h` | Move left |
| `l` | Move right |
| `j` | Move down |
| `k` | Move up |
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
| `fg` | From terminal reload session |

* * *

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

* * *

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

### 🔁 **Undo/Redo**

| Command | Description |
| --- | --- |
| `u` | Undo last change |
| `Ctrl-r` | Redo last undone change |
| `U` | Undo all changes on current line |

* * *

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

* * *

### 🔎 **Search**

| Command | Description |
| --- | --- |
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Repeat search in same direction |
| `N` | Repeat search in opposite direction |
| `*` | Search for word under cursor (forward) |
| `#` | Search for word under cursor (backward) |

* * *

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

* * *

### 📐 **Visual Mode**

| Command | Description |
| --- | --- |
| `v` | Start visual mode |
| `V` | Start visual line mode |
| `Ctrl-v` | Start visual block mode |
| `y` | Yank selection |
| `d` | Delete selection |
| `>` / `<` | Indent / un-indent selection |

* * *

### ⌨️ **Command-Line Mode (`:`)**

| Command | Description |
| --- | --- |
| `:help <topic>` | Open help documentation |
| `:set <option>` | Set an option (e.g., `:set number`) |
| `:!<command>` | Run shell command |
| `:syntax on` | Enable syntax highlighting |
| `:noh` | Clear search highlights |

* * *

### 🧷 **Basic Tab Commands**

| Command | Description |
| --- | --- |
| `:tabnew` | Open a new tab |
| `:tabnew <file>` | Open a file in a new tab |
| `:tabclose` | Close the current tab |
| `:tabonly` | Close all other tabs |
| `:tabs` | List all tabs and their contents |

* * *

### 🔁 **Navigating Tabs**

| Command | Description |
| --- | --- |
| `gt` or `:tabn` | Go to next tab |
| `gT` or `:tabp` | Go to previous tab |
| `:tabfirst` | Go to the first tab |
| `:tablast` | Go to the last tab |
| `:tabnext <N>` | Go to tab number N |

* * *

### 🎯 **Moving Tabs**

| Command | Description |
| --- | --- |
| `:tabmove <N>` | Move current tab to position N (0-indexed) |

* * *

### 🖥️ **Tips**

- Tabs are not buffers: each tab can contain multiple splits, each with its own buffer.
    
- Combine with splits: e.g., `:tabnew | split` gives you a split in a new tab.
    
- To keep tabs visible: you might want to set `set showtabline=2` in your config to always show the tabline.
    
