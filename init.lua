-- AI UI
vim.api.nvim_set_keymap('n', '<leader>ai', [[<cmd>lua require'ai_ui'.set_last_buf()<CR><cmd>lua require'ai_ui'.open_ui()<CR>]], { noremap = true, silent = true })

