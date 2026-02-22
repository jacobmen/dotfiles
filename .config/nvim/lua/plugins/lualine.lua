local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
        }
    end
end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "lewis6991/gitsigns.nvim",
    },
    opts = {
        options = {
            icons_enabled = true,
            theme = "gruvbox",
            always_divide_middle = true,
        },
        sections = {
            lualine_a = {
                "mode",
            },
            lualine_b = {
                "branch",
                { "diff", source = diff_sources },
                { "diagnostics", sources = { "nvim_diagnostic" } },
            },
            lualine_c = {
                {
                    "filename",
                    -- displays file status (read-only status, modified status)
                    file_status = true,
                    -- 0 = just filename, 1 = relative path, 2 = absolute path
                    path = 1,
                },
                {
                    "search",
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
    },
}
