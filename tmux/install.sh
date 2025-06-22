#!/bin/bash

# tmux安装脚本
# 作者: Claude
# 描述: 安装tmux和相关配置

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
echo "安装tmux及配置"
echo "==============================================="
echo "安装用户: $REAL_USER"
echo "安装目录: $USER_HOME"

# 安装tmux
echo "正在安装tmux..."
apt-get install -y tmux

# 安装tmux插件管理器(TPM)
echo "正在安装tmux插件管理器..."
sudo -u $REAL_USER mkdir -p "$USER_HOME/.tmux/plugins"
sudo -u $REAL_USER git clone https://github.com/tmux-plugins/tpm "$USER_HOME/.tmux/plugins/tpm"

# 安装oh-my-tmux配置
echo "正在安装oh-my-tmux配置..."
sudo -u $REAL_USER git clone https://github.com/gpakosz/.tmux.git "$USER_HOME/.tmux-config"
sudo -u $REAL_USER ln -s -f "$USER_HOME/.tmux-config/.tmux.conf" "$USER_HOME/.tmux.conf"

# 复制配置文件
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "正在复制tmux配置..."
echo "配置文件目录: ${SCRIPT_DIR}/config/"
ls -la "${SCRIPT_DIR}/config/"

# 单独复制每个配置文件，避免使用通配符
if [ -f "${SCRIPT_DIR}/config/.tmux.conf.local" ]; then
    echo "复制.tmux.conf.local文件..."
    sudo -u $REAL_USER cp "${SCRIPT_DIR}/config/.tmux.conf.local" "$USER_HOME/"
else
    echo "警告: .tmux.conf.local文件不存在"
fi

# 加载主题文件（检查是否存在）
if [ -f "${SCRIPT_DIR}/themes/dark.tmux" ]; then
  echo "创建默认暗色主题..."
  sudo -u $REAL_USER cp "${SCRIPT_DIR}/themes/dark.tmux" "$USER_HOME/.tmux.theme.dark"
else
  echo "警告: 暗色主题文件不存在"
fi

if [ -f "${SCRIPT_DIR}/themes/light.tmux" ]; then
  echo "创建默认亮色主题..."
  sudo -u $REAL_USER cp "${SCRIPT_DIR}/themes/light.tmux" "$USER_HOME/.tmux.theme.light"
else
  echo "警告: 亮色主题文件不存在"
fi

echo "tmux安装和配置完成！"
echo "首次使用tmux后，按下 'Ctrl+t' 然后按 'I' 安装插件" 