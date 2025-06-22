#!/bin/bash

# zsh安装脚本
# 作者: Claude
# 描述: 安装zsh、oh-my-zsh和相关配置

# 检查是否以root权限运行
if [ "$(id -u)" -ne 0 ]; then
   echo "该脚本需要root权限运行" 
   echo "请使用sudo运行: sudo $0"
   exit 1
fi

set -e  # 遇到错误立即退出

echo "==============================================="
echo "安装zsh及配置"
echo "==============================================="

# 安装zsh
echo "正在安装zsh..."
apt-get install -y zsh

# 安装oh-my-zsh
echo "正在安装oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 设置zsh为默认shell
echo "正在将zsh设置为默认shell..."
chsh -s $(which zsh) $SUDO_USER

# 安装zsh插件
echo "正在安装zsh插件..."

# 安装zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# 安装zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 安装powerlevel10k主题
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# 复制配置文件
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "正在复制zsh配置..."
cp -r "${SCRIPT_DIR}/config/"* ~/

echo "zsh安装和配置完成！" 