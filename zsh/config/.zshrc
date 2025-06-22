# 启用Powerlevel10k即时提示
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 启用Powerlevel10k主题
ZSH_THEME="powerlevel10k/powerlevel10k"

# oh-my-zsh路径
export ZSH="$HOME/.oh-my-zsh"

# 插件
plugins=(
  git
  docker
  docker-compose
  zsh-autosuggestions
  zsh-syntax-highlighting
  z
  history
  extract
  sudo
  copypath
)

source $ZSH/oh-my-zsh.sh

# 加载Powerlevel10k配置
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# 别名
alias vim="nvim"
alias vi="nvim"
alias ll="ls -la"
alias la="ls -a"
alias lt="ls -lat"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# 历史命令设置
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS

# 默认编辑器
export EDITOR='nvim'
export VISUAL='nvim'

# 加载fzf配置
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# 检测并应用主题（如果主题模块已安装）
if [ -f ~/.config/auto-dark-mode/check-theme.sh ]; then
  ~/.config/auto-dark-mode/check-theme.sh > /tmp/current_theme 2>/dev/null
  if [ -f ~/.tmux.conf ] && [ -z "$TMUX" ]; then
    # 非tmux会话中，设置主题
    CURRENT_THEME=$(cat /tmp/current_theme 2>/dev/null || echo "light")
    if [ "$CURRENT_THEME" = "dark" ]; then
      export BAT_THEME="Dracula"
      export TERM_THEME="dark"
    else
      export BAT_THEME="GitHub"
      export TERM_THEME="light"
    fi
  fi
  
  # 每次启动终端检查主题变化
  if [ -f /tmp/current_theme ] && [ -f ~/.config/auto-dark-mode/auto-dark-mode.sh ]; then
    ~/.config/auto-dark-mode/auto-dark-mode.sh > /dev/null 2>&1
  fi
fi 