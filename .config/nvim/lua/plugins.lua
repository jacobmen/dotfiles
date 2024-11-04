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
            "smjonas/inc-rename.nvim",
            "aznhe21/actions-preview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("mason").setup()

            local lspconfig = require("lspconfig")
            local mason_lspconfig = require("mason-lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local actions_preview = require("actions-preview")
            local telescope_builtins = require("telescope.builtin")

            mason_lspconfig.setup({
                ensure_installed = {
                    "clangd",
                    "lua_ls",
                    "pyright",
                    "rust_analyzer",
                    "texlab",
                    "ts_ls",
                },
            })

            mason_lspconfig.setup_handlers({
                -- default handler
                function(server_name)
                    lspconfig[server_name].setup({
                        on_attach = function(client, bufnr)
                            --Enable completion triggered by <c-x><c-o>
                            vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

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

                            vim.keymap.set("n", "<leader>rr", function()
                                return ":IncRename " .. vim.fn.expand("<cword>")
                            end, { expr = true })

                            vim.keymap.set({ "n", "v" }, "<leader>ga", actions_preview.code_actions, opts)
                            vim.keymap.set("n", "<leader>gr", telescope_builtins.lsp_references, opts)
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
            -- source for text in buffer
            "hrsh7th/cmp-buffer",
            -- source for file system paths
            "hrsh7th/cmp-path",
            -- source for command line
            "hrsh7th/cmp-cmdline",
            -- snippet engine
            "L3MON4D3/LuaSnip",
            -- for autocompletion
            "saadparwaiz1/cmp_luasnip",
            -- useful snippets
            "rafamadriz/friendly-snippets",
            -- vs-code like pictograms
            "onsails/lspkind.nvim",
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
                ---@diagnostic disable-next-line: missing-fields
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol",
                        maxwidth = 50,
                        ellipsis_char = "...",
                    }),
                },
                ---@diagnostic disable-next-line: missing-fields
                performance = {
                    debounce = 0,
                    throttle = 0,
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
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            -- UI library
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
            "smjonas/inc-rename.nvim",
        },
        config = function()
            require("noice").setup({
                messages = {
                    view_search = false,
                },
                routes = {
                    {
                        filter = {
                            event = "msg_show",
                            kind = "",
                            find = "written",
                        },
                        opts = { skip = true },
                    },
                },
                lsp = {
                    progress = {
                        enabled = false,
                    },
                    -- override markdown rendering so that cmp and other plugins use Treesitter
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                presets = {
                    inc_rename = true,
                    lsp_doc_border = true,
                },
            })
        end,
    },
    {
        "smjonas/inc-rename.nvim",
        opts = {},
    },
    {
        "aznhe21/actions-preview.nvim",
        config = function()
            require("actions-preview").setup({
                highlight_command = {
                    require("actions-preview.highlight").delta("delta --no-gitconfig --side-by-side"),
                },
                telescope = {
                    sorting_strategy = "ascending",
                    layout_strategy = "vertical",
                    layout_config = {
                        width = 0.7,
                        height = 0.9,
                        prompt_position = "top",
                        preview_cutoff = 20,
                        preview_height = function(_, _, max_lines)
                            return max_lines - 15
                        end,
                    },
                },
            })
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
        event = "VimEnter",
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
                            ["<c-t>"] = trouble.open,
                        },
                        n = {
                            ["<c-t>"] = trouble.open,
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
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "folke/noice.nvim",
        },
        config = function()
            local noice = require("noice")

            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "gruvbox",
                    always_divide_middle = true,
                },
                sections = {
                    lualine_a = {
                        {
                            noice.api.status.mode.get,
                            cond = noice.api.status.mode.has,
                        },
                    },
                    lualine_b = { "branch", "diff", { "diagnostics", sources = { "nvim_diagnostic" } } },
                    lualine_c = {
                        {
                            "filename",
                            -- displays file status (readonly status, modified status)
                            file_status = true,
                            -- 0 = just filename, 1 = relative path, 2 = absolute path
                            path = 1,
                        },
                        {
                            noice.api.status.search.get,
                            cond = noice.api.status.search.has,
                            color = { fg = "#ff9e64" },
                        },
                    },
                    lualine_x = {
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
            })
        end,
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
            "gbprod/none-ls-shellcheck.nvim",
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
                    diagnostics.yamllint,
                    diagnostics.checkmake,
                },
            })

            null_ls.register(require("none-ls-shellcheck.diagnostics"))
            null_ls.register(require("none-ls-shellcheck.code_actions"))

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
        "folke/lazydev.nvim",
        dependencies = {
            { "Bilal2453/luvit-meta", lazy = true },
        },
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
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
    -- Auto detect tabs/spaces in project and adjust settings
    "tpope/vim-sleuth",
}
