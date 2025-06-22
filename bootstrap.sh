#!/bin/bash

# ================================================================
# Ubuntu开发环境初始化先导脚本
# ================================================================
# 用法: 复制此脚本内容并在终端执行以下命令之一：
#   sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/michael-lu-cn/ubuntu-init/main/bootstrap.sh)"
#   sudo bash -c "$(wget -qO- https://raw.githubusercontent.com/michael-lu-cn/ubuntu-init/main/bootstrap.sh)"
# 
# 功能:
# - 设置用户密码（如果需要）
# - 询问并设置代理（如果需要）
# - 克隆仓库到~/.ubuntu-init
# - 自动开始安装过程
# ================================================================

# 清屏
clear

echo "=================================================="
echo "       Ubuntu开发环境自动初始化先导脚本           "
echo "=================================================="
echo ""

# 检查是否以root权限运行
if [ "$(id -u)" -ne 0 ]; then
   echo "错误: 该脚本需要root权限运行" 
   echo "请使用sudo运行: sudo bash"
   exit 1
fi

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

# 显示并确认安装信息
echo ""
echo "安装信息确认:"
echo "- 安装用户: $REAL_USER"
echo "- 用户主目录: $USER_HOME"
echo "- 安装目录将是: $USER_HOME/.ubuntu-init"
echo ""
read -p "以上信息是否正确？(y/n): " confirm_info
if [ "$confirm_info" != "y" ] && [ "$confirm_info" != "Y" ]; then
    echo "安装已取消。请重新运行脚本并提供正确的用户信息。"
    exit 1
fi

# 询问是否需要设置用户密码
echo "首先，您需要确保当前用户有设置密码。"
read -p "是否需要现在设置密码？(y/n): " need_password

if [ "$need_password" = "y" ] || [ "$need_password" = "Y" ]; then
    echo "正在为用户 $REAL_USER 设置密码..."
    passwd $REAL_USER
    
    if [ $? -ne 0 ]; then
        echo "密码设置失败，但将继续安装过程。"
        echo "请稍后手动设置密码: sudo passwd $REAL_USER"
    else
        echo "密码设置成功！"
    fi
else
    echo "跳过密码设置。"
    echo "注意: 如果您尚未设置密码，请在安装完成后使用 'sudo passwd $REAL_USER' 命令设置。"
fi

# 创建目标目录
TARGET_DIR="$USER_HOME/.ubuntu-init"
echo "将安装到: $TARGET_DIR"

# 询问是否需要设置代理
read -p "您是否需要设置代理来访问外部网络？(y/n): " need_proxy

if [ "$need_proxy" = "y" ] || [ "$need_proxy" = "Y" ]; then
    # 询问代理信息
    read -p "请输入代理主机地址: " proxy_host
    read -p "请输入代理端口: " proxy_port
    
    # 验证代理信息
    if [ -z "$proxy_host" ] || [ -z "$proxy_port" ]; then
        echo "错误: 代理信息不完整"
        exit 1
    fi
    
    # 设置临时代理环境变量
    export http_proxy="http://$proxy_host:$proxy_port"
    export https_proxy="http://$proxy_host:$proxy_port"
    export HTTP_PROXY="http://$proxy_host:$proxy_port"
    export HTTPS_PROXY="http://$proxy_host:$proxy_port"
    
    echo "临时代理已设置: http://$proxy_host:$proxy_port"
else
    echo "跳过代理设置。"
    echo "注意: 如果您在内网环境中，可能无法访问外部资源。"
fi

# 安装必要工具
apt-get update
apt-get install -y git curl unzip

# 删除旧目录（如果存在）
if [ -d "$TARGET_DIR" ]; then
    echo "发现旧安装，正在删除..."
    rm -rf "$TARGET_DIR"
fi

# 创建目录并设置权限
mkdir -p "$TARGET_DIR"
chown -R $REAL_USER:$REAL_USER "$TARGET_DIR"

# 下载仓库
echo "正在获取代码..."
TMP_ZIP="/tmp/ubuntu-init.zip"
curl -L -s -o "$TMP_ZIP" "https://github.com/michael-lu-cn/ubuntu-init/archive/refs/heads/main.zip"

if [ $? -ne 0 ]; then
    echo "下载失败，尝试使用git克隆..."
    GIT_TERMINAL_PROMPT=0 sudo -u $REAL_USER git clone --depth=1 https://github.com/michael-lu-cn/ubuntu-init.git "$TARGET_DIR"
    
    if [ $? -ne 0 ]; then
        echo "错误: 无法获取代码。请检查网络连接或代理设置。"
        exit 1
    fi
else
    echo "解压代码..."
    unzip -q "$TMP_ZIP" -d "/tmp/"
    cp -r /tmp/ubuntu-init-main/* "$TARGET_DIR"
    rm -f "$TMP_ZIP"
    rm -rf "/tmp/ubuntu-init-main"
    chown -R $REAL_USER:$REAL_USER "$TARGET_DIR"
fi

# 进入目录
cd "$TARGET_DIR"

# 设置所有脚本的执行权限
echo "设置脚本执行权限..."
find . -name "*.sh" -exec chmod +x {} \;

# 如果设置了代理，创建.env文件
if [ "$need_proxy" = "y" ] || [ "$need_proxy" = "Y" ]; then
    echo "正在创建代理配置..."
    cat > .env << EOF
# 代理设置
# 自动生成于 $(date)

# 代理主机地址
PROXY_HOST=$proxy_host

# 代理端口
PROXY_PORT=$proxy_port
EOF
    # 确保.env文件的所有权正确
    chown $REAL_USER:$REAL_USER .env
fi

# 询问是否开始安装
echo ""
echo "准备开始安装Ubuntu开发环境..."
read -p "是否继续？(y/n): " start_install

if [ "$start_install" = "y" ] || [ "$start_install" = "Y" ]; then
    echo ""
    echo "开始安装..."
    ./ubuntu-init.sh
else
    echo ""
    echo "安装已取消。"
    echo "您可以稍后通过运行以下命令继续安装："
    echo "cd $TARGET_DIR && sudo ./ubuntu-init.sh"
    exit 0
fi 