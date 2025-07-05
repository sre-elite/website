# 部署新的版本

1. 确认修改需求，将其记录在 changelog.md 中，在文件的最上面新增一段。
2. git clone 代码库到本地。从 main 分支拉取最新代码。
3. 在本地创建新分支。在新分支中进行修改。
4. 本地测试后，进行提交前的全栈构建：

   ```bash
   hugo --minify --baseURL "https://www.sre-elite.com/"
   ```

5. 如果构建成功，提交代分支码到远程仓库。
6. 在 GitHub 上观察 Actions 是否成功运行。如果有错误，修复错误后重新提交代码。
7. 在 GitHub 上创建 Pull Request，并合并到 main 分支。
8. SSH 登录到 SRE-ELITE 服务器，在根目录下执行以下命令：

   ```bash
   # sh local-dep.sh
   ```

9. 等待脚本执行完成，检查网站是否正常运行。
10. 在浏览器中清除所有缓存，浏览器地址栏输入 `https://www.sre-elite.com/`，检查网站是否正常显示。