local builtin = require("telescope.builtin")
local map = vim.keymap.set

map("n", "<leader>ff", builtin.find_files,  { desc = "Find Files" })
map("n", "<leader>fg", builtin.live_grep,   { desc = "Live Grep"  })
map("n", "<leader>fb", builtin.buffers,     { desc = "Buffers"    })
map("n", "<leader>fh", builtin.help_tags,   { desc = "Help Tags"  })
map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics"})
map("n", "<leader>fr", builtin.resume,      { desc = "Resume"     })

