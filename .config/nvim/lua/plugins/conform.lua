return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                mode = "",
                desc = "[F]ormat buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                nix = { "alejandra" },
                tex = { "tex-fmt" },
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
            format_on_save = { timeout_ms = 500 },
            notify_on_error = true,
            notify_no_formatters = true,
        },
    },
}
