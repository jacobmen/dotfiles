return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            default_file_explorer = true,
            keymaps = {
                ["<leader>?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-v>"] = "actions.select_vsplit",
                ["<C-s>"] = "actions.select_split",
                ["<C-t>"] = "actions.select_tab",
                ["<leader>p"] = "actions.preview",
                ["<C-c>"] = "actions.close",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["`"] = "actions.cd",
                ["~"] = "actions.tcd",
                ["<leader>s"] = "actions.change_sort",
                ["<leader>x"] = "actions.open_external",
                ["<leader>."] = "actions.toggle_hidden",
            },
            use_default_keymaps = false,
            view_options = {
                show_hidden = true,
            },
        },
        keys = {
            {
                "<leader>tt",
                ":Oil<cr>",
                mode = "n",
                noremap = true,
                silent = true,
            },
        },
    },
}
