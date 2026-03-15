# 需求详情：agent_gen 工作区 OpenClaw 试点改造

## 1. 主题目标与价值说明
`../agent_gen` 是配置驱动的 Agent 生成工作区。它当前具备完整的生成逻辑和配置校验链路，但尚未具备 OpenClaw 风格的记忆层与内部工作区结构。本主题目标是在不破坏其“配置优先、脚本化生成”特性的前提下，为它补齐统一的 `.codex/` 记忆层。

## 2. 用户画像与使用场景
1. Owner：希望生成类工作区也具备统一记忆与恢复能力。
2. `agent_gen` 内的生成 agent：需要记住近期生成策略、配置约定和失败样本。
3. 执行方：需要在不动生成主流程的前提下补齐 `.codex/`。

## 3. 用户旅程或关键流程
1. 保留原有配置读取与生成流程。
2. 新增 `.codex/` 记忆层。
3. 通过 `AGENTS.md` 将身份/用户/记忆读取和生成规则并列定义。

## 4. 功能需求清单
### FR-AGG-01 顶层规则
1. 顶层继续只保留 `AGENTS.md` 作为 agent 工作文档。
2. 保留现有 `docs/`、`reports/`、`templates/`、`tests/`、脚本与配置文件不变。

### FR-AGG-02 补齐 `.codex/`
1. 新增：
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - `.codex/MEMORY.md`
   - `.codex/TOOLS.md`
   - `.codex/HEARTBEAT.md`
   - `.codex/memory/`

### FR-AGG-03 更新启动读取顺序
1. `AGENTS.md` 必须补齐：
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - 近两天 `.codex/memory/*.md`
   - 主会话额外读取 `.codex/MEMORY.md`
2. 保留原有“配置优先、最小假设、可验证”的生成规则。

### FR-AGG-04 记忆内容边界
1. `.codex/MEMORY.md` 与 `.codex/memory/` 只记录 agent 生成经验、配置约束、失败模式和稳定约定。
2. `reports/`、`tests/`、`docs/` 继续承载正式输出与验证产物。

## 5. 非功能需求
1. 不破坏现有生成脚本和配置驱动模式。
2. 不把运行产物与 agent 记忆混写。
3. 目录新增尽量最小。

## 6. 验收标准
1. Given `../agent_gen` 完成试点改造
2. When 检查顶层与 `.codex/`
3. Then 顶层仍只有 `AGENTS.md` 作为 agent 工作文档，且 `.codex/` 核心文档齐全
4. And `AGENTS.md` 已补齐 OpenClaw 风格读取顺序

## 7. 边界条件与异常处理
1. 若当前阶段不需要本地技能，可暂不新增 `.codex/skills/`。
2. 若后续需要将生成模板沉淀为共享技能，再单独扩展。

## 8. 依赖项与开放问题
1. 依赖执行方更新 `AGENTS.md` 并补齐 `.codex/`。
2. 开放问题：是否要后续把部分模板规范沉淀进 `.codex/TOOLS.md`；本轮不强制。
