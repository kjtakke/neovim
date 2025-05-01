-- ============================================================================
--  Neovim configuration (lazy‑nvim edition)                                   
--  Keeps prior behaviour, now wires cmp → LSP so Python IntelliSense works.   
--  Australian / British spelling.                                             
-- ============================================================================

-------------------------------------------------------------------------------
--  Bootstrap lazy.nvim -------------------------------------------------------
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------------------------------------
--  Helper --------------------------------------------------------------------
-------------------------------------------------------------------------------
local function safe_require(mod)
  local ok, pkg = pcall(require, mod)
  return ok and pkg or nil
end

-------------------------------------------------------------------------------
--  Plug‑in spec --------------------------------------------------------------
-------------------------------------------------------------------------------
require("lazy").setup({
  ---------------------------------------------------------------------------
  --  Colourscheme -----------------------------------------------------------
  ---------------------------------------------------------------------------
{
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      integrations = {
        telescope = true,
        nvimtree  = true,
        cmp       = true,
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
},

  ---------------------------------------------------------------------------
  --  LSP / Mason / Completion ----------------------------------------------
  ---------------------------------------------------------------------------
  { "neovim/nvim-lspconfig" },

  { "williamboman/mason.nvim", build = ":MasonUpdate", config = function()
      safe_require("mason").setup()
    end },

  { "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      safe_require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "bashls" },
      })
    end,
  },

  { "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp     = safe_require("cmp")
      local luasnip = safe_require("luasnip")
      if not (cmp and luasnip) then return end

      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping.select_next_item(),
          ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip"  },
        },
      })
    end,
  },

  ---------------------------------------------------------------------------
  --  Treesitter -------------------------------------------------------------
  ---------------------------------------------------------------------------
  { "nvim-treesitter/nvim-treesitter",
    build  = ":TSUpdate",
    config = function()
      safe_require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "bash", "lua" },
        highlight        = { enable = true },
      })
    end,
  },

  ---------------------------------------------------------------------------
  --  File explorer ----------------------------------------------------------
  ---------------------------------------------------------------------------
  { "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle File Tree" },
    },
    config = function()
      safe_require("nvim-tree").setup()
    end,
  },

  ---------------------------------------------------------------------------
  --  Telescope --------------------------------------------------------------
  ---------------------------------------------------------------------------
  { "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = safe_require("telescope.builtin")
      if not builtin then return end
      local map = vim.keymap.set
      map("n", "<leader>ff", builtin.find_files, { desc = "Find Files"       })
      map("n", "<leader>fg", builtin.live_grep,  { desc = "Live Grep"        })
      map("n", "<leader>fb", builtin.buffers,    { desc = "Buffers"          })
      map("n", "<leader>fh", builtin.help_tags,  { desc = "Help Tags"        })
      map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics"      })
      map("n", "<leader>fr", builtin.resume,      { desc = "Resume"           })
    end,
  },

  ---------------------------------------------------------------------------
  --  UI niceties ------------------------------------------------------------
  ---------------------------------------------------------------------------
  { "nvim-lualine/lualine.nvim",
    config = function()
      safe_require("lualine").setup({ options = { theme = "catppuccin" } })
    end,
  },
  { "lewis6991/gitsigns.nvim",  config = true },
  { "windwp/nvim-autopairs",    config = true },
  { "numToStr/Comment.nvim",    config = true },
  { "mg979/vim-visual-multi",   branch = "master" },
})

-------------------------------------------------------------------------------
--  LSP servers --------------------------------------------------------------
-------------------------------------------------------------------------------
local lspconfig = safe_require("lspconfig")
if lspconfig then
  -- capabilities → allow cmp‑nvim‑lsp to advertise completion capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_caps     = safe_require("cmp_nvim_lsp")
  if cmp_caps then capabilities = cmp_caps.default_capabilities(capabilities) end

  -- Python (Pyright)
  lspconfig.pyright.setup({
    capabilities = capabilities,
  })

  -- Bash
  lspconfig.bashls.setup({
    filetypes   = { "sh", "zsh", "bash" },
    capabilities = capabilities,
  })
end

