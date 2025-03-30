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
git clone https://github.com/kjtakke/neovim.git ~/nvim-clone
sudo apt install npm -y
sudo npm install -g pyright
sudo npm install -g bash-language-server
mkdir -p ~/.config/nvim
mkdir -p ~/.config/nvim/lua
mkdir -p ~/.config/nvim/lua/plugins
git clone https://github.com/kjtakke/neovim/_git/neovim
cp -f ~/nvim-clone/init.lua ~/.config/nvim/init.lua
cp -f ~/nvim-clone/lazy-lock.json ~/.config/nvim/lazy-lock.json
cp -f ~/nvim-clone/lua/cmp.lua.bak ~/.config/nvim/lua/cmp.lua.bak
cp -f ~/nvim-clone/lua/init.lua ~/.config/nvim/lua/init.lua
cp -f ~/nvim-clone/lua/lsp.lua ~/.config/nvim/lua/lsp.lua
cp -f ~/nvim-clone/lua/plugins/init.lua ~/.config/nvim/lua/plugins/init.lua
rm -rf ~/nvim-clone

```

# Commands
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

##### You said:

a table of all the standard neovim commands

###### ChatGPT said:

Here’s a comprehensive table of **standard Neovim commands**, broken down by category for easier reference. This includes **normal mode**, **command-line mode**, and **common ex commands**.

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

Would you like this as a downloadable cheat sheet, or shall I include plugin/mapping info as well?

##### You said:

how do I have multiple tabs and what are teh commands

###### ChatGPT said:

In **Neovim**, you can open and manage **multiple tabs** using **tab pages**, which are essentially collections of windows (splits). Each tab can have its own layout of splits, buffers, etc.

Here’s a handy table of all the standard **tab commands**:

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
    

Would you like key mappings to make tab switching even faster (e.g., `<Leader>tn` for next tab)?

##### You said:

what about spliting tabs to have multiple windos and terminal

###### ChatGPT said:

Absolutely! In **Neovim**, you can split tabs into **multiple windows**, and even open **terminals** within those splits. Here's how it all works:

* * *

### 🪟 **Splitting Windows (in a Tab)**

| Command | Description |
| --- | --- |
| `:split` / `:sp` | Horizontal split (same file) |
| `:vsplit` / `:vsp` | Vertical split (same file) |
| `:split <file>` | Horizontal split and open file |
| `:vsplit <file>` | Vertical split and open file |

You can also use these in combination, e.g.:

vim

CopyEdit

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

Would you like a keybinding setup to streamline these actions (e.g., shortcuts for split + terminal)?

##### You said:

quit without saving changes

###### ChatGPT said:

To **quit Neovim without saving changes**, use:

less

CopyEdit

`:q!`

This force-quits the current window or tab, **discarding any unsaved changes**.

* * *

### Additional Variants:

| Command | Description |
| --- | --- |
| `:q!` | Quit current window without saving |
| `:qa!` | Quit **all** windows and tabs, no saves |
| `ZQ` | Same as `:q!` (shorthand from normal mode) |

Let me know if you’d like a full "save & quit" cheat sheet too.

##### You said:

open file by path :open ~/.bashrc

###### ChatGPT said:

In **Neovim**, to open a file by its path, including hidden files like `~/.bashrc`, you should **use `:edit` instead of `:open`**:

bash

CopyEdit

`:e ~/.bashrc`

or

bash

CopyEdit

`:edit ~/.bashrc`

### Why not `:open`?

- `:open` is a legacy Vim command and not commonly used.
    
- `:e` is the modern and recommended way to open files by path.
    

* * *

### Handy Notes:

- Use tab completion:  
    Type `:e ~/.ba<Tab>` to auto-complete `.bashrc`.
    
- To reload the file (discard changes):
    
    ruby
    
    CopyEdit
    
    `:e!`
    

Let me know if you want a shortcut or mapping to quickly open config files like `.vimrc`, `.bashrc`, etc.

##### You said:

how to name a tab

###### ChatGPT said:

In **Neovim**, there isn’t a built-in command to "name" a tab like you would in a browser. Tabs in Neovim represent layouts of windows (splits), and their labels are usually just the filenames of the buffers they contain.

However, you can **simulate named tabs** using a few tricks:

* * *

### 🧠 Option 1: Use a Scratch Buffer with a Title

You can open a new tab and create a buffer with a title, like so:

vim

CopyEdit

`:tabnew:enew | file [MyTabName]:setlocal buftype=nofile bufhidden=hide noswapfile`

This creates an empty, non-file buffer named `[MyTabName]`, which appears in the tab label.

* * *

### 🛠 Option 2: Use a Plugin (Recommended)

For easier tab naming and more functionality, consider using a plugin:

#### 🔹 [vim-taboo](https://github.com/gcmt/taboo.vim)

Lets you name and persist tab names:

vim

CopyEdit

`:TabooRename MyTabName`

#### 🔹 [barbar.nvim](https://github.com/romgrk/barbar.nvim)

A beautiful tabline/bufferline plugin that can show file names and icons — great for workflow.

* * *

### 💡 Extra Tip: Rename Buffers (Affects Tab Title)

Renaming the buffer also affects what appears in the tab title:

vim

CopyEdit

`:saveas MyTabName.txt`

Or for scratch buffers:

vim

CopyEdit

`:file MyTabName`

* * *

Would you like me to set up a Lua config snippet for one of these tabline plugins?

##### You said:

can I run a bash comand on a current file dir liek the below as an intent i e i' in a file and I want to run: :term tail myfile.txt

###### ChatGPT said:

Yes, absolutely! You can run a **bash command in the current file’s directory** using Neovim’s `:terminal` (or `:term`) command, and you can dynamically reference the current file’s path.

Here’s how to do what you described:

* * *

### ✅ Run a terminal command from the current file’s directory

If you're editing a file (say, `~/projects/logs/myfile.txt`), and you want to `tail` that file **from its directory**, use:

vim

CopyEdit

`:term cd %:p:h && tail %:t`

#### 🧠 Explanation:

- `%` → current file's path
    
- `%:p` → full path
    
- `%:p:h` → head (directory of the file)
    
- `%:t` → tail (filename only)
    
- `cd %:p:h` → change into the file’s directory
    
- `tail %:t` → run `tail` on the file
    

* * *

### 💡 Examples:

vim

CopyEdit

`:term cd %:p:h && ls -lah:term cd %:p:h && grep "error" %:t:term cd %:p:h && python3 %:t`

* * *

### 🪄 Mapping it for quick use (optional)

To make this easier, you can map a command in your `init.vim` or Lua config (let me know which you're using). For example:

vim

CopyEdit

`command! TailHere term cd %:p:h && tail %:t`

Then in Neovim, just run:

vim

CopyEdit

`:TailHere`

Want help mapping this to a keybinding or adding a few more handy terminal commands?

4o

##### You said:

in a table plese out line

###### ChatGPT said:

Certainly! Here's a **Neovim terminal command reference table** for running bash commands relative to the **current file’s directory**:

* * *

### 🧰 **Neovim Terminal Command Cheatsheet (Relative to Current File)**

| Command | Description |
| --- | --- |
| `:term cd %:p:h && tail %:t` | Open terminal, change to current file's directory, and `tail` the file |
| `:term cd %:p:h && ls -lah` | List all files in the file’s directory with details |
| `:term cd %:p:h && grep "search" %:t` | Search for "search" term inside the current file |
| `:term cd %:p:h && python3 %:t` | Run the current file with Python 3 |
| `:term cd %:p:h && bash %:t` | Run the file as a bash script |
| `:term cd %:p:h && ./run.sh` | Run a script named `run.sh` in the current file’s directory |
| `:term cd %:p:h && git status` | Show git status for the current file’s directory |
| `:term cd %:p:h` | Just open terminal in the current file’s directory (idle shell) |

* * *

### 🧠 **Format Reference**

| Placeholder | Meaning |
| --- | --- |
| `%` | Current file’s relative path |
| `%:p` | Full path to current file |
| `%:p:h` | Head: directory of current file |
| `%:t` | Tail: just the filename |
|     |     |
