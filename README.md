# Neovim Configuration – Detailed Project Documentation

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
