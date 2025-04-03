
local M = {}

local question_buf, answer_buf
local question_win, answer_win

-- Set your API endpoint here
local API_ENDPOINT = "http://localhost:8000/ask"

function M.open_ui()
  local width = vim.o.columns
  local height = vim.o.lines

  -- Calculate sizes
  local question_height = 8
  local answer_height = height - question_height - 6
  local win_width = math.floor(width * 0.8)
  local win_col = math.floor((width - win_width) / 2)

  -- Question box
  question_buf = vim.api.nvim_create_buf(false, true)
  question_win = vim.api.nvim_open_win(question_buf, true, {
    relative = "editor",
    row = 2,
    col = win_col,
    width = win_width,
    height = question_height,
    border = "rounded",
    style = "minimal",
  })
  vim.api.nvim_buf_set_option(question_buf, 'filetype', 'markdown')
  vim.api.nvim_buf_set_keymap(question_buf, 'n', '<CR>', '', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(question_buf, 'n', '<leader>s', "<cmd>lua require'ai_ui'.submit_question()<CR>", { noremap = true, silent = true })

  -- Answer box
  answer_buf = vim.api.nvim_create_buf(false, true)
  answer_win = vim.api.nvim_open_win(answer_buf, false, {
    relative = "editor",
    row = question_height + 4,
    col = win_col,
    width = win_width,
    height = answer_height,
    border = "rounded",
    style = "minimal",
  })
  vim.api.nvim_buf_set_option(answer_buf, 'filetype', 'markdown')
  vim.api.nvim_buf_set_option(answer_buf, 'modifiable', false)
end

function M.submit_question()
  local lines = vim.api.nvim_buf_get_lines(question_buf, 0, -1, false)
  local question = table.concat(lines, "\n")

  -- HTTP request via curl (synchronous for simplicity)
  local curl_cmd = string.format([[curl -s -X POST -H "Content-Type: application/json" -d '{"question": %q}' "%s"]], question, API_ENDPOINT)
  local result = vim.fn.systemlist(curl_cmd)

  -- Update answer window
  vim.api.nvim_buf_set_option(answer_buf, 'modifiable', true)
  -- vim.api.nvim_buf_set_lines(answer_buf, 0, -1, false, result)
  vim.api.nvim_buf_set_lines(answer_buf, 0, -1, false, {"hello world"})
  vim.api.nvim_buf_set_option(answer_buf, 'modifiable', false)
end



return M
