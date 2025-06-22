#!/bin/bash

# Git初始化和提交脚本
# 作者: Claude
# 描述: 初始化Git仓库并提交到GitHub

echo "==============================================="
echo "初始化Git仓库并提交到GitHub"
echo "==============================================="

# 确保所有脚本有执行权限
echo "设置脚本执行权限..."
find . -type f -name "*.sh" -exec chmod +x {} \;

# 初始化Git仓库
echo "初始化Git仓库..."
git init

# 添加.gitignore文件
echo "创建.gitignore文件..."
cat > .gitignore << 'EOF'
# 系统文件
.DS_Store
Thumbs.db

# 编辑器/IDE文件
.idea/
.vscode/
*.swp
*.swo
*~

# 日志文件
*.log

# 临时文件
tmp/
temp/
EOF

# 添加所有文件
echo "添加文件到Git..."
git add .

# 初始提交
echo "创建初始提交..."
git commit -m "初始提交: Ubuntu开发服务器初始化脚本"

# 添加远程仓库
echo "添加GitHub远程仓库..."
git remote add origin https://github.com/michael-lu-cn/ubuntu-init.git

# 推送到GitHub
echo "推送到GitHub..."
echo "注意: 如果您使用的是HTTPS而不是SSH，可能需要输入GitHub凭据"
git push -u origin master || git push -u origin main

echo "==============================================="
echo "Git初始化和提交完成！"
echo "仓库地址: https://github.com/michael-lu-cn/ubuntu-init"
echo "===============================================" 