-- lua/cfg/file_stats.lua
local M = {}

local function has_cloc()
  return vim.fn.executable("cloc") == 1
end

local function human_size(bytes)
  if not bytes or bytes < 0 then return "0 B" end
  local units = { "B", "KB", "MB", "GB", "TB" }
  local i = 1
  while bytes >= 1024 and i < #units do
    bytes = bytes / 1024
    i = i + 1
  end
  return string.format("%.1f %s", bytes, units[i])
end

local function open_scratch()
  vim.cmd("vnew")
  local bufnr = vim.api.nvim_get_current_buf()
  vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].swapfile = false
  vim.wo.wrap = false
  vim.keymap.set("n", "q", "<cmd>bd!<cr>", { buffer = bufnr, silent = true })
  return bufnr
end

local function render(bufnr, lines)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
end

local function parse_cloc_json(json_str)
  local ok, data = pcall(vim.fn.json_decode, json_str)
  if not ok or not data then return nil, "Failed to parse cloc JSON" end

  local sum = data.SUM or {}
  local total_code = tonumber(sum.code or 0)
  local total_files = tonumber(sum.nFiles or sum.files or 0)

  local languages = {}
  for lang, stats in pairs(data) do
    if lang ~= "header" and lang ~= "SUM" and type(stats) == "table" then
      local code = tonumber(stats.code or 0)
      table.insert(languages, {
        lang = lang,
        code = code,
        percent = (total_code > 0) and (code / total_code * 100.0) or 0,
      })
    end
  end
  table.sort(languages, function(a, b) return a.code > b.code end)

  return {
    total_code = total_code,
    total_files = total_files,
    languages = languages,
  }, nil
end

local function parse_cloc_csv(csv_lines)
  -- Format: language,filename,blank,comment,code  (no header in some cloc versions; but often has one)
  -- Detect header if present.
  local files = {}
  local start_idx = 1
  if csv_lines[1] and csv_lines[1]:lower():find("^language,filename,blank,comment,code") then
    start_idx = 2
  end

  local uv = vim.uv or vim.loop
  for i = start_idx, #csv_lines do
    local line = csv_lines[i]
    if line and #line > 0 then
      -- naive CSV split (cloc outputs simple CSV without embedded commas in filename)
      local lang, file, blank, comment, code = line:match("^([^,]+),(.+),([^,]+),([^,]+),([^,]+)$")
      if lang and file and code then
        local st = uv.fs_stat(file)
        table.insert(files, {
          lang = lang,
          file = file,
          code = tonumber(code) or 0,
          size = st and st.size or 0,
        })
      end
    end
  end

  -- sort by size desc
  table.sort(files, function(a, b) return a.size > b.size end)
  return files
end

local function run_job(cmd, args, on_done)
  local Job = require("plenary.job")
  Job:new({
    command = cmd,
    args = args,
    on_exit = function(j, code)
      local out = table.concat(j:result(), "\n")
      local err = table.concat(j:stderr_result(), "\n")
      vim.schedule(function()
        on_done(code, out, err)
      end)
    end,
  }):start()
end

local function format_table(rows, headers)
  -- Pad simple columns for a clean mono look
  local widths = {}
  local all = {}
  if headers then table.insert(all, headers) end
  for _, r in ipairs(rows) do table.insert(all, r) end
  for _, row in ipairs(all) do
    for c, col in ipairs(row) do
      widths[c] = math.max(widths[c] or 0, vim.fn.strdisplaywidth(tostring(col)))
    end
  end
  local function fmt(row)
    local parts = {}
    for c, col in ipairs(row) do
      local pad = widths[c] - vim.fn.strdisplaywidth(tostring(col))
      table.insert(parts, tostring(col) .. string.rep(" ", pad + (c == #row and 0 or 2)))
    end
    return table.concat(parts)
  end
  local lines = {}
  if headers then
    table.insert(lines, fmt(headers))
    table.insert(lines, string.rep("─", (widths[1] or 0) + (widths[2] or 0) + (widths[3] or 0) + 6))
  end
  for _, r in ipairs(rows) do table.insert(lines, fmt(r)) end
  return lines
end

local function build_output(lang_summary, file_list)
  local lines = {}

  -- Headline
  table.insert(lines, "Project Code Statistics")
  table.insert(lines, string.rep("=", 24))
  table.insert(lines, "")

  -- Totals
  table.insert(lines, string.format("Total files: %d", lang_summary.total_files))
  table.insert(lines, string.format("Total code lines: %d", lang_summary.total_code))
  table.insert(lines, "")

  -- Language table
  table.insert(lines, "By Language")
  table.insert(lines, "-----------")
  local lang_rows = {}
  for _, L in ipairs(lang_summary.languages) do
    table.insert(lang_rows, {
      L.lang,
      string.format("%d", L.code),
      string.format("%.2f%%", L.percent),
    })
  end
  vim.list_extend(lines, format_table(lang_rows, { "Language", "Lines", "%" }))
  table.insert(lines, "")

  -- Largest files (top 15)
  if #file_list > 0 then
    table.insert(lines, "Largest Files (by size)")
    table.insert(lines, "-----------------------")
    local file_rows = {}
    for i = 1, math.min(15, #file_list) do
      local f = file_list[i]
      table.insert(file_rows, {
        f.lang,
        human_size(f.size),
        string.format("%d", f.code),
        f.file,
      })
    end
    vim.list_extend(lines, format_table(file_rows, { "Lang", "Size", "Code", "Path" }))
    table.insert(lines, "")
  end

  table.insert(lines, "Hints: press q to close. Re-run :CodeStats after big changes.")
  return lines
end

local function run_codestats()
  if not has_cloc() then
    vim.notify("cloc is not installed. Install it (e.g., `sudo apt install cloc` or `brew install cloc`).",
      vim.log.levels.ERROR)
    return
  end

  local bufnr = open_scratch()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "Running cloc…", "" })

  -- 1) Language summary (JSON)
  run_job("cloc", { ".", "--json" }, function(code1, out1, err1)
    if code1 ~= 0 then
      render(bufnr, { "cloc failed (summary).", err1 or "" })
      return
    end
    local summary, perr = parse_cloc_json(out1)
    if not summary then
      render(bufnr, { perr or "Parse error (summary)" })
      return
    end

    -- 2) By-file (CSV) for sizes + per-file lines
    run_job("cloc", { ".", "--by-file", "--csv" }, function(code2, out2, err2)
      if code2 ~= 0 then
        -- Still show language summary if per-file fails
        local lines = build_output(summary, {})
        render(bufnr, lines)
        vim.notify("cloc by-file step failed; showing language summary only.\n" .. (err2 or ""), vim.log.levels.WARN)
        return
      end
      local csv_lines = {}
      for s in (out2 .. "\n"):gmatch("(.-)\n") do table.insert(csv_lines, s) end
      local files = parse_cloc_csv(csv_lines)

      local lines = build_output(summary, files)
      render(bufnr, lines)
    end)
  end)
end

function M.setup()
  vim.api.nvim_create_user_command("CodeStats", run_codestats, {
    desc = "Show project language stats: files, lines, percentages, and largest files",
  })
end

return M

