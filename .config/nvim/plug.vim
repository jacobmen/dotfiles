if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

Plug 'rmagatti/auto-session'

" Autopairs
Plug 'windwp/nvim-autopairs'

" Comments
Plug 'numToStr/Comment.nvim'

" Doc generation
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

" Undo Tree (<leader>u)
Plug 'mbbill/undotree'

" Venter
Plug 'jmckiern/vim-venter'

" Gitsigns
Plug 'lewis6991/gitsigns.nvim'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'tami5/lspsaga.nvim'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

" Registers
Plug 'tversteeg/registers.nvim', { 'branch': 'main' }

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Trouble
Plug 'folke/trouble.nvim'

" Lualine
Plug 'nvim-lualine/lualine.nvim'

" Colorscheme
Plug 'gruvbox-community/gruvbox'
Plug 'sainnhe/gruvbox-material'

" Latex
Plug 'lervag/vimtex'

" Vimwiki
Plug 'vimwiki/vimwiki'

call plug#end()

