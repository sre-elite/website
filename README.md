![example branch parameter](https://github.com/sre-elite/website/actions/workflows/hugo.yml/badge.svg?branch=main)

# SRE精英联盟官方网站

SRE精英联盟是一个专注于SRE领域的技术社区，我们致力于推动SRE领域的技术创新和实践，为SRE从业者提供学习、交流和分享的平台。

## 本地开发环境

为了确保本地开发环境与GitHub Actions构建环境一致，我们提供了Docker化的开发环境。

### 前置要求

- Docker
- Docker Compose

### 使用方法

#### 1. 构建生产版本（与GitHub Actions一致）

```bash
# 构建Docker镜像
docker-compose build

# 构建生产版本的网站
docker-compose run --rm hugo-build

# 构建完成后，public目录下会生成静态文件
```

#### 2. 开发模式（支持热重载）

```bash
# 启动开发服务器
docker-compose up hugo-dev

# 或者直接运行（自动检测架构）
docker run --rm -p 1313:1313 -v $(pwd):/workspace hugo-website \
  hugo server --bind 0.0.0.0 --baseURL http://localhost:1313 --buildDrafts --buildFuture

# 后台运行开发服务器
docker-compose up -d hugo-dev

# 查看日志
docker-compose logs -f hugo-dev

# 停止服务
docker-compose down
```

开发服务器启动后，访问 http://localhost:1313 查看网站。

#### 3. 生产环境测试模式

```bash
# 启动生产环境测试服务器（包含所有优化和压缩）
docker-compose up hugo-test
```

此模式模拟生产环境的构建过程，包括压缩、模板指标等，用于最终验证。

#### 4. 直接使用Docker命令

```bash
# 构建镜像（自动检测当前架构）
docker build -t hugo-website .

# 构建指定架构的镜像（可选）
docker buildx build --platform linux/amd64,linux/arm64 -t hugo-website .

# 构建网站
docker run --rm -v $(pwd):/workspace hugo-website

# 开发服务器
docker run --rm -p 1313:1313 -v $(pwd):/workspace hugo-website \
  hugo server --bind 0.0.0.0 --baseURL http://localhost:1313

# 生产环境测试
docker run --rm -p 1313:1313 -v $(pwd):/workspace hugo-website \
  hugo server --bind 0.0.0.0 --baseURL http://localhost:1313 \
  --disableFastRender --navigateToChanged --templateMetrics \
  --templateMetricsHints --buildDrafts --buildExpired \
  --buildFuture --watch --forceSyncStatic -e production --minify
```

### 架构支持

Docker环境支持多架构运行：

- **AMD64**: Intel/AMD 处理器（传统x86_64架构）
- **ARM64**: Apple Silicon (M1/M2/M3) 和其他ARM64处理器

镜像会自动检测当前系统架构并下载对应版本的Hugo二进制文件。

### 环境说明

Docker环境完全匹配GitHub Actions的构建环境：

- **Hugo版本**: 0.120.4 (Extended)
- **操作系统**: Ubuntu Latest
- **Dart Sass**: 通过npm安装
- **Node.js**: 支持主题的npm依赖
- **构建参数**: 与GitHub Actions完全一致

这样可以确保本地测试结果与线上部署结果完全一致，避免环境差异导致的问题。

## 发布流程重要说明

### /public 目录管理

本项目的 `/public` 目录包含构建后的静态文件，是生产环境部署的源文件。

**⚠️ 重要注意事项**:

1. **必须提交 `/public` 目录**: 每次内容修改后，必须运行构建命令并将生成的 `/public` 目录变更一起提交
2. **构建命令**: 
   ```bash
   hugo --minify --baseURL "https://www.sre-elite.com/"
   ```
3. **提交流程**:
   ```bash
   # 修改内容后，执行构建
   hugo --minify --baseURL "https://www.sre-elite.com/"
   
   # 提交所有变更，包括 public 目录
   git add .
   git add public/
   git commit -m "更新内容并重新构建静态文件"
   ```

4. **Docker 环境构建**:
   ```bash
   # 使用 Docker 进行本地构建验证
   docker-compose run --rm hugo-build
   
   # 检查 public 目录是否正确生成
   ls -la public/
   ```

详细发布流程请参考 [deploy.md](deploy.md)。

### 快速发布检查

完整的发布检查清单请参考 [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md)。

## 联系我们

### 微信号
![微信号](/static/images/wechat.jpg)

### B 站
![B站](/static/images/bilibili.jpg)

### YouTube
![YouTube](/static/images/youtube.png)