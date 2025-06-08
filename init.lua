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
  {
    "github/copilot.vim",
    lazy = false,
  },


---------------------------------------------------------------------------
--  LSP / Mason / Completion ----------------------------------------------
---------------------------------------------------------------------------
{
  "neovim/nvim-lspconfig",
},

{
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  config = function()
    safe_require("mason").setup()
  end,
},

{
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    safe_require("mason-lspconfig").setup({
      ensure_installed = {
        -- Web
        "html", "cssls", "emmet_ls", "vtsls", "eslint", "jsonls",

        -- Backend
        "pyright", "bashls", "lua_ls", "gopls", "rust_analyzer",
        "clangd", "dockerls", "yamlls", "graphql",

        -- Java / .NET / JVM
        "jdtls", "kotlin_language_server", "lemminx", "omnisharp",

        -- Database / Configs
        "sqlls", "taplo",

        -- Others
        "perlpls", "powershell_es", "ansiblels", "terraformls",

        -- Markdown and docs
        "marksman", "ltex",
      },
    })
  end,
},

{
  "hrsh7th/nvim-cmp",
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
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
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

{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    safe_require("nvim-treesitter.configs").setup({
      ensure_installed = {
        -- Web
        "css", "html", "javascript", "json", "scss", "typescript",

        -- Backend / General-purpose
        "bash", "c", "cpp", "elixir", "go", "java", "kotlin",
        "lua", "perl", "php", "python", "ruby", "rust",

        -- Infra / Scripting
        "dockerfile", "make", "terraform", "toml", "yaml",

        -- Markup / Docs
        "latex", "markdown", "markdown_inline",

        -- Other
        "graphql", "regex", "sql",
      },
      highlight = {
        enable = true,
      },
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
     safe_require("nvim-tree").setup({
       filters = {
         custom = {".git"},
         exclude = {}
       },
       respect_buf_cwd = false,
     })
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



------------------------------------------------------------------------------
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

-- Directional window navigation with Ctrl + Arrow keys
vim.keymap.set('n', '<C-Right>', '<C-w>l', { noremap = true, silent = true })  -- right
vim.keymap.set('n', '<C-Left>',  '<C-w>h', { noremap = true, silent = true })  -- left
vim.keymap.set('n', '<C-Down>',  '<C-w>j', { noremap = true, silent = true })  -- down
vim.keymap.set('n', '<C-Up>',    '<C-w>k', { noremap = true, silent = true })  -- up


-- Enable spellcheck with Australian English for specific filetypes
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown", "gitcommit", "text", "python" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_au"
  end,
})


-- Define and create the spell directory if it doesn't exist
local spell_dir = vim.fn.stdpath("config") .. "/spell"
if vim.fn.isdirectory(spell_dir) == 0 then
  vim.fn.mkdir(spell_dir, "p")
end

-- Set persistent spellfile
vim.opt.spellfile = spell_dir .. "/en.utf-8.add"

-- Map <leader>z to add word under cursor to spellfile
vim.keymap.set("n", "<leader>z", "zg", { desc = "Add word to dictionary" })




-- Define a Neovim command :NSearch <phrase> to search ~/.config/nvim/nsearch.txt
vim.api.nvim_create_user_command("NSearch", function(opts)
  local search = table.concat(opts.fargs, " ")
  if search == "" then
    print("Usage: :NSearch <search_term>")
    return
  end

  local file = vim.fn.stdpath("config") .. "/nsearch.txt"
  local f = io.open(file, "r")
  if not f then
    print("Error: " .. file .. " not found!")
    return
  end

  local lines = {}
  for line in f:lines() do
    if line:lower():find(search:lower(), 1, true) then
      table.insert(lines, line)
    end
  end
  f:close()

  if #lines == 0 then
    print("No matches found for: " .. search)
    return
  end

  -- Helper: split and trim
  local function split(str, sep)
    local result = {}
    for token in string.gmatch(str, "([^" .. sep .. "]+)") do
      table.insert(result, vim.trim(token))
    end
    return result
  end

  -- Format: calculate max column widths
  local col_widths = {}
  local rows = {}
  for _, line in ipairs(lines) do
    local cols = split(line, "|")
    for i, col in ipairs(cols) do
      col_widths[i] = math.max(col_widths[i] or 0, #col)
    end
    table.insert(rows, cols)
  end

  -- Output neatly aligned
  for _, row in ipairs(rows) do
    local formatted = {}
    for i, col in ipairs(row) do
      table.insert(formatted, col .. string.rep(" ", col_widths[i] - #col))
    end
    print(table.concat(formatted, " | "))
  end
end, {
  nargs = "+",
  desc = "Search ~/.config/nvim/nsearch.txt (case-insensitive)",
})

