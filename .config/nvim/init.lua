vim.opt.showmatch = false

vim.opt.relativenumber = true
vim.opt.nu = true

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.hidden = true
vim.opt.errorbells = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.autoindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.undofile = true

vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.spell = true
vim.opt.spelllang = { "en_us" }

-- disable mouse clicking and scrolling
vim.keymap.set("", "<up>", "<nop>", { noremap = true })
vim.keymap.set("", "<down>", "<nop>", { noremap = true })
vim.keymap.set("i", "<up>", "<nop>", { noremap = true })
vim.keymap.set("i", "<down>", "<nop>", { noremap = true })
vim.opt.mouse = ""

vim.opt.inccommand = "split"
vim.opt.laststatus = 3

-- Give more space for displaying messages.
vim.opt.cmdheight = 2

-- Having longer update time (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append({ c = true })
-- Don't show "x lines less" / "x lines yanked" messages
vim.opt.report = 9999

vim.opt.colorcolumn = "100"
vim.cmd.highlight({ "ColorColumn", "ctermbg=0", "guibg=lightgrey" })

-- allow for LSP diagnostics and git signs to exist side by side
vim.cmd("set signcolumn=auto:2")

-- Easier split movement
vim.keymap.set("", "<C-h>", "<C-w>h")
vim.keymap.set("", "<C-j>", "<C-w>j")
vim.keymap.set("", "<C-k>", "<C-w>k")
vim.keymap.set("", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<Space>", "<NOP>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Replace highlighted
vim.keymap.set("v", "<leader>p", '"_dP')
vim.keymap.set("v", "X", '"_d')

-- Better escape key
vim.keymap.set("i", "<C-c>", "<esc>")

-- Keep searches at center of screen when jumping
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Include relative jumps in jumplist for <C-o>
-- TODO: convert to lua commands
vim.cmd([[
    nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'gk'
    nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'gj'
]])

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

vim.cmd([[
    runtime ./autocommands.vim
]])

vim.g.do_filetype_lua = 1

vim.g.clipboard = {
    name = "OSC 52",
    copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
        ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
        ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
}

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
