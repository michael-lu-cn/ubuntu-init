# Ubuntu 开发服务器初始化脚本

快速搭建高效开发环境的模块化配置工具。

## 功能

- 模块化设计：单独安装和配置各组件
- 自动主题切换：根据系统设置或时间切换明暗主题
- 终端美化：Zsh + Powerlevel10k + Tmux
- Neovim配置：现代化编辑器设置

## 一键安装

复制以下命令到终端执行：

```bash
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/michael-lu-cn/ubuntu-init/main/bootstrap.sh)"
```

或者

```bash
sudo bash -c "$(wget -qO- https://raw.githubusercontent.com/michael-lu-cn/ubuntu-init/main/bootstrap.sh)"
```

## 模块列表

1. **基础模块**：系统工具和依赖
2. **Neovim模块**：现代编辑器配置
3. **tmux模块**：终端复用器和会话管理（C-t前缀键）
4. **zsh模块**：shell环境和提示符
5. **主题模块**：自动明暗主题管理

## 首次使用

- 终端支持自动明暗主题切换
- 首次打开Neovim时运行`:PackerSync`安装插件
- 首次打开tmux后，按`Ctrl+t`然后按`I`安装插件

## 配置文件位置

- Neovim: `~/.config/nvim/`
- Zsh: `~/.zshrc`, `~/.p10k.zsh`
- tmux: `~/.tmux.conf.local`
- 主题: `~/.config/auto-dark-mode/` 