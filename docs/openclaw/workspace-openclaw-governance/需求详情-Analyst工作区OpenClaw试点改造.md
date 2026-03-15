# 需求详情：Analyst 工作区 OpenClaw 试点改造

## 1. 主题目标与价值说明
本主题用于把 `Analyst` 当前工作区作为第一批试点对象，先完成一次“单工作区级”的 OpenClaw 能力与目录契约收口。价值如下：

1. 先在当前工作区验证“记忆能力补齐 + agent 工作资产迁入 `.codex/` + 路径修复”的完整链路。
2. 先解决当前工作区内部最明显的不一致，再将同一套模式推广到其余工作区。
3. 将跨工作区总方案落成一个可操作、可验收、可回归的最小样本。

## 2. 用户画像与使用场景
### 用户画像
1. Owner：希望先拿当前工作区验证方案，而不是直接一次性改完全部目录。
2. 当前工作区内的需求分析 agent：需要具备可恢复的 OpenClaw 风格记忆能力，同时保持现有需求分析职责边界。
3. 执行改造的维护者：需要一份直接针对当前目录现状的迁移清单，而不是再从跨工作区总文档里自行拆解。

### 使用场景
1. 新会话启动时，Analyst 工作区可以从 `.codex/` 中恢复身份、用户上下文和记忆。
2. 现有本地技能仍继续从 `.codex/skills/` 使用，但技能总览和引用路径不再留在顶层 `skills/`。
3. 当前工作区顶层不新增新的 agent 工作文档与相关资产漂移。

## 3. 用户旅程或关键流程
1. 盘点当前状态：
   - 确认顶层现状。
   - 确认 `.codex/`、`skills/`、状态文档和技能入口的当前分布。
2. 设计目标状态：
   - 明确哪些文件需要补齐。
   - 明确哪些顶层 agent 资产需要迁入 `.codex/`。
3. 执行迁移：
   - 补齐缺失的 OpenClaw 核心文档。
   - 迁移顶层 `skills/local-skills-overview.md`。
   - 修复所有引用。
4. 验收回归：
   - 启动读取顺序验证。
   - 记忆读写验证。
   - 旧路径残留验证。

## 4. 当前状态盘点
### 事实
1. 当前工作区顶层目录/文件为：
   - `.codex/`
   - `docs/`
   - `knowledge_base/`
   - `scripts/`
   - `skills/`
   - `test-results/`
   - `user_profile/`
   - `workspace_state/`
   - `.gitignore`
   - `AGENTS.md`
2. 当前工作区已具备 `.codex/skills/`，且实际本地技能已经位于 `.codex/skills/` 下。
3. 当前顶层 `skills/` 目录仅剩 `skills/local-skills-overview.md`。
4. 当前工作区尚未具备以下 OpenClaw 风格核心文件或目录：
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - `.codex/MEMORY.md`
   - `.codex/TOOLS.md`
   - `.codex/HEARTBEAT.md`
   - `.codex/memory/`
5. 当前 `AGENTS.md` 仍引用 `skills/local-skills-overview.md`，并在技能清单中使用 `skills/<skill>/SKILL.md` 风格路径，而实际技能目录已在 `.codex/skills/`。

### 推断/假设（置信度: 高）
1. 当前工作区已经完成了“技能实体迁入 `.codex/skills/`”，但仍停留在“技能总览留顶层、入口文档路径未完全收口”的过渡态。
2. 因为当前工作区以需求分析为主，试点改造不应改变其职责边界，只应补齐记忆能力与目录治理。

## 5. 功能需求清单
### FR-ANP-01 顶层保持现状约束
1. 当前工作区顶层继续只保留 `AGENTS.md` 这一份 agent 工作文档。
2. 本轮不得新增新的顶层 agent 工作文档。

### FR-ANP-02 补齐 OpenClaw 核心文档
1. 当前工作区必须补齐以下最小 OpenClaw 文档：
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - `.codex/MEMORY.md`
   - `.codex/TOOLS.md`
   - `.codex/HEARTBEAT.md`
2. 若需要补充工作区初始化语义，可增加 `.codex/BOOTSTRAP.md`，但不是本轮强制项。

### FR-ANP-03 补齐每日记忆目录
1. 当前工作区必须新增 `.codex/memory/`。
2. 每日记忆文件采用 `.codex/memory/YYYY-MM-DD.md`。
3. 如启用心跳状态记录，可在 `.codex/memory/heartbeat-state.json` 落位。

### FR-ANP-04 收口技能总览入口
1. 当前顶层 `skills/local-skills-overview.md` 必须迁移到 `.codex/skills/local-skills-overview.md` 或等价的 `.codex/skills/` 内标准入口文件。
2. 迁移后，顶层 `skills/` 目录若不再承载其他 agent 资产，应被清空并移除；若仍需保留，必须给出例外说明。

### FR-ANP-05 修复技能相关引用
1. `AGENTS.md` 中所有本地技能相关引用必须改为 `.codex/skills/` 口径。
2. `startup-checklist`、`workspace-state-overview`、状态日志及其他治理文档中，凡引用 `skills/local-skills-overview.md` 作为当前正式入口者，都必须同步修正为新路径。
3. 不允许继续出现“技能实际在 `.codex/skills/`，文档入口却仍指向顶层 `skills/`”的状态。

