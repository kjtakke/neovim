local M = {}

function M.safe_require(mod)
  local ok, pkg = pcall(require, mod)
  return ok and pkg or nil
end

return M

