# 执行提示词：Analyst 工作区 OpenClaw 试点改造

## 当前工作区路径
1. 工作区根目录：`D:\code\AI\J-Agents\Analyst`
2. 需求文档目录：`D:\code\AI\J-Agents\Analyst\docs\openclaw\workspace-openclaw-governance`
3. 本轮所有新增、修改、验证都只能发生在上述 `Analyst` 工作区根目录内。

请按照以下文件执行当前 `Analyst` 工作区整改，目标只限定为当前 `Analyst` 工作区，不要扩散到其他目录。

1. `D:\code\AI\J-Agents\Analyst\docs\openclaw\workspace-openclaw-governance\需求详情-Analyst工作区OpenClaw试点改造.md`
2. `D:\code\AI\J-Agents\Analyst\docs\openclaw\workspace-openclaw-governance\需求详情-OpenClaw工作区能力基线.md`

## 本轮目标
1. 让当前 `Analyst` 工作区具备最小 OpenClaw 风格记忆能力。
2. 将当前工作区仍留在顶层的 agent 相关资产收口到 `.codex/`。
3. 修复现有文档中仍指向顶层 `skills/` 的旧入口。
4. 保持现有 `workspace_state/`、`user_profile/`、`knowledge_base/` 治理链路继续可用。

## 必做事项
1. 为当前工作区补齐以下路径：
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - `.codex/MEMORY.md`
   - `.codex/TOOLS.md`
   - `.codex/HEARTBEAT.md`
   - `.codex/memory/`
2. 将 `skills/local-skills-overview.md` 迁移到 `.codex/skills/local-skills-overview.md`，或在最小变更前提下收口为 `.codex/skills/` 内等价正式入口。
3. 修复当前工作区所有正式入口中的旧路径引用，至少包括：
   - `AGENTS.md`
   - `workspace_state/core/startup-checklist.md`
   - `workspace_state/core/workspace-state-overview.md`
   - 其他仍把顶层 `skills/` 视为正式入口的当前有效文档
4. 为 `AGENTS.md` 补齐 OpenClaw 风格启动读取顺序：
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - 近两天 `.codex/memory/YYYY-MM-DD.md`
   - 主会话额外读取 `.codex/MEMORY.md`
5. 明确 OpenClaw 记忆层与现有状态治理层的职责边界，避免冲突：
   - `.codex/MEMORY.md` 负责 OpenClaw 风格长期记忆
   - `workspace_state/*`、`user_profile/*` 继续负责当前分析工作区的状态治理与偏好档案

## 禁止事项
1. 不要修改 `../Analyst2`、`../workflow`、`../openclaw` 等其他工作区。
2. 不要删除现有 `workspace_state/`、`user_profile/`、`knowledge_base/` 机制。
3. 不要只移动 `skills/local-skills-overview.md` 而不修复引用。
4. 不要把普通项目文档误迁入 `.codex/`。

## 交付物
1. 当前工作区改造后的目录清单。
2. 迁移与路径修复清单。
3. 启动读取验证证据。
4. 每日记忆写入验证证据。
5. 旧路径清零检索结果。

## 完成判定
1. 当前工作区具备 `.codex/SOUL.md`、`.codex/USER.md`、`.codex/MEMORY.md`、`.codex/TOOLS.md`、`.codex/HEARTBEAT.md`、`.codex/memory/`。
2. 正式技能总览入口位于 `.codex/skills/`，顶层 `skills/` 不再作为正式入口。
3. `AGENTS.md` 已具备 OpenClaw 风格读取顺序。
4. 当前有效文档中不再把 `skills/local-skills-overview.md` 作为正式入口。
