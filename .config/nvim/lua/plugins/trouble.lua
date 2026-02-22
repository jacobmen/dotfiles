return {
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            padding = false,
            action_keys = {
                cancel = "<c-c>", -- cancel the preview and get back to last window / buffer / cursor
            },
        },
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                mode = "n",
                noremap = true,
                silent = true,
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                mode = "n",
                noremap = true,
                silent = true,
            },
        },
    },
}
