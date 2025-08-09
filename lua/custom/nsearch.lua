-- :NSearch <phrase> searches ~/.config/nvim/nsearch.txt (case-insensitive)
vim.api.nvim_create_user_command("NSearch", function(opts)
  local search = table.concat(opts.fargs, " ")
  if search == "" then print("Usage: :NSearch <search_term>"); return end

  local file = vim.fn.stdpath("config") .. "/search/nsearch.txt"
  local f = io.open(file, "r")
  if not f then print("Error: " .. file .. " not found!"); return end

  local lines = {}
  for line in f:lines() do
    if line:lower():find(search:lower(), 1, true) then table.insert(lines, line) end
  end
  f:close()

  if #lines == 0 then print("No matches found for: " .. search); return end

  local function split(str, sep)
    local result = {}
    for token in string.gmatch(str, "([^" .. sep .. "]+)") do
      table.insert(result, vim.trim(token))
    end
    return result
  end

  local col_widths, rows = {}, {}
  for _, line in ipairs(lines) do
    local cols = split(line, "|")
    for i, col in ipairs(cols) do col_widths[i] = math.max(col_widths[i] or 0, #col) end
    table.insert(rows, cols)
  end

  for _, row in ipairs(rows) do
    local formatted = {}
    for i, col in ipairs(row) do
      table.insert(formatted, col .. string.rep(" ", col_widths[i] - #col))
    end
    print(table.concat(formatted, " | "))
  end
end, { nargs = "+", desc = "Search ~/.config/nvim/search/nsearch.txt (case-insensitive)" })

