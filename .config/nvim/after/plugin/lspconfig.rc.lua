require("mason").setup()
require("neodev").setup()

local nvim_lsp = require("lspconfig")
local mason_lsp = require("mason-lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

mason_lsp.setup({
    ensure_installed = {
        "clangd",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "texlab",
        "tsserver",
    },
})

mason_lsp.setup_handlers({
    -- default handler
    function(server_name)
        nvim_lsp[server_name].setup({
            on_attach = require("lsp_utils").on_attach,
            capabilities = server_name == "clangd" and { offsetEncoding = "utf-8" } or capabilities,
        })
    end,
})
