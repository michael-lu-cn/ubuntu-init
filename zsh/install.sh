#!/bin/bash

# zsh安装脚本
# 作者: Claude
# 描述: 安装zsh、oh-my-zsh和相关配置

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
echo "安装zsh及配置"
echo "==============================================="
echo "安装用户: $REAL_USER"
echo "安装目录: $USER_HOME"

# 安装zsh
echo "正在安装zsh..."
apt-get install -y zsh

# 安装oh-my-zsh
echo "正在安装oh-my-zsh..."
sudo -u $REAL_USER sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 设置zsh为默认shell
echo "正在将zsh设置为默认shell..."
chsh -s $(which zsh) $REAL_USER

# 安装zsh插件
echo "正在安装zsh插件..."

# 安装zsh-autosuggestions
sudo -u $REAL_USER git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# 安装zsh-syntax-highlighting
sudo -u $REAL_USER git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 安装powerlevel10k主题
sudo -u $REAL_USER git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# 复制配置文件
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "正在复制zsh配置..."
sudo -u $REAL_USER cp -r "${SCRIPT_DIR}/config/"* "$USER_HOME/"

echo "zsh安装和配置完成！" 