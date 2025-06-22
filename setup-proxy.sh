#!/bin/bash

# 代理设置脚本
# 作者: Claude
# 描述: 为内网环境设置各种代理

# 检查是否以root权限运行
if [ "$(id -u)" -ne 0 ]; then
   echo "该脚本需要root权限运行" 
   echo "请使用sudo运行: sudo $0"
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

# 检查.env文件是否存在
if [ ! -f .env ]; then
    echo "错误: .env文件不存在"
    echo "请创建.env文件并设置代理信息，格式如下:"
    echo "PROXY_HOST=your_proxy_host"
    echo "PROXY_PORT=your_proxy_port"
    exit 1
fi

# 从.env文件加载代理信息
source .env

# 检查代理信息是否设置
if [ -z "$PROXY_HOST" ] || [ -z "$PROXY_PORT" ]; then
    echo "错误: 代理信息未正确设置"
    echo "请在.env文件中设置PROXY_HOST和PROXY_PORT"
    exit 1
fi

# 设置代理协议，如果未在.env中定义则使用默认值
HTTP_PROTOCOL=${HTTP_PROTOCOL:-http}
HTTPS_PROTOCOL=${HTTPS_PROTOCOL:-https}

HTTP_PROXY_URL="${HTTP_PROTOCOL}://$PROXY_HOST:$PROXY_PORT"
HTTPS_PROXY_URL="${HTTPS_PROTOCOL}://$PROXY_HOST:$PROXY_PORT"

echo "==============================================="
echo "设置代理:"
echo "HTTP代理: $HTTP_PROXY_URL"
echo "HTTPS代理: $HTTPS_PROXY_URL"
echo "==============================================="

# 设置系统代理
export http_proxy=$HTTP_PROXY_URL
export https_proxy=$HTTPS_PROXY_URL
export HTTP_PROXY=$HTTP_PROXY_URL
export HTTPS_PROXY=$HTTPS_PROXY_URL
export no_proxy="localhost,127.0.0.1"
export NO_PROXY="localhost,127.0.0.1"

# 保存到shell配置文件
echo "正在添加代理到shell配置..."
cat > "$USER_HOME/.proxy_profile" << EOF
# 代理设置
export http_proxy=$HTTP_PROXY_URL
export https_proxy=$HTTPS_PROXY_URL
export HTTP_PROXY=$HTTP_PROXY_URL
export HTTPS_PROXY=$HTTPS_PROXY_URL
export no_proxy="localhost,127.0.0.1"
export NO_PROXY="localhost,127.0.0.1"
EOF

# 设置正确的所有权
chown $REAL_USER:$REAL_USER "$USER_HOME/.proxy_profile"

# 添加到.bashrc和.zshrc
echo "source $USER_HOME/.proxy_profile" >> "$USER_HOME/.bashrc"
if [ -f "$USER_HOME/.zshrc" ]; then
  echo "source $USER_HOME/.proxy_profile" >> "$USER_HOME/.zshrc"
fi

# 设置Git代理
echo "正在设置Git代理..."
sudo -u $REAL_USER git config --global http.proxy $HTTP_PROXY_URL
sudo -u $REAL_USER git config --global https.proxy $HTTPS_PROXY_URL

# 设置APT代理
echo "正在设置APT代理..."
echo "Acquire::http::Proxy \"$HTTP_PROXY_URL\";" | tee /etc/apt/apt.conf.d/proxy.conf
echo "Acquire::https::Proxy \"$HTTPS_PROXY_URL\";" | tee -a /etc/apt/apt.conf.d/proxy.conf

# 设置NPM代理（如果存在）
if command -v npm &> /dev/null; then
  echo "正在设置NPM代理..."
  sudo -u $REAL_USER npm config set proxy $HTTP_PROXY_URL
  sudo -u $REAL_USER npm config set https-proxy $HTTPS_PROXY_URL
fi

# 设置Yarn代理（如果存在）
if command -v yarn &> /dev/null; then
  echo "正在设置Yarn代理..."
  sudo -u $REAL_USER yarn config set proxy $HTTP_PROXY_URL
  sudo -u $REAL_USER yarn config set https-proxy $HTTPS_PROXY_URL
fi

# 验证代理
echo "正在验证代理连接..."
if curl -s --connect-timeout 5 -I https://github.com > /dev/null; then
  echo "✓ 代理连接成功！可以访问GitHub。"
else
  echo "✗ 代理连接失败。请检查代理设置。"
fi

echo "==============================================="
echo "代理设置完成！"
echo "HTTP代理: $HTTP_PROXY_URL"
echo "HTTPS代理: $HTTPS_PROXY_URL"
echo "请运行 'source ~/.bashrc' 或重新启动终端以应用更改"
echo "===============================================" 