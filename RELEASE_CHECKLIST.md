# 发布检查清单

## 开发阶段

- [ ] 从 main 分支创建新的功能分支
- [ ] 完成内容/功能开发
- [ ] 使用 Docker 环境进行本地测试：
  ```bash
  docker-compose up hugo-dev
  ```
- [ ] 访问 http://localhost:1313 验证修改效果

## 构建阶段

- [ ] 执行生产构建命令：
  ```bash
  hugo --minify --baseURL "https://www.sre-elite.com/"
  ```
  或使用 Docker：
  ```bash
  docker-compose run --rm hugo-build
  ```

- [ ] 检查 `/public` 目录是否正确更新：
  ```bash
  ls -la public/
  git status  # 确认 public/ 目录有变更
  ```

## 提交阶段

- [ ] 更新 `changelog.md` 文件，记录本次变更
- [ ] 提交所有变更，**必须包括 public 目录**：
  ```bash
  git add .
  git add public/  # 确保包含 public 目录
  git commit -m "描述性提交信息"
  git push origin your-branch-name
  ```

## GitHub 阶段

- [ ] 创建 Pull Request
- [ ] 确认 PR 包含以下内容：
  - [ ] 源文件修改（content/, layouts/, 等）
  - [ ] `/public` 目录的静态文件更新
  - [ ] `changelog.md` 更新
- [ ] 等待 GitHub Actions 构建成功
- [ ] 解决任何合并冲突（特别注意 `/public` 目录）
- [ ] 合并 PR 到 main 分支

## 部署阶段

- [ ] SSH 登录到 SRE-ELITE 服务器
- [ ] 执行部署脚本：
  ```bash
  sh local-dep.sh
  ```
- [ ] 等待脚本执行完成
- [ ] 清除浏览器缓存
- [ ] 访问 https://www.sre-elite.com/ 验证网站正常

## 异常处理

如果生产环境出现问题：
- [ ] **不要回滚**，而是修复问题
- [ ] 从 main 分支重新拉取代码
- [ ] 修复问题后重新走完整发布流程

## 常见问题

### Q: 为什么要提交 `/public` 目录？
A: `/public` 目录包含构建后的静态文件，是生产环境直接使用的文件。不提交会导致生产环境缺少最新的静态资源。

### Q: 如果忘记提交 `/public` 目录怎么办？
A: 重新运行构建命令，然后提交 `/public` 目录的变更：
```bash
hugo --minify --baseURL "https://www.sre-elite.com/"
git add public/
git commit -m "补充提交构建后的静态文件"
git push
```

### Q: Docker 环境和本地 Hugo 构建结果不一致怎么办？
A: 优先使用 Docker 环境的构建结果，因为它与 GitHub Actions 环境完全一致。
