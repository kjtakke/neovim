local lspconfig = require("lspconfig")

lspconfig.pyright.setup({
  on_attach = function(_, bufnr)
    -- Format on save (optional)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function() vim.lsp.buf.format() end,
    })
  end
})
