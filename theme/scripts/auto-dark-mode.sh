#!/bin/bash

# 自动明暗主题切换应用脚本
# 此脚本根据检测到的主题设置各组件的主题

# 获取当前主题
CURRENT_THEME=$(cat /tmp/current_theme 2>/dev/null || echo "light")

# 设置Neovim主题
if [ "$CURRENT_THEME" = "dark" ]; then
    # 设置Neovim为暗色主题
    mkdir -p ~/.config/nvim/theme
    echo "vim.cmd[[colorscheme tokyonight-night]]" > ~/.config/nvim/theme/current_theme.lua
else
    # 设置Neovim为亮色主题
    mkdir -p ~/.config/nvim/theme
    echo "vim.cmd[[colorscheme tokyonight-day]]" > ~/.config/nvim/theme/current_theme.lua
fi

# 设置tmux主题
if [ -f ~/.tmux.conf ]; then
    # 检查tmux是否在运行
    tmux_running=$(pgrep tmux || echo "")
    
    if [ -n "$tmux_running" ]; then
        if [ "$CURRENT_THEME" = "dark" ]; then
            # 设置tmux为暗色主题
            tmux source-file ~/.tmux.theme.dark >/dev/null 2>&1
        else
            # 设置tmux为亮色主题
            tmux source-file ~/.tmux.theme.light >/dev/null 2>&1
        fi
    fi
fi

# 设置p10k主题
if [ "$CURRENT_THEME" = "dark" ]; then
    # 设置p10k为暗色主题
    ln -sf ~/.p10k.dark.zsh ~/.p10k.zsh
else
    # 设置p10k为亮色主题
    ln -sf ~/.p10k.light.zsh ~/.p10k.zsh
fi

# 设置环境变量（下次终端启动时生效）
if [ "$CURRENT_THEME" = "dark" ]; then
    echo "export BAT_THEME=Dracula" > ~/.theme_env
    echo "export TERM_THEME=dark" >> ~/.theme_env
else
    echo "export BAT_THEME=GitHub" > ~/.theme_env
    echo "export TERM_THEME=light" >> ~/.theme_env
fi 