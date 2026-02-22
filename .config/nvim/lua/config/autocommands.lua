vim.api.nvim_create_autocmd("FileType", {
    desc = "Turn off auto-inserting comments",
    group = vim.api.nvim_create_augroup("NoAutoInsertingComments", { clear = true }),
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Trim whitespace on save",
    group = vim.api.nvim_create_augroup("TrimWhiteSpace", { clear = true }),
    pattern = "*",
    callback = function()
        -- Save the current window view (cursor position, scroll, etc.)
        local save = vim.fn.winsaveview()

        -- Execute the substitution
        -- 'keeppatterns' prevents the search history from being cluttered
        -- 'e' flag ignores errors if no whitespace is found
        vim.cmd([[keeppatterns %s/\s\+$//e]])

        -- Restore the window view
        vim.fn.winrestview(save)
    end,
})

vim.api.nvim_create_autocmd("VimResized", {
    desc = "Automatically resize windows when the host window size changes",
    group = vim.api.nvim_create_augroup("WinResize", { clear = true }),
    pattern = "*",
    command = "wincmd =",
})

vim.api.nvim_create_autocmd("CursorMoved", {
    desc = "Highlight search until done",
    group = vim.api.nvim_create_augroup("AutoHlsearch", { clear = true }),
    callback = function()
        if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
            vim.schedule(function()
                vim.cmd.nohlsearch()
            end)
        end
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
