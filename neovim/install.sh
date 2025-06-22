#!/bin/bash

# Neovim安装脚本
# 作者: Claude
# 描述: 安装Neovim和相关插件

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
echo "安装Neovim及配置"
echo "==============================================="
echo "安装用户: $REAL_USER"
echo "安装目录: $USER_HOME"

# 安装Neovim
echo "正在安装Neovim..."
add-apt-repository ppa:neovim-ppa/stable -y
apt-get update
apt-get install -y neovim

# 创建配置目录
sudo -u $REAL_USER mkdir -p "$USER_HOME/.config/nvim"
sudo -u $REAL_USER mkdir -p "$USER_HOME/.config/nvim/theme"

# 安装Neovim插件管理器 - Packer
echo "正在安装Neovim插件管理器(Packer)..."
sudo -u $REAL_USER git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    "$USER_HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"

# 复制配置文件
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "正在复制Neovim配置..."
echo "配置文件目录: ${SCRIPT_DIR}/config/"
ls -la "${SCRIPT_DIR}/config/"

# 递归复制配置文件，避免使用通配符
if [ -d "${SCRIPT_DIR}/config" ]; then
    echo "复制Neovim配置文件..."
    find "${SCRIPT_DIR}/config" -type f -exec echo "复制: {}" \; -exec sudo -u $REAL_USER cp {} "$USER_HOME/.config/nvim/" \;
else
    echo "警告: Neovim配置目录不存在"
fi

# 创建当前主题文件（如果不存在）
if [ ! -f "$USER_HOME/.config/nvim/theme/current_theme.lua" ]; then
  echo "创建默认主题配置..."
  echo 'vim.cmd[[colorscheme tokyonight]]' | sudo -u $REAL_USER tee "$USER_HOME/.config/nvim/theme/current_theme.lua" > /dev/null
fi

echo "Neovim安装和配置完成！"
echo "首次打开nvim时，请运行 :PackerSync 安装插件" 