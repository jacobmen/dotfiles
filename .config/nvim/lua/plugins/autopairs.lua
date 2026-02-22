return {
    {
        -- TODO: investigate setup with blink
        "windwp/nvim-autopairs",
        event = "InsertEnter",
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
}
