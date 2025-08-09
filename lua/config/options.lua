local o = vim.opt

o.termguicolors = true
o.number       = true
o.cursorline   = true
o.ignorecase   = true
o.smartcase    = true
o.scrolloff    = 10
o.wildmenu     = true
o.wildmode     = "longest,list"
o.foldmethod   = "indent"
o.foldenable   = true
o.foldlevel    = 99
o.foldminlines = 5
o.clipboard    = "unnamedplus"
o.modeline     = false
o.list         = true
o.listchars    = {
  tab = "▸ ",
  trail = "·",
  eol = "↴",
  extends = "❯",
  precedes = "❮",
  space = "·",
}

-- Persistent spellfile path (dir is ensured in custom.spell)
o.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

