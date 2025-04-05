local M = {}

local question_visible = true
local question_buf, answer_buf
local question_win, answer_win
local last_buf

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
  "<cmd>lua require'ai_ui'.toggle_question_box()<CR>",
  { noremap = true, silent = true }
)
  vim.api.nvim_buf_set_keymap(
  question_buf, 'n', '\\f',
  "<cmd>lua require'ai_ui'.insert_current_file()<CR>",
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


function M.set_last_buf()
  last_buf = vim.api.nvim_get_current_buf()
end

-- Get previous window's buffer
function M.get_previous_buffer()
  local current_win = vim.api.nvim_get_current_win()
  local wins = vim.api.nvim_tabpage_list_wins(0)

  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    if win ~= current_win and vim.api.nvim_buf_get_option(buf, 'buftype') == '' then
      return buf
    end
  end

  return nil
end


function M.insert_current_file()
  if not last_buf or not vim.api.nvim_buf_is_valid(last_buf) then
    print("No previous buffer found")
    return
  end

  -- Get content from the last buffer
  local total_lines = vim.api.nvim_buf_line_count(last_buf)
  local all_lines = vim.api.nvim_buf_get_lines(last_buf, 0, -1, false)

  local insert_lines
  if total_lines > 1000 then
    local top = vim.list_slice(all_lines, 0, 300)
    local bottom = vim.list_slice(all_lines, total_lines - 700, total_lines)
    insert_lines = {}
    vim.list_extend(insert_lines, top)
    table.insert(insert_lines, "... [truncated middle] ...")
    vim.list_extend(insert_lines, bottom)
  else
    insert_lines = all_lines
  end

  -- Append to the bottom of the question buffer
  local current_lines = vim.api.nvim_buf_line_count(question_buf)
  vim.api.nvim_buf_set_lines(question_buf, current_lines, current_lines, false, insert_lines)
end


function M.toggle_question_box()
  if not answer_win or not vim.api.nvim_win_is_valid(answer_win) then
    print("Answer window is missing")
    return
  end

  local width = vim.o.columns
  local height = vim.o.lines

  if question_visible then
    -- Hide the question box
    if question_win and vim.api.nvim_win_is_valid(question_win) then
      vim.api.nvim_win_close(question_win, true)
      question_win = nil
    end

    -- Resize the answer box to 30% width, right-aligned, full height
    local new_width = math.floor(width * 0.3)
    local new_col = width - new_width

    vim.api.nvim_win_set_config(answer_win, {
      relative = "editor",
      row = 0,
      col = new_col,
      width = new_width,
      height = height,
      style = "minimal",
      border = "rounded",
    })

    question_visible = false
  else
    -- Reopen the question window
    local question_height = 8
    local answer_height = height - question_height - 6
    local win_width = math.floor(width * 0.8)
    local win_col = math.floor((width - win_width) / 2)

    -- Only reopen if buffer still exists
    if question_buf and vim.api.nvim_buf_is_valid(question_buf) then
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
    end

    -- Resize answer box back to bottom layout
    vim.api.nvim_win_set_config(answer_win, {
      relative = "editor",
      row = question_height + 4,
      col = win_col,
      width = win_width,
      height = answer_height,
      style = "minimal",
      border = "rounded",
    })

    question_visible = true
  end
end

return M
