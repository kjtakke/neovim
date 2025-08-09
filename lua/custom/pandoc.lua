-- Pandoc helpers -------------------------------------------------------------
local function have_pandoc()
  if vim.fn.executable("pandoc") == 1 then return true end
  vim.notify("pandoc not found in PATH", vim.log.levels.ERROR)
  return false
end

local function sys_sync(cmd_tbl)
  -- Neovim 0.10+ has vim.system; fall back to shell for older versions.
  if vim.system then
    local res = vim.system(cmd_tbl, { text = true }):wait()
    return res.code or 0, res.stdout or "", res.stderr or ""
  else
    local cmd = table.concat(vim.tbl_map(function(s) return vim.fn.shellescape(s) end, cmd_tbl), " ")
    local out = vim.fn.system(cmd)
    return vim.v.shell_error, out, out
  end
end

-- Prefer a lightweight PDF engine if available -------------------------------
local function pdf_engine_args()
  if vim.fn.executable("tectonic") == 1 then
    return { "--pdf-engine", "tectonic" }
  elseif vim.fn.executable("xelatex") == 1 then
    return { "--pdf-engine", "xelatex" }
  elseif vim.fn.executable("wkhtmltopdf") == 1 then
    return { "--pdf-engine", "wkhtmltopdf" }
  else
    return {} -- Let Pandoc use its default; may require a LaTeX install.
  end
end

-- :Ww — Markdown -> DOCX (only on .md files) --------------------------------
vim.api.nvim_create_user_command("Ww", function()
  if not have_pandoc() then return end
  local fname = vim.api.nvim_buf_get_name(0)
  if fname == "" then
    vim.notify("Please save the file first", vim.log.levels.WARN); return
  end
  if not fname:match("%.md$") then
    vim.notify(":Ww only works on Markdown (.md) files", vim.log.levels.WARN); return
  end
  vim.cmd.write()
  local out = fname:gsub("%.md$", ".docx")
  local code, _, err = sys_sync({ "pandoc", fname, "-o", out })
  if code == 0 then
    vim.notify("Exported DOCX → " .. out, vim.log.levels.INFO)
  else
    vim.notify("DOCX export failed: " .. (err or "unknown error"), vim.log.levels.ERROR)
  end
end, {})

-- :Wm — DOCX -> Markdown (only on .docx files) ------------------------------
vim.api.nvim_create_user_command("Wm", function()
  if not have_pandoc() then return end
  local fname = vim.api.nvim_buf_get_name(0)
  if fname == "" then
    vim.notify("Please save the file first", vim.log.levels.WARN); return
  end
  if not fname:match("%.docx$") then
    vim.notify(":Wm only works on DOCX (.docx) files", vim.log.levels.WARN); return
  end
  pcall(vim.cmd.write)
  local out = fname:gsub("%.docx$", ".md")
  local code, _, err = sys_sync({ "pandoc", "-f", "docx", "-t", "markdown", fname, "-o", out })
  if code == 0 then
    vim.notify("Exported Markdown → " .. out, vim.log.levels.INFO)
  else
    vim.notify("Markdown export failed: " .. (err or "unknown error"), vim.log.levels.ERROR)
  end
end, {})

-- :Wp — Markdown or DOCX -> PDF (on .md or .docx files) ---------------------
vim.api.nvim_create_user_command("Wp", function()
  if not have_pandoc() then return end
  local fname = vim.api.nvim_buf_get_name(0)
  if fname == "" then
    vim.notify("Please save the file first", vim.log.levels.WARN); return
  end
  if not (fname:match("%.md$") or fname:match("%.docx$")) then
    vim.notify(":Wp works only on .md or .docx files", vim.log.levels.WARN); return
  end

  pcall(vim.cmd.write) -- harmless if read-only

  local out = fname:gsub("%.[^%.]+$", ".pdf")

  local cmd = { "pandoc", fname, "-o", out }
  for _, a in ipairs(pdf_engine_args()) do table.insert(cmd, a) end

  local code, _, err = sys_sync(cmd)
  if code == 0 then
    vim.notify("Exported PDF → " .. out, vim.log.levels.INFO)
  else
    vim.notify("PDF export failed: " .. (err or "unknown error"), vim.log.levels.ERROR)
  end
end, {})

