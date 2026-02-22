return {
    {
        "danymat/neogen",
        opts = {
            snippet_engine = "luasnip",
        },
        keys = {
            {
                "<leader>d",
                function()
                    require("neogen").generate({})
                end,
                mode = "n",
                noremap = true,
                silent = true,
            },
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
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
        },
    },
}
