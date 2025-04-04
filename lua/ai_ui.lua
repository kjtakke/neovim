
local M = {}

local question_buf, answer_buf
local question_win, answer_win

local API_ASK_ENDPOINT   = "http://localhost:5001/ask"
local API_CLEAR_ENDPOINT = "http://localhost:5001/clear_assistant"

function M.open_ui()
  local width = vim.o.columns
  local height = vim.o.lines

  local question_height = 8
  local answer_height = height - question_height - 6
  local win_width = math.floor(width * 0.8)
  local win_col = math.floor((width - win_width) / 2)

  -- 1. Create the question buffer and window
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
  vim.api.nvim_buf_set_option(question_buf, "filetype", "markdown")
  vim.api.nvim_buf_set_keymap(
    question_buf, "n", "<leader>s",
    "<cmd>lua require'ai_ui'.submit_question()<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    question_buf, "n", "<leader>z",
    "<cmd>lua require'ai_ui'.clear_chat()<CR>",
    { noremap = true, silent = true }
  )

  -- 2. Create the answer buffer and window
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
  vim.api.nvim_buf_set_option(answer_buf, "filetype", "markdown")
  vim.api.nvim_buf_set_option(answer_buf, "modifiable", false)

  -- 3. Clear the server chat history but do NOT show its response.
  M.clear_chat(true)  -- pass a flag, meaning "no need to show server's response"
end

function M.submit_question()
  local lines = vim.api.nvim_buf_get_lines(question_buf, 0, -1, false)
  local question = table.concat(lines, "\n")

  -- Write the JSON body to a temporary file
  local tmpfile = "/tmp/ai_ui_question.json"
  local f = io.open(tmpfile, "w")
  if f then
    local escaped = vim.fn.json_encode({ question = question })
    f:write(escaped)
    f:close()
  else
    print("Error: Could not write to temporary file.")
    return
  end

  -- Use --data-binary to POST the file
  local curl_cmd = string.format(
    [[curl -s -X POST -H "Content-Type: application/json" --data-binary @%s "%s"]],
    tmpfile,
    API_ASK_ENDPOINT
  )

  local result = vim.fn.systemlist(curl_cmd)

  -- Display the result
  vim.api.nvim_buf_set_option(answer_buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(answer_buf, 0, -1, false, result)
  vim.api.nvim_buf_set_option(answer_buf, "modifiable", false)
  local line_count = vim.api.nvim_buf_line_count(answer_buf)
  vim.api.nvim_win_set_cursor(answer_win, { line_count, 0 })
  vim.api.nvim_buf_set_lines(question_buf, 0, -1, false, {})

  -- Optionally delete the temp file
  os.remove(tmpfile)
end

function M.clear_chat(no_show)
  if not answer_buf or not question_buf then
    return
  end

  local curl_cmd = string.format([[curl -s -X POST "%s"]], API_CLEAR_ENDPOINT)
  local result = vim.fn.systemlist(curl_cmd)

  -- Either show the server response or ignore it
  vim.api.nvim_buf_set_option(answer_buf, "modifiable", true)

  if no_show then
    -- Just wipe the answer buffer so it's blank
    vim.api.nvim_buf_set_lines(answer_buf, 0, -1, false, {})
  else
    -- If called from Leader+z, maybe we *do* want to see what the server responded
    vim.api.nvim_buf_set_lines(answer_buf, 0, -1, false, result)
  end

  vim.api.nvim_buf_set_option(answer_buf, "modifiable", false)

  -- Also clear the question buffer if you like
  vim.api.nvim_buf_set_lines(question_buf, 0, -1, false, {})
end

return M
