#!/bin/bash

# 检测系统明暗模式状态的脚本
# 此脚本尝试使用多种方法检测系统主题
# 如果无法检测，默认使用亮色主题

THEME="light"  # 默认为亮色主题

# 1. 检测GNOME主题
if [ -n "$(command -v gsettings)" ]; then
    GNOME_THEME=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)
    if [[ "$GNOME_THEME" == *"dark"* ]]; then
        THEME="dark"
    fi
fi

# 2. 检测系统环境变量
if [ "$THEME" = "light" ] && [ -n "$COLORTERM" ] && [ -n "$TERM_PROGRAM" ]; then
    if [ -n "$COLORFGBG" ] && [[ "$COLORFGBG" == *";0"* ]]; then
        THEME="dark"
    fi
fi

# 3. 检测系统时间（晚上默认使用暗色）
if [ "$THEME" = "light" ]; then
    HOUR=$(date +%H)
    if [ "$HOUR" -ge 20 ] || [ "$HOUR" -lt 7 ]; then
        THEME="dark"
    fi
fi

# 输出主题模式
echo $THEME 