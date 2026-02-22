return {
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                italic = {
                    strings = false,
                    comments = false,
                    operators = false,
                    folds = false,
                    emphasis = false,
                },
                dim_inactive = false,
                transparent_mode = false,
            })
            vim.o.background = "dark"
            vim.cmd.colorscheme("gruvbox")
        end,
    },
}
