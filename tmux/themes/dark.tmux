# tmux暗色主题配置

# 状态栏颜色
set -g status-style fg=colour7,bg=colour235
set -g status-left '#[fg=colour7,bg=colour240] #S '
set -g status-right '#[fg=colour233,bg=colour241] %d/%m #[fg=colour233,bg=colour245] %H:%M:%S '

# 窗口状态颜色
setw -g window-status-current-style fg=colour81,bg=colour238,bold
setw -g window-status-style fg=colour138,bg=colour235,none

# 面板边框颜色
set -g pane-border-style fg=colour238
set -g pane-active-border-style fg=colour81

# 消息提示颜色
set -g message-style fg=colour81,bg=colour238 