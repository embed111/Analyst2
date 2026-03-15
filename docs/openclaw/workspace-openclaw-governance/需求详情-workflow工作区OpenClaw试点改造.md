# 需求详情：workflow 工作区 OpenClaw 试点改造

## 1. 主题目标与价值说明
本主题用于将 `../workflow` 作为跨工作区改造的第一批执行对象，补齐 OpenClaw 风格记忆能力与 agent 工作区目录契约。目标不是改变 `workflow` 的业务产品结构，而是在不破坏现有运行链路的前提下，为它增加统一的 agent 记忆层和 `.codex/` 工作区能力层。

价值如下：

1. 让 `workflow` 具备与其他 agent 工作区一致的记忆能力和内部工作文档结构。
2. 修复当前“代码和文档默认依赖 `.codex/skills/`，但工作区顶层并无 `.codex/`”的结构缺口。
3. 为后续其他工作区批量推广形成一个“非 Analyst 型工作区”的标准样本。

## 2. 用户画像与使用场景
### 用户画像
1. Owner：希望从 `workflow` 开始推进实际改造，而不是只停留在总方案。
2. `workflow` 工作区内的 agent：需要在每次进入工作区时可恢复身份、上下文和记忆。
3. 执行改造的维护者：需要知道这次改造的边界是“补齐 agent 工作区能力”，而不是重构 `workflow` 的业务模块。

### 使用场景
1. 新会话进入 `workflow` 工作区时，agent 能读取 `.codex/SOUL.md`、`.codex/USER.md`、近两天 `.codex/memory/*.md` 和主会话长期记忆。
2. `workflow` 保持现有 `docs/`、`logs/`、`state/`、`src/`、`scripts/` 结构不变，同时新增 `.codex/` 作为 agent 内部工作区层。
3. 现有文档和代码里对 `.codex/skills/` 的假设能与真实目录结构对齐。

## 3. 用户旅程或关键流程
1. 盘点当前状态：
   - 确认顶层目录与运行资产分布。
   - 确认现有 `AGENTS.md` 的职责与读取规则。
   - 确认文档/代码对 `.codex/skills/` 的引用。
2. 设计目标状态：
   - 为 `workflow` 增加 `.codex/` 能力层。
   - 明确 OpenClaw 记忆层与现有 `state/`、`logs/` 的职责分工。
3. 执行改造：
   - 创建 `.codex/` 结构与核心文档。
   - 补齐 `.codex/skills/` 正式入口。
   - 更新 `AGENTS.md` 读取顺序。
4. 验收回归：
   - 启动读取验证。
   - 记忆写入验证。
   - `.codex/skills/` 路径一致性验证。

## 4. 当前状态盘点
### 事实
1. `../workflow` 当前顶层目录/文件为：
   - `.runtime/`
   - `docs/`
   - `logs/`
   - `metrics/`
   - `scripts/`
   - `src/`
   - `state/`
   - `AGENTS.md`
   - `run_workflow.bat`
   - 若干临时日志文件
2. 当前顶层未发现 `.codex/`。
3. 当前顶层未发现 `SOUL.md`、`MEMORY.md`、`USER.md`、`TOOLS.md`、`HEARTBEAT.md`、`BOOTSTRAP.md` 等 OpenClaw 风格 agent 工作文档。
4. 当前 `AGENTS.md` 主要描述的是仓库结构、开发命令、状态与复盘规则，尚未包含 OpenClaw 风格的身份/用户/记忆读取顺序。
5. 当前 `workflow` 代码和文档中已经多次显式使用 `.codex/skills/` 作为 agent 工作区技能入口或展示来源，例如：
   - `docs/workflow/overview/需求概述.md`
   - `docs/workflow/requirements/需求详情-角色画像发布格式与预发布判定.md`
   - `src/workflow_app/server/services/release_management_service.py`

### 推断/假设（置信度: 高）
1. `workflow` 当前已经具备“认知上把 `.codex/skills/` 当成本地技能源”的前置假设，但缺少真实的 `.codex/` 工作区层，因此现在最合理的改造是补齐这层，而不是另起一套并行路径。
2. 由于 `workflow` 已有 `state/` 和 `logs/`，OpenClaw 记忆层必须明确为“agent 工作记忆”，而不是替代现有产品运行态。

## 5. 功能需求清单
### FR-WFO-01 顶层入口保持最小化
1. `../workflow` 顶层的 agent 工作文档只保留 `AGENTS.md`。
2. 本轮不得在顶层新增 `SOUL.md`、`MEMORY.md`、`USER.md`、`TOOLS.md`、`HEARTBEAT.md` 等 agent 工作文档。

### FR-WFO-02 新增 `.codex/` 工作区能力层
1. `../workflow` 必须新增 `.codex/`。
2. `.codex/` 至少包含：
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - `.codex/MEMORY.md`
   - `.codex/TOOLS.md`
   - `.codex/HEARTBEAT.md`
   - `.codex/memory/`
   - `.codex/skills/`

### FR-WFO-03 补齐最小 OpenClaw 记忆能力
1. 工作区必须支持 `.codex/memory/YYYY-MM-DD.md` 作为每日记忆文件。
2. 工作区必须支持 `.codex/MEMORY.md` 作为长期记忆主档。
3. 若当天记忆文件不存在，首次写入时必须可创建。

