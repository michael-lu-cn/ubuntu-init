# Powerlevel10k亮色主题配置
# 生成自定义配置: p10k configure

# 主提示符元素
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon                 # 操作系统图标
  dir                     # 当前目录
  vcs                     # git状态
  prompt_char             # 提示符
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status                  # 上一条命令的退出代码
  command_execution_time  # 前一条命令的执行时间
  background_jobs         # 后台作业的存在
  direnv                  # direnv状态
  asdf                    # asdf版本管理器
  virtualenv              # Python虚拟环境
  anaconda                # conda环境
  pyenv                   # python环境
  goenv                   # go环境
  nodenv                  # node.js版本
  nvm                     # node.js版本
  nodeenv                 # node.js环境
  rbenv                   # ruby环境
  rvm                     # ruby环境
  kubecontext             # 当前kubernetes上下文
  terraform               # terraform工作区
  aws                     # aws配置文件
  time                    # 当前时间
)

# 添加换行符
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# 目录缩短策略
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

# 使用nerd字体
typeset -g POWERLEVEL9K_MODE=nerdfont-complete

# 图标设置
typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\uF126 '
typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='\u25CF'
typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON='\u00B1'
typeset -g POWERLEVEL9K_VCS_STAGED_ICON='\u00A7'

# Git状态显示
typeset -g POWERLEVEL9K_VCS_SHOW_SUBMODULE_DIRTY=false
typeset -g POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS=0.05

# 提示符字符
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_VISUAL_IDENTIFIER_EXPANSION='❯'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_VISUAL_IDENTIFIER_EXPANSION='❮'

# 颜色 - 亮色主题
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=28
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=160

# 公共设置
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=28
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=''
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=''
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=''
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX=''
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=''

# 目录颜色 - 亮色主题
typeset -g POWERLEVEL9K_DIR_FOREGROUND=25
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=103
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=25

# VCS颜色 - 亮色主题
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=28
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=130
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=25
typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=160
typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=244

# 状态颜色
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=28
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=160
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=160

# 后台作业
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false

# Python环境
typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=25

# 时间格式
typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
typeset -g POWERLEVEL9K_TIME_FOREGROUND=244

# 命令执行时间
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=101

# 事务成功
typeset -g POWERLEVEL9K_{COMMAND_EXECUTION_TIME,DIRENV,VCS_STAGED,VCS_UNSTAGED,VCS_UNTRACKED,STATUS_ERROR,STATUS_ERROR_SIGNAL,BACKGROUND_JOBS,VIRTUALENV}_VISUAL_IDENTIFIER_EXPANSION='' 