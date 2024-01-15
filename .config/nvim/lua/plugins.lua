return {
    {
        "folke/lazy.nvim",
        defaults = {
            lazy = true,
        },
    },
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
        config = function()
            vim.g.tmux_navigator_no_wrap = 1
        end,
    },
    {
        "rmagatti/auto-session",
        config = function()
            require("auto-session").setup({
                log_level = "error",
                auto_session_enabled = true,
                auto_session_enable_last_session = false,
                auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
                auto_session_last_session_dir = "",
            })
            vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
        end,
    },
    {
        "windwp/nvim-autopairs",
        config = function()
            local autopairs = require("nvim-autopairs")
            autopairs.setup({
                disable_filetype = { "TelescopePrompt", "vim" },
            })

            local rule = require("nvim-autopairs.rule")
            local cond = require("nvim-autopairs.conds")

            autopairs.add_rules({
                rule("$", "$", { "tex", "latex" })
                    -- Move over $ if next character
                    :with_move(function(opts)
                        return opts.next_char == opts.char
                    end)
                    -- Don't insert pair if previous character escapes $
                    :with_pair(
                        cond.not_before_regex("\\", 1)
                    ),
                rule("\\[", "\\]", { "tex", "latex" })
                    -- don't move right when character repeated
                    :with_move(cond.none()),
            })
        end,
    },
    {
        "numToStr/Comment.nvim",
        opts = {
            ignore = "^$", -- ignore empty lines
        },
    },
    -- Doc generation (<leader>d)
    {
        "danymat/neogen",
        opts = {
            snippet_engine = "luasnip",
        },
        keys = {
            {
                "<leader>d",
                ":lua require('neogen').generate()<CR>",
                mode = "n",
                noremap = true,
                silent = true,
            },
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "L3MON4D3/LuaSnip",
        },
        version = "*",
    },
    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", ":UndotreeToggle<CR>", mode = "n", silent = true },
        },
    },
    {
        "jmckiern/vim-venter",
        keys = {
            { "<leader>v", ":VenterToggle<CR>", mode = "n", silent = true },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {},
    },
    "neovim/nvim-lspconfig",
    {
        "tami5/lspsaga.nvim",
        lazy = false,
        config = function()
            require("lspsaga").init_lsp_saga({
                debug = false,
                use_saga_diagnostic_sign = true,
                -- diagnostic sign
                error_sign = "",
                warn_sign = "",
                hint_sign = "",
                infor_sign = "",
                diagnostic_header_icon = "",
                -- code action title icon
                code_action_icon = "〉",
                code_action_prompt = {
                    enable = false,
                    sign = true,
                    sign_priority = 40,
                    virtual_text = true,
                },
                finder_definition_icon = "",
                finder_reference_icon = "",
                max_preview_lines = 10,
                finder_action_keys = {
                    open = "<CR>",
                    vsplit = "<C-v>",
                    split = "<C-S>",
                    quit = "<C-c>",
                    scroll_down = "<C-f>",
                    scroll_up = "<C-b>",
                },
                code_action_keys = {
                    quit = "<C-c>",
                    exec = "<CR>",
                },
                rename_action_keys = {
                    quit = "<C-c>",
                    exec = "<CR>",
                },
                definition_preview_icon = "",
                border_style = "single",
                rename_prompt_prefix = "➤",
                server_filetype_map = {},
                diagnostic_prefix_format = "%d. ",
            })
        end,
    },
    {
        "hrsh7th/cmp-nvim-lsp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
        },
    },
    {
        "rcarriga/nvim-notify",
        config = function()
            vim.notify = require("notify")
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                config = function()
                    require("telescope").load_extension("fzf")
                end,
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        main = "nvim-treesitter.configs",
        opts = {
            highlight = {
                enable = true,
            },
            indent = {
                enable = false,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    scope_incremental = "<CR>",
                    node_incremental = "<TAB>",
                    node_decremental = "<S-TAB>",
                },
            },
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "css",
                "diff",
                "dockerfile",
                "git_config",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "html",
                "javascript",
                "json",
                "latex",
                "lua",
                "make",
                "markdown",
                "python",
                "rust",
                "toml",
                "typescript",
                "haskell",
                "vim",
                "vimdoc",
                "yaml",
            },
        },
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            padding = false,
            action_keys = {
                cancel = "<c-c>", -- cancel the preview and get back to last window / buffer / cursor
            },
        },
        keys = {
            { "<leader>xx", ":TroubleToggle<cr>", mode = "n", noremap = true, silent = true },
            { "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", mode = "n", noremap = true, silent = true },
            { "<leader>xt", "<cmd>Trouble telescope<cr>", mode = "n", noremap = true, silent = true },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                icons_enabled = true,
                theme = "gruvbox",
                always_divide_middle = true,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", { "diagnostics", sources = { "nvim_diagnostic" } } },
                lualine_c = {
                    {
                        "filename",
                        -- displays file status (readonly status, modified status)
                        file_status = true,
                        -- 0 = just filename, 1 = relative path, 2 = absolute path
                        path = 1,
                    },
                },
                lualine_x = {
                    "encoding",
                    "filetype",
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            extensions = {},
        },
    },
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
            })
            vim.o.background = "dark"
            vim.cmd([[colorscheme gruvbox]])
        end,
    },
    "lervag/vimtex",
    "vimwiki/vimwiki",
    {
        "anuvyklack/windows.nvim",
        dependencies = "anuvyklack/middleclass",
        opts = {
            autowidth = {
                enable = false,
            },
            animation = {
                enable = false,
            },
        },
        keys = {
            { "<C-w>o", "<Cmd>WindowsMaximize<CR>", mode = "n" },
        },
    },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "jayp0521/mason-null-ls.nvim",
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = "nvim-lua/plenary.nvim",
    },
    {
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        opts = {
            signs = false,
        },
    },
    {
        "linrongbin16/gitlinker.nvim",
        opts = {
            highlight_duration = 0,
        },
        keys = {
            -- Copy git permalink to clipboard
            {
                "<leader>gy",
                "<cmd>GitLink<cr>",
                mode = { "n", "v" },
                noremap = true,
                silent = true,
            },
            -- Open git permalink in browser
            {
                "<leader>gY",
                "<cmd>GitLink!<cr>",
                mode = { "n", "v" },
                noremap = true,
                silent = true,
            },
            -- Copy git blame permalink to clipboard
            {
                "<leader>gb",
                "<cmd>GitLink blame<cr>",
                mode = { "n", "v" },
                noremap = true,
                silent = true,
            },
            -- Open git blame permalink in browser
            {
                "<leader>gB",
                "<cmd>GitLink! blame<cr>",
                mode = { "n", "v" },
                noremap = true,
                silent = true,
            },
        },
    },
    {
        "tzachar/highlight-undo.nvim",
        opts = {
            duration = 200,
        },
    },
    {
        "folke/neodev.nvim",
    },
    {
        "ibhagwan/smartyank.nvim",
        opts = {
            highlight = {
                timeout = 200,
            },
            clipboard = {
                enabled = false,
            },
        },
    },
    {
        "j-hui/fidget.nvim",
        opts = {},
    },
    {
        "RRethy/vim-illuminate",
        config = function()
            require("illuminate").configure({
                filetypes_denylist = {
                    "dirvish",
                    "fugitive",
                    "TelescopePrompt",
                },
            })
        end,
    },
    {
        -- add surrounding: ys{motion}{char}
        -- change surrounding: cs{target}{replacement}
        -- delete surrounding: ds[char]
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },
    -- highlight search until done
    "romainl/vim-cool",
}
