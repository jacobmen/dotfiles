local common = require("common")
local diag_signs = common.diag_signs

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
        "jmckiern/vim-venter",
        keys = {
            { "<leader>v", ":VenterToggle<CR>", mode = "n", silent = true },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            sign_priority = 100,
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("neodev").setup()

            local lspconfig = require("lspconfig")
            local mason_lspconfig = require("mason-lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            mason_lspconfig.setup({
                ensure_installed = {
                    "clangd",
                    "lua_ls",
                    "pyright",
                    "rust_analyzer",
                    "texlab",
                    "tsserver",
                },
            })

            mason_lspconfig.setup_handlers({
                -- default handler
                function(server_name)
                    lspconfig[server_name].setup({
                        on_attach = function(client, bufnr)
                            --Enable completion triggered by <c-x><c-o>
                            vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

                            -- Mappings.
                            local opts = { noremap = true, silent = true, buffer = bufnr }

                            -- See `:help vim.lsp.*` for documentation on any of the below functions
                            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
                            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                            vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
                            vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
                            vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
                            vim.keymap.set("n", "<leader>wl", function()
                                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                            end, opts)

                            vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename, opts)

                            vim.keymap.set({ "n", "v" }, "<leader>ga", vim.lsp.buf.code_action, opts)
                            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
                            vim.keymap.set("n", "<leader>f", function()
                                vim.lsp.buf.format({ async = true })
                            end, opts)

                            vim.keymap.set("n", "<leader>gn", vim.diagnostic.goto_next, opts)
                            vim.keymap.set("n", "<leader>gN", vim.diagnostic.goto_prev, opts)
                            vim.keymap.set("n", "<leader>cc", vim.diagnostic.open_float, opts)
                        end,
                        capabilities = server_name == "clangd" and { offsetEncoding = "utf-8" } or capabilities,
                    })
                end,
            })

            local signs = {
                Error = diag_signs.error,
                Warn = diag_signs.warn,
                Hint = diag_signs.hint,
                Info = diag_signs.info,
            }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",           -- source for text in buffer
            "hrsh7th/cmp-path",             -- source for file system paths
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",             -- snippet engine
            "saadparwaiz1/cmp_luasnip",     -- for autocompletion
            "rafamadriz/friendly-snippets", -- useful snippets
            "onsails/lspkind.nvim",         -- vs-code like pictograms
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            -- loads vscode style snippets from installed plugins
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                completion = {
                    completeopt = "menu,menuone,preview,noselect",
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                    ["<C-e>"] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                    { name = "buffer" },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol",
                        maxwidth = 50,
                        ellipsis_char = "...",
                    }),
                },
            })

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })

            local cmp_autopairs = require("nvim-autopairs.completion.cmp")

            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

            vim.cmd([[highlight! default link CmpItemKind CmpItemMenuDefault]])
        end,
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
            "nvim-tree/nvim-web-devicons",
            "debugloop/telescope-undo.nvim",
            "ThePrimeagen/harpoon",
            "folke/trouble.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local undo_actions = require("telescope-undo.actions")
            local trouble = require("trouble.providers.telescope")

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
                            ["<c-t>"] = trouble.open_with_trouble,
                        },
                        n = {
                            ["<c-t>"] = trouble.open_with_trouble,
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
            telescope.load_extension("harpoon")

            -- Adds line numbers to preview buffers
            vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")

            local keymap = vim.keymap
            keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>")
            keymap.set("n", "<C-f>", "<cmd>Telescope live_grep<cr>")
            keymap.set("n", "<leader>/", "<cmd>Telescope grep_string<cr>")
            keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
        end,
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
                "java",
                "javascript",
                "json",
                "latex",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "python",
                "regex",
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
            signs = {
                error = diag_signs.error,
                warning = diag_signs.warn,
                hint = diag_signs.hint,
                information = diag_signs.info,
                other = diag_signs.other,
            },
        },
        keys = {
            { "<leader>xx", ":TroubleToggle<cr>",                     mode = "n", noremap = true, silent = true },
            { "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", mode = "n", noremap = true, silent = true },
            { "<leader>xt", "<cmd>Trouble telescope<cr>",             mode = "n", noremap = true, silent = true },
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
    {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "williamboman/mason.nvim",
            "jay-babu/mason-null-ls.nvim",
        },
        config = function()
            -- TODO: replace null-ls https://www.youtube.com/watch?v=ybUE4D80XSk
            local null_ls = require("null-ls")

            local code_actions = null_ls.builtins.code_actions
            local formatting = null_ls.builtins.formatting
            local diagnostics = null_ls.builtins.diagnostics

            null_ls.setup({
                sources = {
                    code_actions.gitsigns,

                    formatting.stylua,
                    formatting.black,

                    -- Docker linting
                    diagnostics.hadolint,
                    diagnostics.markdownlint,
                    diagnostics.shellcheck,
                    diagnostics.yamllint,
                    diagnostics.checkmake,
                },
            })

            require("mason-null-ls").setup({
                ensure_installed = nil,
                automatic_installation = true,
                automatic_setup = false,
            })
        end,
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
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()

            vim.keymap.set("n", "<leader>hx", function()
                harpoon:list():append()
            end, { desc = "Add to harpoon list" })
            vim.keymap.set("n", "<leader>hX", function()
                harpoon:list():remove()
            end, { desc = "Remove from harpoon list" })
            vim.keymap.set("n", "<leader>hM", function()
                harpoon:list():clear()
            end, { desc = "Clear harpoon list" })

            vim.keymap.set("n", "<leader>hn", function()
                harpoon:list():next()
            end, { desc = "Next harpoon entry" })
            vim.keymap.set("n", "<leader>hp", function()
                harpoon:list():prev()
            end, { desc = "Previous harpoon entry" })

            vim.keymap.set("n", "<leader>hh", ":Telescope harpoon marks<CR>", { desc = "Open harpoon list" })
        end,
    },
}
