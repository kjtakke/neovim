-- ~/.config/nvim/lua/custom/ai_ui.lua
-- Minimal floating UI that talks to a local API on http://localhost:5001

local M = {}

-- Important: declare these BEFORE functions so they are real locals
local question_visible = true
local question_buf, answer_buf
local question_win, answer_win
local last_buf

-- Endpoints
local API_BASE                 = "http://localhost:5001"
local API_ASK_ENDPOINT         = API_BASE .. "/ask"
local API_CLEAR_ENDPOINT       = API_BASE .. "/clear_assistant"
local API_HISTORY_ENDPOINT     = API_BASE .. "/history"
local API_MODELS_ENDPOINT      = API_BASE .. "/list_models"
local API_CHANGE_MODEL_ENDPOINT= API_BASE .. "/change_model"

-- Remember the buffer you were in before opening the UI
function M.set_last_buf()
  last_buf = vim.api.nvim_get_current_buf()
end

-- Open the question + answer panes
function M.open_ui()
  local width = vim.o.columns
  local height = vim.o.lines

  local question_height = 8
  local answer_height = height - question_height - 6
  local win_width = math.floor(width * 0.8)
  local win_col = math.floor((width - win_width) / 2)

  -- Question buffer + window
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
  vim.bo[question_buf].filetype = "markdown"

  -- Local keymaps scoped to the question buffer
  vim.api.nvim_buf_set_keymap(
    question_buf, "n", "<leader>s",
    "<cmd>lua require('custom.ai_ui').submit_question()<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    question_buf, "n", "\\a",
    "<cmd>lua require('custom.ai_ui').clear_chat()<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    question_buf, "n", "<leader>z",
    "<cmd>lua require('custom.ai_ui').toggle_question_box()<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    question_buf, "n", "\\f",
    "<cmd>lua require('custom.ai_ui').insert_current_file()<CR>",
    { noremap = true, silent = true }
  )

  -- Answer buffer + window
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
  vim.bo[answer_buf].filetype = "markdown"
  vim.bo[answer_buf].modifiable = false

  -- Load history into the answer window
  M.load_history()
end

