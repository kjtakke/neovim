require("lazy").setup({
  -- Theme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  -- LSP and Completion
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- File Explorer (only once!)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Status Line
  "nvim-lualine/lualine.nvim",

  -- Telescope (fuzzy finder)
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Git
  "lewis6991/gitsigns.nvim",

  -- Autopairs and Comments
  "windwp/nvim-autopairs",
  "numToStr/Comment.nvim",
      -- lazy.nvim example
  {
    'mg979/vim-visual-multi',
    branch = 'master'
  },
    {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      flavour = "frappe",  -- latte, frappe, macchiato, mocha
      transparent_background = false,
      integrations = {
        treesitter = true,
        native_lsp = {
          enabled = true,
        },
        telescope = true,
        nvimtree = true,
        cmp = true,
        -- lualine removed to avoid missing module error
      },
    })
    vim.cmd("colorscheme catppuccin")
  end,
},
})
