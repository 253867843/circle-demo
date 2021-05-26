#!/bin/bash
# circle-ci 已经把 vue 项目打包构建好了
# 发布到 Github Pages 上去
# vue 项目 -> Github -> Circle CI 构建 /dist -> depoly.sh 脚本，将 /dist -> Github Pages 

# 函数回调，-e 如果指令传回值不等于0，则立即退出 shell 脚本
set -e

# 打印当前的工作路径
pwd
remote=$(git config remote.origin.url)

# 打印远程仓库地址
echo 'remote is: '$remote

# 新建一个发布的目录
mkdir gh-pages-branch
cd gh-pages-branch

# 创建一个新的仓库
git config --global user.email "$GH_EMAIL" >/dev/null 2>&1
git config --global user.name "$GH_NAME" >/dev/null 2>&1
git init
git remote add --fetch origin "$remote"

echo 'email is: '$GH_EMAIL
echo 'name is: '$GH_NAME
echo 'siteSource is: '$siteSource

# 切换到 gh-pages 分支
if git rev-parse --overify origin/gh-pages >/
dev/null 2>&1;then
  echo 'gh-pages is exist, delete gh-pages content'
  git checkout gh-pages
  # 如果 gh-pages 分支存在, 则删除 gh-pages 分支中旧的文件内容
  rm -rf .  
else 
  # 如果 gh-pages 分支不存在，则创建无日志记录的 gh-pages 分支
  echo 'gh-pages is non-existent, create gh-pages'
  git checkout --orphan gh-pages
fi

# 把构建好的文件目录给拷贝进来
# siteSource === 'dist'
# cp -a "../dist/." . 把 dist 目录下的所有内容复制到当前目录下
cp -a "../${siteSource}/." .

ls -la

# 把所有文件添加到 stage 暂存区
git add -A
# 添加一条内容提交
git commit --allow-empty -m 'Depoly to Github Pages'
# 推送文件到远程 gh-pages 分支
git push --force --quiet origin gh-pages

# 资源回收
cd ..
# 删除临时分支和目录
rm -rf gh-pages-branch

# 脚本 End
echo 'Finished Depolyment!'