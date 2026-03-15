# 需求详情：Analyst2 工作区 OpenClaw 试点改造

## 1. 主题目标与价值说明
`../Analyst2` 与当前 `Analyst` 高度同型，已经具备 `.codex/skills/`、`workspace_state/`、`user_profile/`、`knowledge_base/` 等分析治理资产，但仍缺少 OpenClaw 风格的身份/用户/记忆层。本主题目标是以最小改动补齐 `.codex` 记忆层，并收口仍留在顶层 `skills/` 的正式入口。

## 2. 用户画像与使用场景
1. Owner：希望 `Analyst2` 与 `Analyst` 一样具备统一的记忆与目录契约。
2. `Analyst2` 内的需求分析 agent：需要恢复身份、用户上下文和个体记忆，同时继续遵守 `MEMORY_UPDATE_SWITCH: OFF` 等既有治理规则。

## 3. 用户旅程或关键流程
1. 保留既有分析治理链路。
2. 补齐 `.codex/SOUL.md`、`.codex/USER.md`、`.codex/MEMORY.md` 等。
3. 将顶层 `skills/local-skills-overview.md` 收口到 `.codex/skills/` 正式入口。

## 4. 功能需求清单
### FR-A2-01 补齐 OpenClaw 核心文档
1. 新增：
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - `.codex/MEMORY.md`
   - `.codex/TOOLS.md`
   - `.codex/HEARTBEAT.md`
   - `.codex/memory/`

### FR-A2-02 保留现有治理链路
1. 保留：
   - `workspace_state/`
   - `user_profile/`
   - `knowledge_base/`
2. `MEMORY_UPDATE_SWITCH: OFF` 的现有语义不得被 OpenClaw 记忆层覆盖。

### FR-A2-03 收口技能入口
1. 顶层 `skills/local-skills-overview.md` 必须迁入 `.codex/skills/` 或等价正式入口。
2. `AGENTS.md`、`workspace_state/*` 等当前有效文档中的旧路径必须同步修复。

### FR-A2-04 更新读取顺序
1. `AGENTS.md` 必须补齐 OpenClaw 风格读取顺序。
2. 读取 OpenClaw 记忆层后，再继续执行既有 `workspace_state/` 恢复链路。

## 5. 非功能需求
1. 与 `Analyst` 口径保持一致。
2. 不破坏现有偏好治理和快照机制。
3. 不新增无关目录改造。

## 6. 验收标准
1. Given `../Analyst2` 完成试点改造
2. When 检查 `.codex/`
3. Then 核心 OpenClaw 文档与 `memory/` 已补齐
4. And 顶层 `skills/` 不再作为正式技能入口
5. And 既有 `MEMORY_UPDATE_SWITCH: OFF` 逻辑仍保留

## 7. 边界条件与异常处理
1. 若与 `Analyst` 的差异仅在路径层，可优先复用同型方案，不做定制化重构。
2. 若 `Analyst2` 当前仍有扁平路径历史包袱，需在改造时显式记录。

## 8. 依赖项与开放问题
1. 依赖执行方参考 `Analyst` 试点方案做同型落地。
2. 开放问题：是否同步整理 `workspace_state` 与 `user_profile` 的子目录结构；本轮不强制。
