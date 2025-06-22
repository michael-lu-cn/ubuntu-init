# tmux亮色主题配置

# 状态栏颜色
set -g status-style fg=colour235,bg=colour252
set -g status-left '#[fg=colour232,bg=colour248] #S '
set -g status-right '#[fg=colour233,bg=colour251] %d/%m #[fg=colour233,bg=colour248] %H:%M:%S '

# 窗口状态颜色
setw -g window-status-current-style fg=colour25,bg=colour252,bold
setw -g window-status-style fg=colour238,bg=colour250,none

# 面板边框颜色
set -g pane-border-style fg=colour238
set -g pane-active-border-style fg=colour32

# 消息提示颜色
set -g message-style fg=colour232,bg=colour252 