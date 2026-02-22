return {
    "lervag/vimtex",
    lazy = false,
    init = function()
        vim.g.vimtex_view_method = "zathura"
        -- use blink.cmp for completion
        vim.g.vimtex_complete_enabled = 0
        -- use TreeSitter for syntax
        vim.g.vimtex_syntax_enabled = 0
        -- no insert mode mappings since we have snippets
        vim.g.vimtex_imaps_enabled = 0
    end,
}
