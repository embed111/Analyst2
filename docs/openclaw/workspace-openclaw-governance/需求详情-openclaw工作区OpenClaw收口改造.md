# 需求详情：openclaw 工作区 OpenClaw 收口改造

## 1. 主题目标与价值说明
`../openclaw` 当前已经最接近目标能力形态：具备 `SOUL.md`、`USER.md`、`MEMORY.md`、`TOOLS.md`、`HEARTBEAT.md`、`BOOTSTRAP.md`、`memory/`、`skills/`、`tasks/` 和 `.codex/skills/`。本主题目标不是补能力，而是做目录收口：把顶层 agent 工作文档和 agent 内部资产迁入 `.codex/`，让它从“能力完整但顶层暴露”收敛为“能力完整且目录契约统一”。

## 2. 用户画像与使用场景
1. Owner：希望 `openclaw` 作为最成熟样本，成为后续所有工作区的收口基准。
2. 执行方：需要一份明确的迁移映射，避免只改一半路径。

## 3. 用户旅程或关键流程
1. 盘点当前顶层 agent 工作文档与内部资产。
2. 将其迁入 `.codex/`。
3. 更新 `AGENTS.md` 的读取路径。
4. 验证主会话与日常记忆链路仍可用。

## 4. 功能需求清单
### FR-OCL-01 顶层 agent 文档迁移
1. 以下顶层文件必须迁入 `.codex/`：
   - `SOUL.md`
   - `USER.md`
   - `MEMORY.md`
   - `TOOLS.md`
   - `HEARTBEAT.md`
   - `IDENTITY.md`
   - `BOOTSTRAP.md`
2. 顶层 agent 工作文档最终只保留 `AGENTS.md`。

### FR-OCL-02 顶层 agent 资产迁移
1. `memory/ -> .codex/memory/`
2. `skills/ -> .codex/skills/`
3. `tasks/ -> .codex/tasks/`
4. 保留 `.openclaw/` 这类非 agent 工作文档目录不变。

### FR-OCL-03 更新 `AGENTS.md` 路径
1. 将 `AGENTS.md` 中对顶层 `SOUL.md`、`MEMORY.md`、`memory/` 的读取说明改为 `.codex/` 路径。
2. 主会话和非主会话的长期记忆隔离规则必须保留。

### FR-OCL-04 清理重复技能入口
1. 若顶层 `skills/` 与 `.codex/skills/` 存在重复职能，迁移后正式入口只保留 `.codex/skills/`。
2. 不得保留两套并行正式入口。

## 5. 非功能需求
1. 迁移必须带路径修复。
2. 迁移后能力不能回退。
3. 顶层必须显著收敛。

## 6. 验收标准
1. Given `../openclaw` 完成收口改造
2. When 检查顶层
3. Then agent 工作文档仅剩 `AGENTS.md`
4. And `memory/`、`skills/`、`tasks/` 已进入 `.codex/`
5. And `AGENTS.md` 已全部指向新路径

## 7. 边界条件与异常处理
1. 若某顶层文件虽与 OpenClaw 文档同名，但承担其他用途，必须单独说明例外。
2. 若迁移后发现某脚本仍依赖旧路径，需先修复后再验收通过。

## 8. 依赖项与开放问题
1. 依赖执行方具备批量迁移与搜索替换能力。
2. 开放问题：是否为 `.codex/tasks/` 增加索引说明；本轮不强制。
