#!/bin/bash

# 基础系统配置安装脚本
# 作者: Claude
# 描述: 安装基础开发工具和依赖

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
echo "安装基础系统组件"
echo "==============================================="
echo "安装用户: $REAL_USER"
echo "安装目录: $USER_HOME"

# 更新系统
echo "正在更新系统..."
apt-get update
apt-get upgrade -y

# 安装基础工具
echo "正在安装基础工具..."
apt-get install -y \
    build-essential \
    curl \
    git \
    wget \
    unzip \
    software-properties-common \
    python3 \
    python3-pip \
    ripgrep \
    fd-find \
    htop \
    fzf \
    bat

# 创建符号链接(某些发行版安装的命令名称不同)
if [ ! -f /usr/bin/batcat ]; then
    [ -f /usr/bin/bat ] || ln -s /usr/bin/batcat /usr/bin/bat
fi
if [ ! -f /usr/bin/fd ]; then
    [ -f /usr/bin/fdfind ] && ln -s $(which fdfind) /usr/bin/fd
fi

echo "基础系统组件安装完成！" 