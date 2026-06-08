## 开发规范

### 新增功能 / Bug 修复的标准流程

1. **克隆代码**
   ```bash
   git clone <仓库地址>
   cd <项目目录>
   ```

2. **创建分支**
   ```bash
   git checkout -b feature/<功能名>   # 新功能
   git checkout -b fix/<bug描述>      # Bug 修复
   ```

3. **创建 Worktree（可选）**

   如果你在同一台机器上并行处理多个任务，建议为每个分支创建独立的 worktree，避免环境冲突：
   ```bash
   git worktree add ../<项目名>-<分支名> <分支名>
   ```
   > 单 Agent 工作时，仅新建分支即可，无需额外创建 worktree。

4. **开发与测试**
   - 完成代码修改
   - 本地测试验证

5. **合并到主分支**
   ```bash
   git checkout main
   git merge --no-ff feature/<功能名>
   ```
