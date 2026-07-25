return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "TSUpdate",
                callback = function()
                    require("nvim-treesitter.parsers").tmux = {
                        install_info = {
                            url = "https://github.com/Freed-Wu/tree-sitter-tmux",
                            revision = "bd334851188206824595987350c0bfb60ff76f75",
                            branch = "master",
                            location = "./",
                            generate = true,
                            generate_from_json = false,
                            queries = "queries",
                        },
                        tier = 1,
                    }
                end,
            })

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
                "sql",
                "terraform",
                "tmux",
                "toml",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
                "zig",
            })

            vim.api.nvim_create_autocmd({ "FileType" }, {
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
