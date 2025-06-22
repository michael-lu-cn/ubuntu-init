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

PROXY_URL="http://$PROXY_HOST:$PROXY_PORT"

echo "==============================================="
echo "设置代理: $PROXY_URL"
echo "==============================================="

# 设置系统代理
export http_proxy=$PROXY_URL
export https_proxy=$PROXY_URL
export HTTP_PROXY=$PROXY_URL
export HTTPS_PROXY=$PROXY_URL
export no_proxy="localhost,127.0.0.1"
export NO_PROXY="localhost,127.0.0.1"

# 保存到shell配置文件
echo "正在添加代理到shell配置..."
cat > ~/.proxy_profile << EOF
# 代理设置
export http_proxy=$PROXY_URL
export https_proxy=$PROXY_URL
export HTTP_PROXY=$PROXY_URL
export HTTPS_PROXY=$PROXY_URL
export no_proxy="localhost,127.0.0.1"
export NO_PROXY="localhost,127.0.0.1"
EOF

# 添加到.bashrc和.zshrc
echo "source ~/.proxy_profile" >> ~/.bashrc
if [ -f ~/.zshrc ]; then
  echo "source ~/.proxy_profile" >> ~/.zshrc
fi

# 设置Git代理
echo "正在设置Git代理..."
git config --global http.proxy $PROXY_URL
git config --global https.proxy $PROXY_URL

# 设置APT代理
echo "正在设置APT代理..."
echo "Acquire::http::Proxy \"$PROXY_URL\";" | tee /etc/apt/apt.conf.d/proxy.conf
echo "Acquire::https::Proxy \"$PROXY_URL\";" | tee -a /etc/apt/apt.conf.d/proxy.conf

# 设置NPM代理（如果存在）
if command -v npm &> /dev/null; then
  echo "正在设置NPM代理..."
  npm config set proxy $PROXY_URL
  npm config set https-proxy $PROXY_URL
fi

# 设置Yarn代理（如果存在）
if command -v yarn &> /dev/null; then
  echo "正在设置Yarn代理..."
  yarn config set proxy $PROXY_URL
  yarn config set https-proxy $PROXY_URL
fi

# 验证代理
echo "正在验证代理连接..."
if curl -s --connect-timeout 5 -I https://github.com > /dev/null; then
  echo "✓ 代理连接成功！可以访问GitHub。"
else
  echo "✗ 代理连接失败。请检查代理设置。"
fi

echo "==============================================="
echo "代理设置完成！代理地址: $PROXY_URL"
echo "请运行 'source ~/.bashrc' 或重新启动终端以应用更改"
echo "===============================================" 