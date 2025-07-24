# 部署新的版本

1. 确认修改需求。
2. git clone 代码库到本地。从 main 分支拉取最新代码。
3. 将本次发布变更记录在 changelog.md 中，在文件的最上面新增一段。
4. 在本地创建新分支。在新分支中进行修改。
5. 本地测试后，进行提交前的全栈构建：

   ```bash
   hugo --minify --baseURL "https://www.sre-elite.com/"
   ```

   **⚠️ 重要提醒**: 
   - 构建完成后，`/public` 目录会生成/更新静态文件
   - 必须将 `/public` 目录的所有变更一起提交到分支
   - `/public` 目录是生产环境部署的源文件，不能忽略

6. 如果构建成功，提交代码到远程仓库：
   
   ```bash
   # 确保包含 public 目录的所有变更
   git add .
   git add public/
   git commit -m "更新内容并重新构建静态文件"
   git push origin your-branch-name
   ```
   ```

7. 在 GitHub 上观察 Actions 是否成功运行。如果有错误，修复错误后重新提交代码。
8. 在 GitHub 上创建 Pull Request，并合并到 main 分支。
   
   **⚠️ 合并检查清单**:
   - [ ] 确认 PR 包含源文件修改
   - [ ] 确认 PR 包含 `/public` 目录更新
   - [ ] 确认 GitHub Actions 构建成功
   - [ ] 确认没有合并冲突，特别是 `/public` 目录
9. SSH 登录到 SRE-ELITE 服务器，在根目录下执行以下命令：

   ```bash
   # sh local-dep.sh
   ```

10. 等待脚本执行完成，检查网站是否正常运行。
11. 在浏览器中清除所有缓存，浏览器地址栏输入 `https://www.sre-elite.com/`，检查网站是否正常显示。
12. 如果发现生产环境的网站有问题，不要回滚到上一个版本，请回到第二步，重新从 main 分支拉取最新代码，修复问题后重新部署。
