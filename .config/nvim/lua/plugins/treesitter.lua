return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")

            ts.install({
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
                "go",
                "haskell",
                "html",
                "java",
                "javascript",
                "json",
                "kotlin",
                "latex",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "nix",
                "python",
                "regex",
                "rust",
                "terraform",
                "tmux",
                "toml",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
            })

            vim.api.nvim_create_autocmd({ "Filetype" }, {
                callback = function(event)
                    local parsers = require("nvim-treesitter.parsers")
                    if not parsers[event.match] then
                        return
                    end

                    local ok, _ = pcall(vim.treesitter.start, event.buf)
                    if not ok then
                        local ft = vim.bo[event.buf].ft
                        vim.notify("TS grammer missing for: " .. ft)
                        return
                    end

                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
}