-------------------------------------------------------------------------------
--  Options ------------------------------------------------------------------
-------------------------------------------------------------------------------
vim.opt.number       = true
vim.opt.cursorline   = true
vim.opt.ignorecase   = true
vim.opt.smartcase    = true
vim.opt.scrolloff    = 10
vim.opt.wildmenu     = true
vim.opt.wildmode     = "longest,list"
vim.opt.foldmethod   = "indent"
vim.opt.foldenable   = true
vim.opt.foldlevel    = 99
vim.opt.foldminlines = 5
vim.opt.clipboard    = "unnamedplus"
vim.opt.modeline     = false
-- vim.opt.wrap         = false
-------------------------------------------------------------------------------
--  Autocommands -------------------------------------------------------------
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local api = safe_require("nvim-tree.api")
    if api then api.tree.open() end
  end,
})

-------------------------------------------------------------------------------
--  Commands / keymaps / utilities unchanged below ---------------------------
-------------------------------------------------------------------------------
local function new_scratch()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
end

local map = vim.keymap.set
map("n", "<leader>x", new_scratch,                { desc = "New Scratch"      })
map("n", "\\rp",  ":w !python3 %<CR>",          { silent = true, desc = "Run Python" })
map("n", "\\rb",  ":w !bash %<CR>",             { silent = true, desc = "Run Bash"   })
map("n", "\\q",   ":q<CR>",                     { silent = true, desc = "Quit"       })
map("n", "\\qq",  ":q!<CR>",                    { silent = true, desc = "Force Quit" })
map("n", "\\w",   ":w<CR>",  { silent = true, desc = "Save" })

vim.api.nvim_set_keymap('n', '<leader>ai', [[<cmd>lua require'ai_ui'.set_last_buf()<CR><cmd>lua require'ai_ui'.open_ui()<CR>]], { noremap = true, silent = true })
-- Function to run pylint and filter output
local function run_pylint()
  vim.cmd('write')
  local filename = vim.fn.expand('%')
  local handle = io.popen('pylint "' .. filename .. '" 2>&1')
  if handle then
    local output = handle:read('*a')
    handle:close()

    local filtered_output = {}
    for line in output:gmatch('[^\r\n]+') do
      if line:match('^%S+:%d+:%d+: E') and not line:match('E0401') then
        table.insert(filtered_output, line)
      end
    end
    if #filtered_output== 0 then
      table.insert(filtered_output, "✅ No issues found!")
    end
    local ui = vim.api.nvim_list_uis()[1]
    local width = math.floor(ui.width * 0.6)
    local height = math.floor(ui.height * 0.6)
    local col = math.floor((ui.width - width) / 2)
    local row = math.floor((ui.height - height) / 2)
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, filtered_output)
    vim.api.nvim_open_win(bufnr, true, {
      style = "minimal",
      relative = "editor",
      width = width,
      height = height,
      col = col,
      row = row,
      border = "rounded"
    })
  else
    vim.notify("Failed to run pylint")
  end
end

-- Create the custom command :Wt
vim.api.nvim_create_user_command('Wt', run_pylint, {})

-- Function to run ShellCheck and show output in a floating window
local function run_shellcheck()
  vim.cmd('silent! write!')
  local filename = vim.fn.expand('%:p')  -- Full path to the current file
  local shellcheck_path = '/usr/bin/shellcheck'  -- Adjust if needed

  if vim.fn.executable(shellcheck_path) == 0 then
    vim.notify("ShellCheck not found at: " .. shellcheck_path, vim.log.levels.ERROR)
    return
  end

  local command = shellcheck_path .. ' --severity=info --enable=all "' .. filename .. '" 2>&1'
  local handle = io.popen(command)
  if not handle then
    vim.notify("Failed to run ShellCheck", vim.log.levels.ERROR)
    return
  end

  local output = handle:read('*a')
  handle:close()

  -- Split the full output string into lines
  local lines = {}
  for line in output:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end

  if #lines == 0 then
    table.insert(lines, "✅ No issues found by ShellCheck!")
  end

  -- Create a floating window to display the output
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(ui.width * 0.6)
  local height = math.floor(ui.height * 0.6)
  local col = math.floor((ui.width - width) / 2)
  local row = math.floor((ui.height - height) / 2)

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  vim.api.nvim_open_win(bufnr, true, {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    border = "rounded"
  })
end

vim.api.nvim_create_user_command('Wtsh', run_shellcheck, {})


-- Map <leader>b to :G blame using vim-fugitive
vim.keymap.set('n', '<leader>b', ':G blame<CR>', { noremap = true, silent = true, desc = 'Git Blame' })
