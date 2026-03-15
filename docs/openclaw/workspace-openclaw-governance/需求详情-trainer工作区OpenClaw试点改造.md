# 需求详情：trainer 工作区 OpenClaw 试点改造

## 1. 主题目标与价值说明
本主题用于将 `../trainer` 作为第二批试点对象，补齐 OpenClaw 风格记忆能力，同时保持其现有训练闭环目录 `.training/` 完整不变。目标不是重构训练师流程，而是在 `AGENTS.md + .training/` 之外，为该工作区增加一层统一的 agent 记忆与内部工作文档能力。

价值如下：

1. 让 `trainer` 在保留训练运行闭环的同时，具备与其他工作区一致的记忆与身份恢复能力。
2. 验证“运行态目录独立于 agent 记忆层”的分层模式。
3. 为后续 `skill_manager`、`agent_gen` 等偏工具型工作区提供更贴近的迁移样本。

## 2. 用户画像与使用场景
### 用户画像
1. Owner：希望跨工作区治理继续推进，不只停在 `workflow`。
2. `trainer` 工作区内的训练师 agent：每次进入工作区时，需要同时恢复训练流程规则和自身记忆。
3. 执行改造的维护者：需要明确 `.training/` 与 `.codex/` 的边界，不把它们混成一层。

### 使用场景
1. 会话启动时，先读取 `AGENTS.md`，再读取 `.codex/` 下身份与记忆文档，同时保留 `.training/` 作为训练运行态主目录。
2. 训练师在工作中将可复用经验写入 `.codex/memory/` 与 `.codex/MEMORY.md`，而不是污染 `.training/` 的任务运行记录。
3. 训练流程、评分、报告、归档继续留在 `.training/`。

## 3. 用户旅程或关键流程
1. 盘点当前状态：
   - 确认顶层结构。
   - 确认现有 `AGENTS.md` 启动读取顺序和训练流程入口。
2. 设计目标状态：
   - 保留 `.training/` 现有职责。
   - 新增 `.codex/` 作为 OpenClaw 记忆层。
3. 执行改造：
   - 创建 `.codex/` 及核心文档。
   - 更新 `AGENTS.md` 的读取顺序与边界说明。
4. 验收回归：
   - 验证记忆层可读写。
   - 验证 `.training/` 运行流程未被破坏。

## 4. 当前状态盘点
### 事实
1. `../trainer` 当前顶层仅有：
   - `.training/`
   - `AGENTS.md`
2. 当前顶层未发现 `.codex/`。
3. 当前顶层未发现 `SOUL.md`、`MEMORY.md`、`USER.md`、`TOOLS.md`、`HEARTBEAT.md`、`BOOTSTRAP.md` 等 OpenClaw 风格 agent 工作文档。
4. 当前 `AGENTS.md` 已定义：
   - 训练目标与角色；
   - 单轮流程；
   - 启动读取顺序；
   - 输出规范。
5. 当前启动读取顺序仍聚焦 `.training/trainer/policy/*` 与训练日志摘要，尚未引入 OpenClaw 风格的身份/用户/记忆层。

### 推断/假设（置信度: 高）
1. `trainer` 的结构已经天然符合“运行态单独隔离”的设计，因此新增 `.codex/` 的风险低于 `workflow`。
2. 该工作区最关键的设计点不是目录收口，而是边界说明：`.training/` 负责训练运行，`.codex/` 负责 agent 记忆。

## 5. 功能需求清单
### FR-TRN-01 顶层入口保持最小化
1. `../trainer` 顶层的 agent 工作文档继续只保留 `AGENTS.md`。
2. 本轮不得在顶层新增其他 agent 工作文档。

### FR-TRN-02 新增 `.codex/` 记忆层
1. `../trainer` 必须新增 `.codex/`。
2. `.codex/` 至少包含：
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - `.codex/MEMORY.md`
   - `.codex/TOOLS.md`
   - `.codex/HEARTBEAT.md`
   - `.codex/memory/`

### FR-TRN-03 更新 `AGENTS.md` 读取顺序
1. 在保留现有训练流程读取顺序的前提下，`AGENTS.md` 必须补齐 OpenClaw 风格记忆读取顺序。
2. 默认顺序至少包含：
   - `AGENTS.md`
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - `.codex/memory/YYYY-MM-DD.md`（今天）
   - `.codex/memory/YYYY-MM-DD.md`（昨天）
   - `.training/trainer/policy/*.yaml`
   - `.training/trainer/logs/summaries/daily-summary.md`
   - `.training/trainer/logs/summaries/failure-cases.md`
