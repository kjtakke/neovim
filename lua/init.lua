return {
  -- Other plugins first
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-lualine/lualine.nvim" },
  { "nvim-tree/nvim-tree.lua" },

  -- Your which-key config
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
      local wk = require("which-key")
      wk.setup()
      wk.register({
        ["<leader>c"] = { name = "[C]ode" },
        ["<leader>d"] = { name = "[D]ocument" },
        ["<leader>r"] = { name = "[R]ename" },
        ["<leader>s"] = { name = "[S]earch" },
        ["<leader>w"] = { name = "[W]orkspace" },
        ["<leader>t"] = { name = "[T]oggle" },
        ["<leader>h"] = { name = "Git [H]unk" },
      })
    end,
  },
}

