#!/bin/bash

# 主题管理模块安装脚本
# 作者: Claude
# 描述: 安装自动明暗主题切换系统

# 加载代理设置
SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$SCRIPT_ROOT/proxy_env.sh" ]; then
  source "$SCRIPT_ROOT/proxy_env.sh"
  echo "已加载代理设置"
fi

# 检查是否以root权限运行
if [ "$(id -u)" -ne 0 ]; then
   echo "该脚本需要root权限运行" 
   echo "请使用sudo运行: sudo $0"
   exit 1
fi

set -e  # 遇到错误立即退出

# 获取真实用户（非root）
REAL_USER=""
# 尝试从环境变量获取
if [ -n "$SUDO_USER" ] && [ "$SUDO_USER" != "root" ]; then
    REAL_USER="$SUDO_USER"
elif [ -n "$(logname 2>/dev/null)" ] && [ "$(logname)" != "root" ]; then
    REAL_USER="$(logname)"
fi

# 如果无法自动检测，则询问用户
if [ -z "$REAL_USER" ] || [ "$REAL_USER" = "root" ]; then
    echo "无法自动检测到非root用户。"
    read -p "请输入要安装到的用户名（不要使用root）: " REAL_USER
    if [ -z "$REAL_USER" ] || [ "$REAL_USER" = "root" ]; then
        echo "错误: 需要有效的非root用户名"
        exit 1
    fi
fi

# 获取用户主目录
USER_HOME=$(eval echo ~$REAL_USER)
if [ ! -d "$USER_HOME" ]; then
    echo "错误: 用户主目录 $USER_HOME 不存在"
    exit 1
fi

echo "==============================================="
echo "安装主题管理模块"
echo "==============================================="
echo "安装用户: $REAL_USER"
echo "安装目录: $USER_HOME"

# 创建主题配置目录
echo "正在创建主题配置目录..."
sudo -u $REAL_USER mkdir -p "$USER_HOME/.config/auto-dark-mode"

# 复制配置文件
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "正在复制主题脚本..."
echo "脚本目录: ${SCRIPT_DIR}/scripts/"
ls -la "${SCRIPT_DIR}/scripts/"

# 单独复制每个脚本文件，避免使用通配符
if [ -f "${SCRIPT_DIR}/scripts/check-theme.sh" ]; then
    echo "复制check-theme.sh文件..."
    sudo -u $REAL_USER cp "${SCRIPT_DIR}/scripts/check-theme.sh" "$USER_HOME/.config/auto-dark-mode/"
else
    echo "警告: check-theme.sh文件不存在"
fi

if [ -f "${SCRIPT_DIR}/scripts/auto-dark-mode.sh" ]; then
    echo "复制auto-dark-mode.sh文件..."
    sudo -u $REAL_USER cp "${SCRIPT_DIR}/scripts/auto-dark-mode.sh" "$USER_HOME/.config/auto-dark-mode/"
else
    echo "警告: auto-dark-mode.sh文件不存在"
fi

# 设置执行权限
if [ -f "$USER_HOME/.config/auto-dark-mode/check-theme.sh" ]; then
    chmod +x "$USER_HOME/.config/auto-dark-mode/check-theme.sh"
fi

if [ -f "$USER_HOME/.config/auto-dark-mode/auto-dark-mode.sh" ]; then
    chmod +x "$USER_HOME/.config/auto-dark-mode/auto-dark-mode.sh"
fi

# 设置初始主题
echo "正在设置初始主题..."
if [ -f "$USER_HOME/.config/auto-dark-mode/check-theme.sh" ]; then
    sudo -u $REAL_USER "$USER_HOME/.config/auto-dark-mode/check-theme.sh" > /tmp/current_theme
    CURRENT_THEME=$(cat /tmp/current_theme)

    # 为zsh配置初始p10k主题链接
    if [ -f "$USER_HOME/.p10k.${CURRENT_THEME}.zsh" ]; then
        echo "正在链接p10k ${CURRENT_THEME}主题..."
        sudo -u $REAL_USER ln -sf "$USER_HOME/.p10k.${CURRENT_THEME}.zsh" "$USER_HOME/.p10k.zsh"
    fi

    # 设置crontab定时检测主题变化（每10分钟）
    echo "正在设置自动主题检测..."
    (sudo -u $REAL_USER crontab -l 2>/dev/null || echo "") | grep -v "check-theme.sh" | sudo -u $REAL_USER crontab -
    (sudo -u $REAL_USER crontab -l 2>/dev/null; echo "*/10 * * * * $USER_HOME/.config/auto-dark-mode/check-theme.sh > /tmp/current_theme 2>/dev/null && $USER_HOME/.config/auto-dark-mode/auto-dark-mode.sh > /dev/null 2>&1") | sudo -u $REAL_USER crontab -
else
    echo "警告: 无法设置初始主题，check-theme.sh不存在"
fi

echo "主题管理模块安装完成！"
echo "系统将根据时间或系统设置自动切换明暗主题" 