3. 主会话必须额外读取 `.codex/MEMORY.md`。

### FR-TRN-04 明确 `.training/` 与 `.codex/` 职责边界
1. `.training/` 继续负责：
   - 任务队列；
   - 调度；
   - 评分；
   - 审核；
   - 报告；
   - 训练归档。
2. `.codex/` 负责：
   - 身份；
   - 用户上下文；
   - 每日记忆；
   - 长期记忆；
   - 工具与心跳约束。
3. 不得把训练运行日志写入 `.codex/MEMORY.md`，也不得把 agent 个体记忆写回 `.training/` 冒充训练记录。

### FR-TRN-05 保留训练约束不回退
1. `AGENTS.md` 中现有训练角色、关键约束和单轮流程不得因本轮改造被删改到失真。
2. 候选体可修改范围、高风险任务约束和评分闭环要求必须保留。

### FR-TRN-06 每日记忆机制
1. `../trainer` 必须支持 `.codex/memory/YYYY-MM-DD.md`。
2. 当天文件不存在时，首次写入可自动创建。
3. 记忆内容应偏向：
   - 训练策略经验；
   - 常见失败模式；
   - 判断口径；
   - 对后续训练会话有恢复价值的信息。

### FR-TRN-07 心跳入口
1. `../trainer` 必须补 `.codex/HEARTBEAT.md`。
2. 若当前阶段不启用真实心跳轮询，可先写明禁用/保留策略，但入口文件必须存在。

## 6. 迁移与新增建议
1. 新增：
   - `../trainer/.codex/`
   - `../trainer/.codex/SOUL.md`
   - `../trainer/.codex/USER.md`
   - `../trainer/.codex/MEMORY.md`
   - `../trainer/.codex/TOOLS.md`
   - `../trainer/.codex/HEARTBEAT.md`
   - `../trainer/.codex/memory/`
2. 更新：
   - `../trainer/AGENTS.md`，补齐 OpenClaw 风格读取顺序与边界说明

## 7. 非功能需求
1. 最小扰动：不重构 `.training/` 内部结构。
2. 兼容性：训练流程和现有任务闭环不受损。
3. 可追溯性：能清楚区分“训练运行记录”与“agent 个体记忆”。
4. 一致性：命名和读取顺序与总方案保持一致。

## 8. 验收标准
### AC-TRN-01 `.codex` 记忆层存在
1. Given `../trainer` 完成试点改造
2. When 检查顶层
3. Then 存在 `.codex/`，且其中至少包含 `SOUL.md`、`USER.md`、`MEMORY.md`、`TOOLS.md`、`HEARTBEAT.md`、`memory/`

### AC-TRN-02 读取顺序兼容训练规则
1. Given `../trainer` 完成试点改造
2. When 启动主会话
3. Then 会先读取 `AGENTS.md` 与 `.codex/` 记忆层，再继续读取 `.training/` 下的训练规则与摘要文件

### AC-TRN-03 边界清晰
1. Given `../trainer` 完成试点改造
2. When 检查 `AGENTS.md` 与新增 `.codex/*`
3. Then 能明确分辨 `.training/` 和 `.codex/` 各自职责

### AC-TRN-04 训练运行链路不受损
1. Given `../trainer` 完成试点改造
2. When 执行最小训练链路回归
3. Then 现有训练运行逻辑未因本轮改造受损

## 9. 边界条件与异常处理
1. 若当前阶段不希望让训练师启用心跳轮询，可在 `.codex/HEARTBEAT.md` 中只保留禁用说明和未来启用入口。
2. 若后续希望让 `.training/` 中部分经验反哺 `.codex/MEMORY.md`，必须通过显式提炼规则实现，不得直接复制训练日志。

## 10. 依赖项与开放问题
1. 依赖执行方能更新 `../trainer/AGENTS.md` 并新增 `.codex/` 结构。
2. 依赖执行方在改造后做最小训练链路回归。
3. 开放问题：`trainer` 是否需要在后续阶段引入 `.codex/skills/`；当前先不强制，以最小记忆层补齐为主。
