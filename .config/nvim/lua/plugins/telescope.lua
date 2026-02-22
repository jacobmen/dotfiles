return {
    {
        "nvim-telescope/telescope.nvim",
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "debugloop/telescope-undo.nvim",
            "folke/trouble.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        keys = {
            {
                "<C-p>",
                "<cmd>Telescope find_files<cr>",
                mode = "n",
            },
            {
                "<C-f>",
                "<cmd>Telescope live_grep<cr>",
                mode = "n",
            },
            {
                "<leader>/",
                "<cmd>Telescope grep_string<cr>",
                mode = "n",
                desc = "Search for string under cursor",
            },
            {
                "<leader>u",
                "<cmd>Telescope undo<cr>",
                mode = "n",
                desc = "Search past actions",
            },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local undo_actions = require("telescope-undo.actions")
            local trouble = require("trouble.sources.telescope")

            telescope.setup({
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                },
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-s>"] = actions.select_horizontal,
                            ["<C-t>"] = trouble.open,
                        },
                        n = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-t>"] = trouble.open,
                        },
                    },
                    file_ignore_patterns = {
                        "^.git/",
                    },
                    vimgrep_arguments = {
                        "rg",
                        "--hidden",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                    },
                },
                extensions = {
                    undo = {
                        use_delta = true,
                        layout_strategy = "vertical",
                        layout_config = {
                            preview_height = 0.8,
                        },
                        mappings = {
                            i = {
                                ["<cr>"] = undo_actions.restore,
                            },
                            n = {
                                ["<cr>"] = undo_actions.restore,
                            },
                        },
                    },
                },
            })

            telescope.load_extension("fzf")
            telescope.load_extension("undo")

            -- Adds line numbers to preview buffers
            vim.api.nvim_create_autocmd("User", {
                pattern = "TelescopePreviewerLoaded",
                callback = function()
                    vim.opt_local.number = true
                end,
            })
        end,
    },
}