### FR-ANP-06 定义启动读取顺序
1. `AGENTS.md` 必须补齐当前工作区的 OpenClaw 风格启动读取顺序。
2. 启动默认顺序至少包含：
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - `.codex/memory/YYYY-MM-DD.md`（今天）
   - `.codex/memory/YYYY-MM-DD.md`（昨天）
3. 主会话必须额外读取 `.codex/MEMORY.md`。

### FR-ANP-07 保持现有状态治理链路兼容
1. 当前 `workspace_state/`、`user_profile/`、`knowledge_base/` 的现有治理机制不得因试点改造被删除或绕开。
2. 新增的 OpenClaw 记忆能力应与现有状态治理并存，不得直接替代已有的需求分析档案链路。
3. 若 OpenClaw 风格文档与现有状态治理文件存在语义重叠，必须在文档中明确各自职责，避免双写冲突。

### FR-ANP-08 明确 Analyst 工作区试点边界
1. 本轮只针对当前 `Analyst` 工作区。
2. 不要求同步修改 `../Analyst2`、`../workflow`、`../openclaw` 等其他目录。
3. 试点结论应作为后续批量推广的模板输入。

## 6. 迁移映射建议
1. `skills/local-skills-overview.md -> .codex/skills/local-skills-overview.md`
2. `AGENTS.md` 中：
   - `skills/local-skills-overview.md -> .codex/skills/local-skills-overview.md`
   - `skills/<skill>/SKILL.md -> .codex/skills/<skill>/SKILL.md`
3. 新增：
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - `.codex/MEMORY.md`
   - `.codex/TOOLS.md`
   - `.codex/HEARTBEAT.md`
   - `.codex/memory/`

## 7. 非功能需求
1. 兼容性：改造后不能破坏现有 `session-state-maintainer`、归档脚本和技能加载机制。
2. 可追溯性：必须能区分“OpenClaw 记忆能力”与“需求分析状态治理”各自承担什么职责。
3. 最小扰动：试点改造应优先做路径收口和能力补齐，不做无关目录重构。
4. 可复制性：最终结果应可复用到其他工作区。

## 8. 验收标准
### AC-ANP-01 核心文档补齐
1. Given 当前工作区完成试点改造
2. When 检查 `.codex/`
3. Then 至少存在 `.codex/SOUL.md`、`.codex/USER.md`、`.codex/MEMORY.md`、`.codex/TOOLS.md`、`.codex/HEARTBEAT.md` 和 `.codex/memory/`

### AC-ANP-02 技能总览收口
1. Given 当前工作区完成试点改造
2. When 检查本地技能总览入口
3. Then 正式入口位于 `.codex/skills/`，且顶层 `skills/` 不再作为正式 agent 入口

### AC-ANP-03 启动读取顺序生效
1. Given 当前工作区完成试点改造
2. When 启动主会话
3. Then `AGENTS.md` 会引导读取 `.codex/SOUL.md`、`.codex/USER.md`、近两天 `.codex/memory/*.md`，并额外读取 `.codex/MEMORY.md`

### AC-ANP-04 旧路径清零
1. Given 当前工作区完成试点改造
2. When 对 `AGENTS.md`、`workspace_state/` 核心启动文档和相关治理说明做检索
3. Then 不再存在把 `skills/local-skills-overview.md` 作为当前正式入口的旧引用

### AC-ANP-05 现有治理链路保留
1. Given 当前工作区完成试点改造
2. When 检查 `workspace_state/`、`user_profile/`、`knowledge_base/`
3. Then 现有需求分析状态治理链路仍然可用，且未被 OpenClaw 记忆能力错误替换

## 9. 边界条件与异常处理
1. 若当前工作区需要暂时保留顶层 `skills/` 目录作为历史兼容层，必须明确其仅为过渡兼容，不再作为正式入口。
2. 若新增 `.codex/MEMORY.md` 后与现有 `workspace_state/core/session-snapshot.md` 在用途上发生混淆，必须通过文档区分：
   - `MEMORY.md` 负责 OpenClaw 风格长期记忆；
   - `workspace_state/*` 负责当前分析工作区的状态治理与可恢复链路。
3. 若试点阶段不希望启用心跳轮询，可先补 `.codex/HEARTBEAT.md` 入口和禁用说明，再在后续阶段接通真实心跳。

## 10. 依赖项与开放问题
1. 依赖执行方能修改 `AGENTS.md`、迁移 `skills/local-skills-overview.md` 并补齐 `.codex/` 文档模板。
2. 依赖执行方明确区分“当前工作区既有状态治理”与“新增 OpenClaw 记忆层”的职责边界。
3. 开放问题：是否要将 `skills/local-skills-overview.md` 迁为 `.codex/skills/local-skills-overview.md`，还是升级为 `.codex/skills/README.md`；本轮默认前者，便于最小迁移。
