#!/bin/bash

# tmux安装脚本
# 作者: Claude
# 描述: 安装tmux和相关配置

# 检查是否以root权限运行
if [ "$(id -u)" -ne 0 ]; then
   echo "该脚本需要root权限运行" 
   echo "请使用sudo运行: sudo $0"
   exit 1
fi

set -e  # 遇到错误立即退出

echo "==============================================="
echo "安装tmux及配置"
echo "==============================================="

# 安装tmux
echo "正在安装tmux..."
apt-get install -y tmux

# 安装tmux插件管理器(TPM)
echo "正在安装tmux插件管理器..."
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 安装oh-my-tmux配置
echo "正在安装oh-my-tmux配置..."
git clone https://github.com/gpakosz/.tmux.git ~/.tmux-config
ln -s -f ~/.tmux-config/.tmux.conf ~/.tmux.conf

# 复制配置文件
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "正在复制tmux配置..."
cp -r "${SCRIPT_DIR}/config/"* ~/

# 加载主题文件（检查是否存在）
if [ ! -f ~/.tmux.theme.dark ]; then
  echo "创建默认暗色主题..."
  cp "${SCRIPT_DIR}/themes/dark.tmux" ~/.tmux.theme.dark
fi

if [ ! -f ~/.tmux.theme.light ]; then
  echo "创建默认亮色主题..."
  cp "${SCRIPT_DIR}/themes/light.tmux" ~/.tmux.theme.light
fi

echo "tmux安装和配置完成！"
echo "首次使用tmux后，按下 'Ctrl+t' 然后按 'I' 安装插件" 