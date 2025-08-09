-- :Wt  (pylint)   | :Wg (golangci-lint) | :Wtsh (shellcheck)
local function run_pylint()
  vim.cmd("write")
  local filename = vim.fn.expand("%")
  local handle = io.popen('pylint "' .. filename .. '" 2>&1')
  if not handle then return vim.notify("Failed to run pylint") end

  local output = handle:read("*a")
  handle:close()

  local filtered_output = {}
  for line in output:gmatch("[^\r\n]+") do
    if line:match("^%S+:%d+:%d+: E") and not line:match("E0401") then
      table.insert(filtered_output, line)
    end
  end
  if #filtered_output == 0 then table.insert(filtered_output, "✅ No issues found!") end

  local ui = vim.api.nvim_list_uis()[1]
  local width  = math.floor(ui.width * 0.6)
  local height = math.floor(ui.height * 0.6)
  local col    = math.floor((ui.width - width) / 2)
  local row    = math.floor((ui.height - height) / 2)

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, filtered_output)
  vim.api.nvim_open_win(bufnr, true, {
    style = "minimal", relative = "editor", width = width, height = height,
    col = col, row = row, border = "rounded"
  })
end

local function run_golint()
  vim.cmd("write")
  local filename = vim.fn.expand("%")
  local handle = io.popen('golangci-lint run "' .. filename .. '" 2>&1')
  if not handle then return vim.notify("Failed to run golangci-lint") end

  local output = handle:read("*a")
  handle:close()

  local filtered_output = {}
  for line in output:gmatch("[^\r\n]+") do
    if line:match(":%d+:%d+:") then table.insert(filtered_output, line) end
  end
  if #filtered_output == 0 then table.insert(filtered_output, "✅ No issues found!") end

  local ui = vim.api.nvim_list_uis()[1]
  local width  = math.floor(ui.width * 0.6)
  local height = math.floor(ui.height * 0.6)
  local col    = math.floor((ui.width - width) / 2)
  local row    = math.floor((ui.height - height) / 2)

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, filtered_output)
  vim.api.nvim_open_win(bufnr, true, {
    style = "minimal", relative = "editor", width = width, height = height,
    col = col, row = row, border = "rounded"
  })
end

local function run_shellcheck()
  vim.cmd("silent! write!")
  local filename = vim.fn.expand("%:p")
  local shellcheck_path = "/usr/bin/shellcheck"

  if vim.fn.executable(shellcheck_path) == 0 then
    return vim.notify("ShellCheck not found at: " .. shellcheck_path, vim.log.levels.ERROR)
  end

  local command = shellcheck_path .. ' --severity=info --enable=all "' .. filename .. '" 2>&1'
  local handle = io.popen(command)
  if not handle then return vim.notify("Failed to run ShellCheck", vim.log.levels.ERROR) end
  local output = handle:read("*a"); handle:close()

  local lines = {}
  for line in output:gmatch("[^\r\n]+") do table.insert(lines, line) end
  if #lines == 0 then table.insert(lines, "✅ No issues found by ShellCheck!") end

  local ui = vim.api.nvim_list_uis()[1]
  local width  = math.floor(ui.width * 0.6)
  local height = math.floor(ui.height * 0.6)
  local col    = math.floor((ui.width - width) / 2)
  local row    = math.floor((ui.height - height) / 2)
  local bufnr  = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_open_win(bufnr, true, {
    style = "minimal", relative = "editor", width = width, height = height,
    col = col, row = row, border = "rounded"
  })
end

vim.api.nvim_create_user_command("Wt",   run_pylint,    {})
vim.api.nvim_create_user_command("Wg",   run_golint,    {})
vim.api.nvim_create_user_command("Wtsh", run_shellcheck, {})

