#!/bin/bash

# Ubuntu开发环境初始化脚本
# 作者: Claude
# 描述: 自动安装和配置开发环境

# 检查是否以root权限运行
if [ "$(id -u)" -ne 0 ]; then
   echo "该脚本需要root权限运行" 
   echo "请使用sudo运行: sudo $0"
   exit 1
fi

# 获取真实用户
REAL_USER=$(logname || echo $SUDO_USER || echo $USER)
if [ "$REAL_USER" = "root" ]; then
    read -p "请输入您的用户名（不要使用root）: " REAL_USER
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

# 脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查.env文件是否存在，如果存在则应用代理设置
if [ -f .env ]; then
    echo -e "${BLUE}检测到.env文件，正在应用代理设置...${NC}"
    chmod +x setup-proxy.sh
    ./setup-proxy.sh
    echo ""
fi

echo -e "${GREEN}=====================================================${NC}"
echo -e "${GREEN}       Ubuntu开发环境初始化脚本 v1.0                ${NC}"
echo -e "${GREEN}=====================================================${NC}"
echo ""

# 确保所有脚本有执行权限
find . -name "*.sh" -exec chmod +x {} \;

# 安装基础模块
echo -e "${BLUE}正在安装基础模块...${NC}"
cd "$SCRIPT_DIR/base"
./install.sh
echo -e "${GREEN}基础模块安装完成${NC}"
echo ""

# 安装Neovim
echo -e "${BLUE}正在安装Neovim...${NC}"
cd "$SCRIPT_DIR/neovim"
./install.sh
echo -e "${GREEN}Neovim安装完成${NC}"
echo ""

# 安装tmux
echo -e "${BLUE}正在安装tmux...${NC}"
cd "$SCRIPT_DIR/tmux"
./install.sh
echo -e "${GREEN}tmux安装完成${NC}"
echo ""

# 安装zsh
echo -e "${BLUE}正在安装zsh...${NC}"
cd "$SCRIPT_DIR/zsh"
./install.sh
echo -e "${GREEN}zsh安装完成${NC}"
echo ""

# 安装主题
echo -e "${BLUE}正在安装主题...${NC}"
cd "$SCRIPT_DIR/theme"
./install.sh
echo -e "${GREEN}主题安装完成${NC}"
echo ""

# 设置正确的文件所有权
echo -e "${BLUE}正在设置文件所有权...${NC}"
chown -R $REAL_USER:$REAL_USER "$USER_HOME/.config"
chown -R $REAL_USER:$REAL_USER "$USER_HOME/.zshrc"
chown -R $REAL_USER:$REAL_USER "$USER_HOME/.p10k.zsh"
chown -R $REAL_USER:$REAL_USER "$USER_HOME/.tmux.conf.local"
echo -e "${GREEN}文件所有权设置完成${NC}"
echo ""

echo -e "${GREEN}=====================================================${NC}"
echo -e "${GREEN}       Ubuntu开发环境初始化完成!                     ${NC}"
echo -e "${GREEN}=====================================================${NC}"
echo ""
echo -e "${YELLOW}请注意以下事项:${NC}"
echo -e "1. 重新登录或运行 ${BLUE}source ~/.zshrc${NC} 以应用zsh配置"
echo -e "2. 首次打开Neovim时，运行 ${BLUE}:PackerSync${NC} 安装插件"
echo -e "3. 首次打开tmux后，按下 ${BLUE}Ctrl+t${NC} 然后按 ${BLUE}I${NC} 安装插件"
echo -e "4. 如需自定义Powerlevel10k，可以运行 ${BLUE}p10k configure${NC}"
echo ""
echo -e "${GREEN}感谢使用Ubuntu开发环境初始化脚本!${NC}" 