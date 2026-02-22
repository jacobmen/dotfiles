return {
    {
        "rmagatti/auto-session",
        config = function()
            require("auto-session").setup({
                auto_restore_last_session = false,
                auto_session_last_session_dir = "",
                enabled = true,
                log_level = "error",
                root_dir = vim.fn.stdpath("data") .. "/sessions/",
            })
            vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
        end,
    },
}
