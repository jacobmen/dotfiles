return {
    {
        "linrongbin16/gitlinker.nvim",
        cmd = "GitLink",
        opts = {
            highlight_duration = 0,
        },
        keys = {
            {
                "<leader>gy",
                "<cmd>GitLink<cr>",
                mode = { "n", "v" },
                noremap = true,
                silent = true,
                desc = "Copy git permalink to clipboard",
            },
            {
                "<leader>gY",
                "<cmd>GitLink!<cr>",
                mode = { "n", "v" },
                noremap = true,
                silent = true,
                desc = "Open git permalink in browser",
            },
            {
                "<leader>gb",
                "<cmd>GitLink blame<cr>",
                mode = { "n", "v" },
                noremap = true,
                silent = true,
                desc = "Copy git blame permalink to clipboard",
            },
            {
                "<leader>gB",
                "<cmd>GitLink! blame<cr>",
                mode = { "n", "v" },
                noremap = true,
                silent = true,
                desc = "Open git blame permalink in browser",
            },
        },
    },
}
