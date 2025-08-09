-- Ensure ~/.config/nvim/spell exists
local spell_dir = vim.fn.stdpath("config") .. "/spell"
if vim.fn.isdirectory(spell_dir) == 0 then
  vim.fn.mkdir(spell_dir, "p")
end

-- Pretty right split showing first spelling issue per line, aligned
local function show_spellcheck_issues_aligned()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local total = #lines

  local padded_results = {}
  for i = 1, total do padded_results[i] = "" end

  for i, line in ipairs(lines) do
    local col = 0
    while col < #line do
      local spell_result = vim.fn.spellbadword(line:sub(col + 1))
      local bad_word = spell_result[1]
      if bad_word and bad_word ~= "" then
        local rel_start = line:sub(col + 1):find(bad_word, 1, true)
        if rel_start then
          padded_results[i] = string.format("Line %-4d | %-20s | %s", i, bad_word, line)
          break
        else
          col = col + 1
        end
      else
        break
      end
    end
  end

  local any = false
  for _, v in ipairs(padded_results) do if v ~= "" then any = true break end end
  if not any then return vim.notify("No spelling issues found.", vim.log.levels.INFO) end

  local main_win = vim.api.nvim_get_current_win()
  vim.cmd("rightbelow vsplit")
  local split_buf = vim.api.nvim_create_buf(false, true)
  local split_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(split_win, split_buf)

  vim.api.nvim_buf_set_lines(split_buf, 0, -1, false, padded_results)
  vim.bo[split_buf].bufhidden = "wipe"
  vim.bo[split_buf].filetype  = "spellcheck"
  vim.bo[split_buf].modifiable = false
  vim.bo[split_buf].readonly   = true
  vim.wo[split_win].wrap = false

  vim.wo[main_win].scrollbind = true
  vim.wo[split_win].scrollbind = true

  vim.api.nvim_win_set_cursor(main_win, {1,0})
  vim.api.nvim_win_set_cursor(split_win, {1,0})
end

vim.keymap.set("n", "<leader>sc", show_spellcheck_issues_aligned, { desc = "Show spelling issues in aligned right split" })

