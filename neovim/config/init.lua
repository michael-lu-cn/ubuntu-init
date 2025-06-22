-- Neovim配置文件

-- 基础设置
vim.opt.number = true                -- 显示行号
vim.opt.relativenumber = true        -- 相对行号
vim.opt.tabstop = 4                  -- Tab宽度
vim.opt.shiftwidth = 4               -- 缩进宽度
vim.opt.expandtab = true             -- 使用空格代替Tab
vim.opt.smartindent = true           -- 智能缩进
vim.opt.wrap = false                 -- 不自动换行
vim.opt.ignorecase = true            -- 搜索忽略大小写
vim.opt.smartcase = true             -- 智能大小写搜索
vim.opt.hlsearch = true              -- 高亮搜索结果
vim.opt.incsearch = true             -- 增量搜索
vim.opt.termguicolors = true         -- 启用终端真彩色
vim.opt.scrolloff = 8                -- 滚动时保持上下文
vim.opt.sidescrolloff = 8            -- 水平滚动时保持上下文
vim.opt.signcolumn = "yes"           -- 始终显示符号列
vim.opt.colorcolumn = "80"           -- 80列宽度指示
vim.opt.updatetime = 300             -- 更新时间(ms)
vim.opt.timeoutlen = 500             -- 按键超时
vim.opt.clipboard = "unnamedplus"    -- 使用系统剪贴板
vim.opt.mouse = "a"                  -- 启用鼠标
vim.opt.backup = false               -- 不创建备份文件
vim.opt.swapfile = false             -- 不创建交换文件

-- 键映射
vim.g.mapleader = " "                -- 设置Leader键为空格

-- 保存时自动删除行尾空格
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = "%s/\\s\\+$//e",
})

-- 记住上次编辑位置
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local last_pos = vim.fn.line("'\"")
        if last_pos > 0 and last_pos <= vim.fn.line("$") then
            vim.api.nvim_win_set_cursor(0, {last_pos, 0})
        end
    end,
})

-- Packer插件管理
require('packer').startup(function(use)
    -- Packer管理自身
    use 'wbthomason/packer.nvim'
    
    -- 颜色主题
    use 'folke/tokyonight.nvim'
    
    -- LSP配置
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    
    -- 文件浏览
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    
    -- 文件树
    use {
        'kyazdani42/nvim-tree.lua',
        requires = { 'kyazdani42/nvim-web-devicons' }
    }
    
    -- 状态栏
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons' }
    }
    
    -- Git集成
    use 'lewis6991/gitsigns.nvim'
    
    -- 语法高亮
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    
    -- 自动括号对
    use 'windwp/nvim-autopairs'

    -- 注释工具
    use 'numToStr/Comment.nvim'
    
    -- 缩进指示线
    use 'lukas-reineke/indent-blankline.nvim'
    
    -- EasyMotion - 快速移动
    use 'easymotion/vim-easymotion'
end)

-- 加载主题配置
if vim.fn.filereadable(vim.fn.expand('~/.config/nvim/theme/current_theme.lua')) == 1 then
    require('theme.current_theme')
else
    -- 默认主题配置
    vim.cmd[[colorscheme tokyonight]]
end

-- 配置插件
-- 这些配置通常会放在单独的文件中，这里简化为内联配置

-- 配置nvim-tree
require('nvim-tree').setup()

-- 配置lualine
require('lualine').setup()

-- 配置treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = { "lua", "python", "javascript", "typescript", "go", "bash" },
    highlight = { enable = true },
}

-- 配置gitsigns
require('gitsigns').setup()

-- 配置nvim-autopairs
require('nvim-autopairs').setup()

-- 配置Comment.nvim
require('Comment').setup()

-- 配置EasyMotion
-- 设置EasyMotion前缀键为<Leader>（空格）
vim.g.EasyMotion_do_mapping = 0 -- 禁用默认映射
-- 双字母搜索
vim.api.nvim_set_keymap('n', '<Leader>s', '<Plug>(easymotion-s2)', {})
-- 行内跳转
vim.api.nvim_set_keymap('n', '<Leader>w', '<Plug>(easymotion-bd-w)', {})
vim.api.nvim_set_keymap('n', '<Leader>e', '<Plug>(easymotion-bd-e)', {})
-- 行跳转
vim.api.nvim_set_keymap('n', '<Leader>j', '<Plug>(easymotion-j)', {})
vim.api.nvim_set_keymap('n', '<Leader>k', '<Plug>(easymotion-k)', {}) 