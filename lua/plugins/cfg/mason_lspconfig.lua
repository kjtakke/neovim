require("mason-lspconfig").setup({
  ensure_installed = {
    -- Web
    "html","cssls","emmet_ls","vtsls","eslint","jsonls",
    -- Backend
    "pyright","bashls","lua_ls","gopls","rust_analyzer","clangd","dockerls","yamlls","graphql",
    -- Java / .NET / JVM
    "jdtls","kotlin_language_server","lemminx","omnisharp",
    -- Database / Configs
    "sqlls","taplo",
    -- Others
    "perlpls","powershell_es","ansiblels","terraformls",
    -- Markdown & docs
    "marksman","ltex",
  },
})

