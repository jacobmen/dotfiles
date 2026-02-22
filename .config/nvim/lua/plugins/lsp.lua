vim.lsp.enable({
    "lua_ls",
    "nixd",
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(event)
        local actions_preview = require("actions-preview")
        local telescope_builtins = require("telescope.builtin")

        --Enable completion triggered by <c-x><c-o>
        vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = event.buf })
        -- Enable virtual text
        vim.diagnostic.config({
            update_in_insert = true,
            virtual_text = true,
        })

        -- Mappings
        local opts = { noremap = true, silent = true, buffer = event.buf }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        vim.keymap.set("n", "<leader>gd", telescope_builtins.lsp_definitions, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>gi", telescope_builtins.lsp_implementations, opts)
        vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)

        vim.keymap.set("n", "<leader>rr", function()
            return ":IncRename " .. vim.fn.expand("<cword>")
        end, { expr = true })

        vim.keymap.set({ "n", "v" }, "<leader>ga", actions_preview.code_actions, opts)
        vim.keymap.set("n", "<leader>gr", telescope_builtins.lsp_references, opts)

        vim.keymap.set("n", "<leader>gn", function()
            vim.diagnostic.jump({ count = 1, float = true }) -- next diagnostic
        end, opts)
        vim.keymap.set("n", "<leader>gN", function()
            vim.diagnostic.jump({ count = -1, float = true }) -- previous diagnostic
        end, opts)

        vim.keymap.set("n", "<leader>cc", vim.diagnostic.open_float, opts)

        -- toggle inlay hints if supported
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            vim.keymap.set("n", "<leader>h", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, opts)
        end
    end,
})

vim.cmd("set completeopt+=noselect")

return {
    {
        "smjonas/inc-rename.nvim",
        opts = {},
    },
    {
        "aznhe21/actions-preview.nvim",
        config = function()
            require("actions-preview").setup({
                highlight_command = {
                    require("actions-preview.highlight").delta("delta --no-gitconfig --side-by-side"),
                },
                telescope = {
                    sorting_strategy = "ascending",
                    layout_strategy = "vertical",
                    layout_config = {
                        width = 0.7,
                        height = 0.9,
                        prompt_position = "top",
                        preview_cutoff = 20,
                        preview_height = function(_, _, max_lines)
                            return max_lines - 15
                        end,
                    },
                },
            })
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        version = "v2.*",
        build = "make install_jsregexp",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
    {
        "saghen/blink.cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "aznhe21/actions-preview.nvim",
            "folke/lazydev.nvim",
            "smjonas/inc-rename.nvim",
        },
        -- use a release tag to download pre-built binaries
        version = "1.*",
        opts_extend = { "sources.default" },
        config = function()
            local blink = require("blink-cmp")
            blink.setup({
                keymap = {
                    -- ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
                    -- ['<C-e>'] = { 'hide', 'fallback' },
                    --
                    -- ['<Tab>'] = {
                    --   function(cmp)
                    --     if cmp.snippet_active() then return cmp.accept()
                    --     else return cmp.select_and_accept() end
                    --   end,
                    --   'snippet_forward',
                    --   'fallback'
                    -- },
                    -- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
                    --
                    -- ['<Up>'] = { 'select_prev', 'fallback' },
                    -- ['<Down>'] = { 'select_next', 'fallback' },
                    -- ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
                    -- ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
                    --
                    -- ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
                    -- ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
                    --
                    -- ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
                    preset = "super-tab",
                    ["<CR>"] = { "accept", "fallback" },
                },
                appearance = {
                    nerd_font_variant = "mono",
                },
                completion = {
                    documentation = { auto_show = true },
                    trigger = {
                        show_in_snippet = false,
                    },
                    list = {
                        cycle = {
                            from_top = false,
                        },
                    },
                },
                snippets = {
                    preset = "luasnip",
                },
                sources = {
                    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                    providers = {
                        lazydev = {
                            name = "LazyDev",
                            module = "lazydev.integrations.blink",
                            -- make lazydev completions top priority (see `:h blink.cmp`)
                            score_offset = 100,
                        },
                    },
                },
                fuzzy = { implementation = "prefer_rust_with_warning" },
            })
        end,
    },
}
