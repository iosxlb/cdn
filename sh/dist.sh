#!/bin/bash

# 检查并设置权限
if [ "$(id -u)" -ne "0" ]; then
    echo "脚本需要以 root 权限运行。请使用 sudo 执行。"
    exit 1
fi

# 停止服务
systemctl stop alist

# 进入目录
cd /opt/alist/data || { echo "无法进入 /opt/alist/data 目录"; exit 1; }

# 清理旧的 dist 目录
rm -rf dist

# 下载最新的 dist.zip
curl -O https://git.iosheikeji.com/dist_dir/3.36.0/dist.zip || { echo "下载失败"; exit 1; }

# 解压 dist.zip
unzip dist.zip || { echo "解压失败"; exit 1; }

# 删除 dist.zip
rm -f dist.zip

# 更新 config.json
sudo sed -i 's/"dist_dir": ""/"dist_dir": "data\/dist"/' /opt/alist/data/config.json || { echo "更新 config.json 失败"; exit 1; }

# 启动服务
systemctl start alist

echo "操作完成"
