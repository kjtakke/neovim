-- Highlight tweaks that must exist early
vim.api.nvim_set_hl(0, "@punctuation.bracket",   { fg = "#ff69b4" }) -- pink brackets
vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = "#ff69b4" }) -- pink braces

-- Cursor highlight + shapes
vim.cmd([[ highlight Cursor guifg=NONE guibg=Gold gui=NONE ctermfg=NONE ctermbg=Yellow cterm=NONE ]])

-- Consolidated guicursor (no blink)
vim.opt.guicursor = table.concat({
  "n-v-c:block-Cursor",      -- Normal, Visual, Command: block
  "i-ci-ve:ver25-Cursor",    -- Insert & command-line insert: bar
  "r-cr:hor20-Cursor",       -- Replace variants: underscore
  "o:hor50-Cursor",          -- Operator-pending: underscore
  "a:blinkon0"               -- Disable blinking
}, ",")

