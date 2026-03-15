# 需求详情：skill_manager 工作区 OpenClaw 试点改造

## 1. 主题目标与价值说明
`../skill_manager` 当前已经具备 `.codex/skills/` 和 `workspace_state/`，但还缺少 OpenClaw 风格的身份、用户、长期记忆和每日记忆层。本主题目标是在保留其“全局 Skill 管理项目”定位的前提下，为其补齐记忆层。

## 2. 用户画像与使用场景
1. Owner：希望治理型工作区也具备统一记忆层。
2. `skill_manager` 内的 Skill 管理 agent：需要记住全局治理约定、演进决策和稳定策略。

## 3. 用户旅程或关键流程
1. 保留现有 `.codex/skills/`。
2. 在 `.codex/` 中补齐 `SOUL/USER/MEMORY/TOOLS/HEARTBEAT/memory`。
3. 在 `AGENTS.md` 中补齐读取顺序与边界说明。

## 4. 功能需求清单
### FR-SKM-01 补齐 `.codex` 记忆层
1. 在现有 `.codex/skills/` 基础上新增：
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - `.codex/MEMORY.md`
   - `.codex/TOOLS.md`
   - `.codex/HEARTBEAT.md`
   - `.codex/memory/`

### FR-SKM-02 更新 `AGENTS.md`
1. 保留现有“系统全局 Skill 管理项目 Leader”定位。
2. 补齐 OpenClaw 风格读取顺序。
3. 将 `.codex/skills/` 明确为本地技能正式入口。

### FR-SKM-03 保留现有状态治理
1. `workspace_state/` 继续负责治理与测试留痕。
2. `.codex/MEMORY.md` 与 `.codex/memory/` 负责 agent 个体记忆。
3. 不得混写。

## 5. 非功能需求
1. 不影响现有 `.codex/skills/` 结构。
2. 不破坏现有 skill 测试与控制链路。
3. 最小增量接入。

## 6. 验收标准
1. Given `../skill_manager` 完成试点改造
2. When 检查 `.codex/`
3. Then 既有 `.codex/skills/` 保持不变，且新增记忆层核心文档与 `memory/`
4. And `AGENTS.md` 已包含 OpenClaw 风格读取顺序

## 7. 边界条件与异常处理
1. 若某技能自带内部 memory，不得与工作区级 `.codex/MEMORY.md` 混用。
2. 若后续需要将全局治理决策沉淀到 `TOOLS.md`，应通过结构化条目维护。

## 8. 依赖项与开放问题
1. 依赖执行方补齐 `.codex/` 核心文档。
2. 开放问题：是否要把部分 skill 运行规范提升为 `.codex/TOOLS.md` 的长期条目；本轮不强制。
