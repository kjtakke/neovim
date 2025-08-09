local sr = require("utils").safe_require

return {

  -- TODO comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    config = function() require("plugins.cfg.todo_comments") end,
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO/FIX/WARN" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev TODO/FIX/WARN" },
      { "<leader>td", "<cmd>TodoTelescope<cr>", desc = "Todos (Telescope)" },
      { "<leader>tq", "<cmd>TodoQuickFix<cr>",  desc = "Todos → Quickfix" },
      { "<leader>tl", "<cmd>TodoLocList<cr>",   desc = "Todos → Loclist" },
      { "<leader>tt", "<cmd>TodoTrouble<cr>",   desc = "Todos (Trouble)" },
    },
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = "cd app && npm install",
    config = function() require("plugins.cfg.markdown_preview") end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview (HTTP)" },
    },
  },

  -- Colourscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function() require("plugins.cfg.catppuccin") end,
  },

  -- Copilot
  { "github/copilot.vim", lazy = false },

  -- Multi-cursor (we also have custom config/mappings)
  { "mg979/vim-visual-multi", branch = "master" },

  -- LSP / Mason / Completion
  { "neovim/nvim-lspconfig" },

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function() require("plugins.cfg.mason") end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function() require("plugins.cfg.mason_lspconfig") end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function() require("plugins.cfg.cmp") end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function() require("plugins.cfg.treesitter") end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("plugins.cfg.nvim_tree") end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("plugins.cfg.telescope") end,
  },

  -- UI niceties
  { "nvim-lualine/lualine.nvim", config = function() require("plugins.cfg.lualine") end },
  { "lewis6991/gitsigns.nvim",  config = true },
  { "windwp/nvim-autopairs",    config = true },
  { "numToStr/Comment.nvim",    config = true },
}

