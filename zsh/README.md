# Zsh 模块

这个模块安装和配置Zsh、Oh-My-Zsh及相关插件，提供现代化的终端体验。

## 功能特性

- **Oh-My-Zsh框架**: 丰富的插件和主题系统
- **Powerlevel10k**: 美观、高效的终端主题
- **智能补全**: 命令建议和历史记录搜索
- **语法高亮**: 命令行语法实时高亮显示
- **便捷别名**: 预配置的常用命令别名

## 安装的插件

- **zsh-autosuggestions**: 命令自动补全建议
- **zsh-syntax-highlighting**: 命令语法实时高亮
- **git**: Git集成和别名
- **docker**: Docker命令补全和别名
- **z**: 快速目录跳转
- **extract**: 一键解压任意格式
- **sudo**: 双击ESC前置sudo
- **copypath**: 方便复制路径

## 配置详情

- **即时提示**: 快速加载提示符而不阻塞终端
- **历史记录**: 大容量命令历史及去重
- **别名系统**: 常用命令简化
- **主题支持**: 支持明暗主题自动切换

## 单独使用

如果只需要安装zsh配置，可以单独运行此模块：

```bash
# 确保config目录包含所需配置文件
mkdir -p config
# 准备配置文件...
chmod +x install.sh
./install.sh
```

## 自定义

安装完成后，可以通过以下方式自定义Zsh：

- 修改`~/.zshrc`添加新插件或别名
- 运行`p10k configure`自定义Powerlevel10k主题 