# 基础系统模块

这个模块安装Ubuntu开发服务器所需的基础软件包和工具。

## 安装的组件

- **系统更新**: 更新APT存储库和系统包
- **构建工具**: build-essential（包含gcc、make等）
- **基础命令行工具**: 
  - curl, wget, git, unzip
  - htop (进程监控)
  - ripgrep (高性能搜索工具)
  - fd-find (现代find命令替代品)
  - fzf (模糊查找工具)
  - bat (cat命令的现代替代品，带语法高亮)

## 单独使用

如果只需要安装基础组件，可以单独运行此脚本：

```bash
chmod +x install.sh
./install.sh
``` 