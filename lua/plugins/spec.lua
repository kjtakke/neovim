local sr = require("utils").safe_require

return {
-- GO FORMATTING (none-ls)
{
  "nvimtools/none-ls.nvim",
  ft = { "go", "gomod", "gowork" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls") -- module name stays "null-ls" in none-ls
    local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.goimports_reviser, -- <-- built-in, no extras needed
        null_ls.builtins.formatting.golines,
      },
      on_attach = function(client, bufnr)
        if client.server_capabilities
          and client.server_capabilities.documentFormattingProvider
        then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                bufnr = bufnr,
                filter = function(c) return c.name == "null-ls" end,
              })
            end,
          })
        end
      end,
    })
  end,
}
,
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
  {
  "jay-babu/mason-null-ls.nvim",
  dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
  opts = {
    ensure_installed = { "gofumpt", "goimports-reviser", "golines" },
    automatic_installation = true,
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

-- lua/plugins/spec.lua
{
  "nvim-lua/plenary.nvim",
  lazy = false,
  config = function()
    local ok, mod = pcall(require, "plugins.cfg.file_stats")
    if ok and type(mod.setup) == "function" then
      mod.setup()
    else
      vim.notify("plugins.cfg.file_stats not found or has no setup()", vim.log.levels.WARN)
    end
  end,
},



}

