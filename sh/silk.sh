#!/bin/bash

set -e  # 遇到错误时退出

cd /opt

# 克隆仓库
if ! git clone https://github.com/iosxlb/silk-v3-decoder.git; then
    echo "克隆仓库失败"
    exit 1
fi

cd silk-v3-decoder

# 设置权限
chmod 755 silk-v3-decoder

# 执行 converter.sh
if [[ -x converter.sh ]]; then
    ./converter.sh
else
    echo "converter.sh 不可执行或未找到"
    exit 1
fi

cd silk

# 编译
make encoder
make decoder

# 复制并设置权限
cp encoder /usr/local/bin/
chmod 755 /usr/local/bin/encoder
