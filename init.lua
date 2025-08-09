-- Speed up Lua module loading (Neovim 0.9+)
pcall(vim.loader.enable)

-- Core options/appearance first
require("config.options")
require("config.appearance")

-- Utilities (safe require, etc.)
require("utils")

-- Plugins (lazy.nvim bootstrap + setup)
require("plugins")

-- After plugins: keymaps & autocmds (some depend on plugins)
require("config.keymaps")
require("config.autocmds")

-- Custom user utilities (linting, spell helpers, extra Telescope, search, cursor & multicursor)
require("custom.lint")
require("custom.spell")
require("custom.telescope_extras")
require("custom.nsearch")
require("custom.cursor")
require("custom.multicursor")
require("custom.pandoc")
require("custom.docx_md")
require("custom.ai_ui")

