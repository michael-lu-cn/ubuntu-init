#!/bin/bash

# Neovim安装脚本
# 作者: Claude
# 描述: 安装Neovim和相关插件

# 检查是否以root权限运行
if [ "$(id -u)" -ne 0 ]; then
   echo "该脚本需要root权限运行" 
   echo "请使用sudo运行: sudo $0"
   exit 1
fi

set -e  # 遇到错误立即退出

echo "==============================================="
echo "安装Neovim及配置"
echo "==============================================="

# 安装Neovim
echo "正在安装Neovim..."
add-apt-repository ppa:neovim-ppa/stable -y
apt-get update
apt-get install -y neovim

# 创建配置目录
mkdir -p ~/.config/nvim
mkdir -p ~/.config/nvim/theme

# 安装Neovim插件管理器 - Packer
echo "正在安装Neovim插件管理器(Packer)..."
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# 复制配置文件
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "正在复制Neovim配置..."
cp -r "${SCRIPT_DIR}/config/"* ~/.config/nvim/

# 创建当前主题文件（如果不存在）
if [ ! -f ~/.config/nvim/theme/current_theme.lua ]; then
  echo "创建默认主题配置..."
  echo 'vim.cmd[[colorscheme tokyonight]]' > ~/.config/nvim/theme/current_theme.lua
fi

echo "Neovim安装和配置完成！"
echo "首次打开nvim时，请运行 :PackerSync 安装插件" 