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
vim.opt.lazyredraw = true

-- disable mouse clicking and scrolling
vim.keymap.set("", "<up>", "<nop>", { noremap = true })
vim.keymap.set("", "<down>", "<nop>", { noremap = true })
vim.keymap.set("i", "<up>", "<nop>", { noremap = true })
vim.keymap.set("i", "<down>", "<nop>", { noremap = true })
vim.opt.mouse = ""

vim.opt.inccommand = "nosplit"
vim.opt.laststatus = 3

-- Give more space for displaying messages.
vim.opt.cmdheight = 2

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append({ c = true })

vim.opt.colorcolumn = "100"
vim.cmd.highlight({ "ColorColumn", "ctermbg=0", "guibg=lightgrey" })

-- allow for LSP diagnostics and git signs to exist side by side
vim.cmd("set signcolumn=auto:2")

-- Easier split movement
vim.keymap.set("", "<C-h>", "<C-w>h")
vim.keymap.set("", "<C-j>", "<C-w>j")
vim.keymap.set("", "<C-k>", "<C-w>k")
vim.keymap.set("", "<C-l>", "<C-w>l")

vim.g.loaded_matchparen = 1
vim.keymap.set("n", "<Space>", "<NOP>")
vim.g.mapleader = " "

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
if not vim.loop.fs_stat(lazypath) then
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
    " Plugin options
    let g:vimwiki_list = [{'path': '~/vimwiki/',
                          \ 'syntax': 'markdown', 'ext': '.md'}]
]])

vim.g.do_filetype_lua = 1
