-- Neovim: edit .docx as Markdown, round-trip via pandoc

-- ===== User options =====
vim.g.docx_md_flavour = vim.g.docx_md_flavour or "gfm"    -- gfm|markdown|commonmark|markdown_strict etc.
vim.g.docx_reference_docx = vim.g.docx_reference_docx or nil
-- Example: vim.g.docx_reference_docx = "/path/to/your/reference.docx"

-- ===== Implementation =====
local M = {}

local function have_pandoc()
  return vim.fn.executable("pandoc") == 1
end

local function shellesc(path)
  return vim.fn.shellescape(path)
end

local function mktemp(suffix)
  local tmp = vim.fn.tempname()
  if suffix and suffix ~= "" then tmp = tmp .. suffix end
  return tmp
end

-- Read .docx into a Markdown buffer
function M.read_word_to_md()
  if not have_pandoc() then
    vim.notify("pandoc not found in PATH", vim.log.levels.ERROR)
    return
  end

  local word_path = vim.api.nvim_buf_get_name(0)
  local md_flavour = vim.g.docx_md_flavour or "gfm"

  local media_dir = word_path .. ".media"
  local cmd = {
    "pandoc", "-f", "docx", "-t", md_flavour, "--extract-media=" .. media_dir, shellesc(word_path)
  }

  local markdown = vim.fn.system(table.concat(cmd, " "))
  if vim.v.shell_error ~= 0 then
    vim.notify("pandoc import failed:\n" .. markdown, vim.log.levels.ERROR)
    return
  end

  vim.bo.modifiable = true
  vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.split(markdown, "\n", { plain = true }))
  vim.bo.filetype = "markdown"
  vim.bo.buftype = "acwrite"
  vim.bo.swapfile = false

  vim.b.word_orig_path = word_path
  vim.b.word_media_dir = media_dir
  vim.b.word_md_flavour = md_flavour
  vim.b.word_bridge = true
end

-- Write Markdown buffer back to the original .docx
function M.write_md_to_word()
  if not have_pandoc() then
    vim.notify("pandoc not found in PATH", vim.log.levels.ERROR)
    return
  end
  if not vim.b.word_bridge or not vim.b.word_orig_path then
    vim.cmd("write")
    return
  end

  local dest_docx = vim.b.word_orig_path
  local md_flavour = vim.b.word_md_flavour or "gfm"

  local tmp_md = mktemp(".md")
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  vim.fn.writefile(lines, tmp_md, "b")

  local cmd = { "pandoc", "-f", md_flavour, "-t", "docx", shellesc(tmp_md), "-o", shellesc(dest_docx) }

  if vim.g.docx_reference_docx and vim.loop.fs_stat(vim.g.docx_reference_docx) then
    table.insert(cmd, "--reference-doc=" .. shellesc(vim.g.docx_reference_docx))
  end

  local out = vim.fn.system(table.concat(cmd, " "))
  if vim.v.shell_error ~= 0 then
    vim.notify("pandoc export failed:\n" .. out, vim.log.levels.ERROR)
    return
  end

  vim.bo.modified = false
  vim.notify("Saved → " .. dest_docx .. " (via pandoc)")
end

-- Autocmds for transparent round-trip
local grp = vim.api.nvim_create_augroup("DocxMarkdownBridge", { clear = true })

vim.api.nvim_create_autocmd("BufReadCmd", {
  group = grp,
  pattern = { "*.docx" },
  callback = function() M.read_word_to_md() end,
})

vim.api.nvim_create_autocmd("BufWriteCmd", {
  group = grp,
  pattern = { "*.docx" },
  callback = function() M.write_md_to_word() end,
})

vim.api.nvim_create_user_command("WordBridgeWrite", function() M.write_md_to_word() end, {})

return M

