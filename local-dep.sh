#!/bin/bash

# 代码库克隆地址
REPO="git@github.com:sre-elite/website.git"

# 目标目录
TARGET_DIR="/opt/www.sre-elite.com/site/"

# 删除目标目录中的所有内容
rm -rf $TARGET_DIR/*
rm -rf /root/website

# 克隆代码库
git clone $REPO

# 部署 Hugo 静态站点
cp -r /root/website/public/* $TARGET_DIR