### FR-WFO-04 更新 `AGENTS.md` 启动读取顺序
1. `../workflow/AGENTS.md` 必须补齐会话启动读取顺序。
2. 默认读取顺序至少应包含：
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - `.codex/memory/YYYY-MM-DD.md`（今天）
   - `.codex/memory/YYYY-MM-DD.md`（昨天）
3. 主会话必须额外读取 `.codex/MEMORY.md`。
4. 非主会话默认不读取 `.codex/MEMORY.md`。

### FR-WFO-05 对齐 `.codex/skills/` 正式入口
1. 当前工作区所有把 `.codex/skills/` 当成正式技能入口的代码与文档，必须与真实目录结构一致。
2. 若当前没有本地技能实现，也必须保留 `.codex/skills/` 目录和最小入口说明，避免文档与运行环境继续错位。
3. 不得新增另一套平行技能路径。

### FR-WFO-06 明确记忆层与运行态边界
1. `.codex/MEMORY.md` 与 `.codex/memory/` 负责 agent 工作记忆。
2. `state/` 继续负责产品运行态、配置态和复盘文件。
3. `logs/` 继续负责运行与审计留痕。
4. 改造时必须在 `AGENTS.md` 或配套说明中显式区分这三层职责，避免误把 OpenClaw 记忆写入产品运行态。

### FR-WFO-07 保持现有仓库运行链路不回退
1. 本轮不得破坏：
   - `run_workflow.bat`
   - `scripts/launch_workflow.ps1`
   - `state/`
   - `logs/`
   - `docs/workflow/`
   - `src/workflow_app/`
2. OpenClaw 能力补齐应作为“agent 工作区层增强”，不是产品结构重构。

### FR-WFO-08 首批只做当前工作区
1. 本轮执行只针对 `../workflow`。
2. 不同步修改 `../openclaw`、`../trainer`、`../skill_manager` 等其他目录。

## 6. 迁移与新增建议
1. 新增目录：
   - `../workflow/.codex/`
   - `../workflow/.codex/memory/`
   - `../workflow/.codex/skills/`
2. 新增文档：
   - `../workflow/.codex/SOUL.md`
   - `../workflow/.codex/USER.md`
   - `../workflow/.codex/MEMORY.md`
   - `../workflow/.codex/TOOLS.md`
   - `../workflow/.codex/HEARTBEAT.md`
3. 更新：
   - `../workflow/AGENTS.md` 增加 OpenClaw 风格读取顺序和边界说明
4. 如当前需为 `.codex/skills/` 提供最小可见入口，可新增：
   - `../workflow/.codex/skills/README.md` 或等价说明文件

## 7. 非功能需求
1. 兼容性：不影响现有 `workflow` 的 Web、CLI、验收脚本和运行态。
2. 可追溯性：新增记忆层后，必须仍能清楚分辨“agent 记忆”和“产品运行数据”。
3. 一致性：`workflow` 的 OpenClaw 能力层命名、读取顺序和路径风格必须与总方案一致。
4. 最小扰动：除补齐 `.codex/` 和必要文档/引用外，不做无关目录调整。

## 8. 验收标准
### AC-WFO-01 `.codex` 能力层存在
1. Given `../workflow` 完成试点改造
2. When 检查顶层
3. Then 存在 `.codex/`，且其中至少包含 `SOUL.md`、`USER.md`、`MEMORY.md`、`TOOLS.md`、`HEARTBEAT.md`、`memory/`、`skills/`

### AC-WFO-02 启动读取顺序生效
1. Given `../workflow` 完成试点改造
2. When 启动主会话
3. Then `AGENTS.md` 会引导读取 `.codex/SOUL.md`、`.codex/USER.md`、近两天 `.codex/memory/*.md`，并额外读取 `.codex/MEMORY.md`

### AC-WFO-03 `.codex/skills/` 口径一致
1. Given `../workflow` 完成试点改造
2. When 检查工作区代码和文档中与技能相关的正式入口
3. Then `.codex/skills/` 与真实目录结构一致，不再出现“文档假设存在但实际目录缺失”的状态

### AC-WFO-04 记忆层与运行态分层清晰
1. Given `../workflow` 完成试点改造
2. When 检查新增文档与 `AGENTS.md`
3. Then 能明确区分 `.codex/*`、`state/*`、`logs/*` 各自职责

### AC-WFO-05 运行链路不受损
1. Given `../workflow` 完成试点改造
2. When 执行基础启动或门禁回归
3. Then 现有运行链路和关键入口未因本轮改造被破坏

## 9. 边界条件与异常处理
1. 若 `workflow` 当前暂无本地技能实现，`.codex/skills/` 仍应保留为空目录或最小说明入口，以满足现有文档/代码口径。
2. 若后续发现某些运行链路会误读 `.codex/MEMORY.md` 为产品配置，需要在实现层增加显式隔离，而不是回退目录方案。
3. 若试点阶段暂不启用心跳轮询，可先补 `.codex/HEARTBEAT.md` 和禁用说明，再在后续接入真实轮询。

## 10. 依赖项与开放问题
1. 依赖执行方能修改 `../workflow/AGENTS.md` 并新增 `.codex/` 结构。
2. 依赖执行方在改造后做最小运行回归，证明产品运行链路未受损。
3. 开放问题：`.codex/skills/` 在 `workflow` 中是先创建空目录，还是同步补一批最小本地技能模板；当前默认前者，以最小扰动完成试点。
