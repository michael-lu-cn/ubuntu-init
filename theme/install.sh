#!/bin/bash

# 主题管理模块安装脚本
# 作者: Claude
# 描述: 安装自动明暗主题切换系统

# 检查是否以root权限运行
if [ "$(id -u)" -ne 0 ]; then
   echo "该脚本需要root权限运行" 
   echo "请使用sudo运行: sudo $0"
   exit 1
fi

set -e  # 遇到错误立即退出

echo "==============================================="
echo "安装主题管理模块"
echo "==============================================="

# 创建主题配置目录
echo "正在创建主题配置目录..."
mkdir -p ~/.config/auto-dark-mode

# 复制配置文件
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "正在复制主题脚本..."
cp -r "${SCRIPT_DIR}/scripts/"* ~/.config/auto-dark-mode/

# 设置执行权限
chmod +x ~/.config/auto-dark-mode/check-theme.sh
chmod +x ~/.config/auto-dark-mode/auto-dark-mode.sh

# 设置初始主题
echo "正在设置初始主题..."
~/.config/auto-dark-mode/check-theme.sh > /tmp/current_theme
CURRENT_THEME=$(cat /tmp/current_theme)

# 为zsh配置初始p10k主题链接
if [ -f ~/.p10k.${CURRENT_THEME}.zsh ]; then
  echo "正在链接p10k ${CURRENT_THEME}主题..."
  ln -sf ~/.p10k.${CURRENT_THEME}.zsh ~/.p10k.zsh
fi

# 设置crontab定时检测主题变化（每10分钟）
echo "正在设置自动主题检测..."
(crontab -l 2>/dev/null || echo "") | grep -v "check-theme.sh" | crontab -
(crontab -l 2>/dev/null; echo "*/10 * * * * $HOME/.config/auto-dark-mode/check-theme.sh > /tmp/current_theme 2>/dev/null && $HOME/.config/auto-dark-mode/auto-dark-mode.sh > /dev/null 2>&1") | crontab -

echo "主题管理模块安装完成！"
echo "系统将根据时间或系统设置自动切换明暗主题" 