# Ubuntu 开发服务器初始化脚本

这是一个模块化的Ubuntu开发服务器环境配置工具，用于快速搭建高效的开发环境。

## 功能特性

- **模块化设计**: 每个组件可单独安装和配置
- **自动主题切换**: 根据系统设置或时间自动切换明暗主题
- **开发工具集**: 预配置常用开发工具和插件
- **终端美化**: 美观且功能强大的终端环境

## 快速开始

### 安装方法

1. 将以下脚本内容复制到文本编辑器中
2. 保存为`bootstrap.sh`
3. 执行`sudo bash bootstrap.sh`

### 引导脚本内容

```bash
#!/bin/bash

# ================================================================
# Ubuntu开发环境初始化先导脚本
# ================================================================
# 用途: 设置用户密码和代理，然后自动克隆安装脚本
# 用法: 将此脚本保存为bootstrap.sh，然后执行 sudo bash bootstrap.sh
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
   echo "请使用sudo运行: sudo bash bootstrap.sh"
   exit 1
fi

# 询问是否需要设置用户密码
echo "首先，您需要确保当前用户有设置密码。"
read -p "是否需要现在设置密码？(y/n): " need_password

if [ "$need_password" = "y" ] || [ "$need_password" = "Y" ]; then
    # 获取当前用户名
    CURRENT_USER=$(logname || echo $SUDO_USER || echo $USER)
    if [ -z "$CURRENT_USER" ] || [ "$CURRENT_USER" = "root" ]; then
        read -p "请输入要设置密码的用户名: " CURRENT_USER
    fi
    
    echo "正在为用户 $CURRENT_USER 设置密码..."
    passwd $CURRENT_USER
    
    if [ $? -ne 0 ]; then
        echo "密码设置失败，但将继续安装过程。"
        echo "请稍后手动设置密码: sudo passwd $CURRENT_USER"
    else
        echo "密码设置成功！"
    fi
else
    echo "跳过密码设置。"
    echo "注意: 如果您尚未设置密码，请在安装完成后使用 'sudo passwd 用户名' 命令设置。"
fi

# 创建目标目录
TARGET_DIR="$HOME/.ubuntu-init"
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

# 安装git（如果需要）
if ! command -v git &> /dev/null; then
    echo "正在安装git..."
    apt-get update
    apt-get install -y git
fi

# 删除旧目录（如果存在）
if [ -d "$TARGET_DIR" ]; then
    echo "发现旧安装，正在删除..."
    rm -rf "$TARGET_DIR"
fi

# 克隆仓库
echo "正在克隆Ubuntu初始化仓库..."
git clone https://github.com/michael-lu-cn/ubuntu-init.git "$TARGET_DIR"

if [ $? -ne 0 ]; then
    echo "错误: 克隆仓库失败。请检查网络连接或代理设置。"
    exit 1
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
```

### 脚本功能

引导脚本将：
1. 引导您设置用户密码（如果需要）
2. 询问您是否需要设置代理
3. 克隆仓库到`~/.ubuntu-init`目录
4. 自动开始安装过程

## 模块列表

该项目包含以下模块:

1. **基础模块**: 系统工具和依赖
2. **Neovim模块**: 现代编辑器配置
3. **tmux模块**: 终端复用器和会话管理
4. **zsh模块**: shell环境和提示符
5. **主题模块**: 自动明暗主题管理

## 首次使用注意事项

- 脚本已预配置了Powerlevel10k，不需要运行配置向导
- 终端支持自动明暗主题切换，根据系统设置或时间自动调整
- 如需自定义Powerlevel10k，可以运行`p10k configure`
- 首次打开Neovim时，需要运行`:PackerSync`安装插件
- 首次打开tmux后，按下`Ctrl+t`然后按`I`安装插件

## 定制化

各模块的配置文件位置:

- Neovim配置: `~/.config/nvim/`
- Zsh配置: `~/.zshrc`, `~/.p10k.zsh`
- tmux配置: `~/.tmux.conf.local`
- 主题配置: `~/.config/auto-dark-mode/`

## 故障排除

如果您遇到网络连接问题：

1. 检查代理设置是否正确
2. 验证您是否可以访问GitHub和其他外部资源
3. 尝试临时禁用防火墙: `sudo ufw disable`

## 截图

(此处可添加环境截图) 