-- Submit the question buffer to the API
function M.submit_question()
  if not (question_buf and vim.api.nvim_buf_is_valid(question_buf)) then
    vim.notify("Question buffer not ready", vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(question_buf, 0, -1, false)
  local question = table.concat(lines, "\n")

  -- Write JSON body to tmp file (simple and robust)
  local tmpfile = vim.fn.tempname() .. ".json"
  local f = io.open(tmpfile, "w")
  if not f then
    vim.notify("Could not write temporary file", vim.log.levels.ERROR)
    return
  end
  f:write(vim.fn.json_encode({ question = question }))
  f:close()

  local cmd = string.format(
    [[curl -s -X POST -H "Content-Type: application/json" --data-binary @%s "%s"]],
    vim.fn.shellescape(tmpfile),
    API_ASK_ENDPOINT
  )
  local result = vim.fn.systemlist(cmd)

  -- Display result in answer buffer
  if not (answer_buf and vim.api.nvim_buf_is_valid(answer_buf)) then
    vim.notify("Answer buffer not ready", vim.log.levels.WARN)
    return
  end
  vim.bo[answer_buf].modifiable = true
  vim.api.nvim_buf_set_lines(answer_buf, 0, -1, false, result)
  vim.bo[answer_buf].modifiable = false
  local line_count = vim.api.nvim_buf_line_count(answer_buf)
  vim.api.nvim_win_set_cursor(answer_win, { line_count, 0 })

  -- Clear question buffer and tmp
  vim.api.nvim_buf_set_lines(question_buf, 0, -1, false, {})
  pcall(os.remove, tmpfile)
end

-- Clear chat history (and optionally the answer buffer)
function M.clear_chat(no_show)
  if not (answer_buf and vim.api.nvim_buf_is_valid(answer_buf)) then
    return
  end
  local cmd = string.format([[curl -s -X POST "%s"]], API_CLEAR_ENDPOINT)
  local result = vim.fn.systemlist(cmd)

  vim.bo[answer_buf].modifiable = true
  if no_show then
    vim.api.nvim_buf_set_lines(answer_buf, 0, -1, false, {})
  else
    vim.api.nvim_buf_set_lines(answer_buf, 0, -1, false, result)
  end
  vim.bo[answer_buf].modifiable = false

  if question_buf and vim.api.nvim_buf_is_valid(question_buf) then
    vim.api.nvim_buf_set_lines(question_buf, 0, -1, false, {})
  end
end

-- Insert current file contents (or truncated) into the question buffer
function M.insert_current_file()
  if not last_buf or not vim.api.nvim_buf_is_valid(last_buf) then
    vim.notify("No previous buffer found", vim.log.levels.INFO)
    return
  end
  if not (question_buf and vim.api.nvim_buf_is_valid(question_buf)) then
    vim.notify("Question buffer not ready", vim.log.levels.WARN)
    return
  end

  local total_lines = vim.api.nvim_buf_line_count(last_buf)
  local all_lines = vim.api.nvim_buf_get_lines(last_buf, 0, -1, false)

  local insert_lines
  if total_lines > 1000 then
    local top = vim.list_slice(all_lines, 1, 300)                       -- first 300
    local bottom = vim.list_slice(all_lines, total_lines - 700 + 1, total_lines) -- last 700
    insert_lines = {}
    vim.list_extend(insert_lines, top)
    table.insert(insert_lines, "... [truncated middle] ...")
    vim.list_extend(insert_lines, bottom)
  else
    insert_lines = all_lines
  end

  local cur = vim.api.nvim_buf_line_count(question_buf)
  vim.api.nvim_buf_set_lines(question_buf, cur, cur, false, insert_lines)
end

-- Toggle showing the top question box vs a side-only answer view
function M.toggle_question_box()
  if not (answer_win and vim.api.nvim_win_is_valid(answer_win)) then
    vim.notify("Answer window is missing", vim.log.levels.WARN)
    return
  end

  local width = vim.o.columns
  local height = vim.o.lines

  if question_visible then
    -- Hide question; shrink answer to right 30%
    if question_win and vim.api.nvim_win_is_valid(question_win) then
      vim.api.nvim_win_close(question_win, true)
      question_win = nil
    end
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
    -- Restore question & bottom layout
    local question_height = 8
    local answer_height = height - question_height - 6
    local win_width = math.floor(width * 0.8)
    local win_col = math.floor((width - win_width) / 2)

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
      vim.bo[question_buf].filetype = "markdown"
    end

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

-- Load server history into answer pane
function M.load_history()
  if not (answer_buf and vim.api.nvim_buf_is_valid(answer_buf)) then
    vim.notify("Answer buffer not ready", vim.log.levels.WARN)
    return
  end

  local cmd = string.format([[curl -s "%s"]], API_HISTORY_ENDPOINT)
  local result = vim.fn.systemlist(cmd)

  vim.bo[answer_buf].modifiable = true
  vim.api.nvim_buf_set_lines(answer_buf, 0, -1, false, result)
  vim.bo[answer_buf].modifiable = false

  local line_count = vim.api.nvim_buf_line_count(answer_buf)
  vim.api.nvim_win_set_cursor(answer_win, { line_count, 0 })
end

-- List models into a floating window or the answer pane
function M.show_models()
  local result = vim.fn.systemlist(string.format([[curl -s "%s"]], API_MODELS_ENDPOINT))

  if not (answer_buf and vim.api.nvim_buf_is_valid(answer_buf)) then
    local width = math.floor(vim.o.columns * 0.6)
    local height = math.floor(vim.o.lines * 0.6)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local tmp_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(tmp_buf, true, {
      relative = "editor",
      row = row,
      col = col,
      width = width,
      height = height,
      border = "rounded",
      style = "minimal",
    })
    vim.bo[tmp_buf].filetype = "markdown"
    vim.api.nvim_buf_set_lines(tmp_buf, 0, -1, false, result)
    return
  end

  vim.bo[answer_buf].modifiable = true
  vim.api.nvim_buf_set_lines(answer_buf, 0, -1, false, result)
  vim.bo[answer_buf].modifiable = false
end

-- Change the backend model and display the response
function M.change_model(model)
  if not model or model == "" then
    print("Usage: :ChangeModel <model>")
    return
  end

  local payload = string.format('{"model":"%s"}', model)
  local cmd = string.format(
    [[curl -s -X POST -H "Content-Type: application/json" -d %s "%s"]],
    vim.fn.shellescape(payload),
    API_CHANGE_MODEL_ENDPOINT
  )
  local result = vim.fn.systemlist(cmd)

  if not (answer_buf and vim.api.nvim_buf_is_valid(answer_buf)) then
    local width = math.floor(vim.o.columns * 0.6)
    local height = math.floor(vim.o.lines * 0.4)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local tmp_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(tmp_buf, true, {
      relative = "editor",
      row = row,
      col = col,
      width = width,
      height = height,
      border = "rounded",
      style = "minimal",
    })
    vim.bo[tmp_buf].filetype = "markdown"
    vim.api.nvim_buf_set_lines(tmp_buf, 0, -1, false, result)
    return
  end

  vim.bo[answer_buf].modifiable = true
  vim.api.nvim_buf_set_lines(answer_buf, 0, -1, false, result)
  vim.bo[answer_buf].modifiable = false
end

return M

