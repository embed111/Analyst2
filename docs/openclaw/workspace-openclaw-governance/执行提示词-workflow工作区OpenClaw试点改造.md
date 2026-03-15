# 执行提示词：workflow 工作区 OpenClaw 试点改造

请按照文件 **`docs/openclaw/workspace-openclaw-governance/需求详情-workflow工作区OpenClaw试点改造.md`** 和 **`docs/openclaw/workspace-openclaw-governance/需求详情-OpenClaw工作区能力基线.md`** 中的要求执行，目标只限定为 `../workflow` 工作区，不要扩散到其他目录。

## 本轮目标
1. 为 `../workflow` 新增 `.codex/` 工作区能力层。
2. 为 `../workflow` 补齐最小 OpenClaw 风格记忆能力。
3. 让 `../workflow` 中现有对 `.codex/skills/` 的文档/代码假设与真实目录结构对齐。
4. 保持 `workflow` 现有产品运行链路不受损。

## 必做事项
1. 在 `../workflow/` 下新增：
   - `.codex/`
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - `.codex/MEMORY.md`
   - `.codex/TOOLS.md`
   - `.codex/HEARTBEAT.md`
   - `.codex/memory/`
   - `.codex/skills/`
2. 更新 `../workflow/AGENTS.md`，补齐 OpenClaw 风格读取顺序：
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - 近两天 `.codex/memory/YYYY-MM-DD.md`
   - 主会话额外读取 `.codex/MEMORY.md`
3. 在 `AGENTS.md` 或配套说明中明确区分：
   - `.codex/*` 是 agent 工作记忆与内部文档层
   - `state/*` 是产品运行态与复盘态
   - `logs/*` 是运行与审计留痕
4. 校验当前工作区中所有把 `.codex/skills/` 当成正式入口的代码/文档，在改造后与真实目录一致。
5. 做最小运行回归，确认本轮改造未破坏 `workflow` 启动和关键运行链路。

## 禁止事项
1. 不要修改 `../openclaw`、`../trainer`、`../skill_manager`、`../Analyst` 等其他工作区。
2. 不要把 OpenClaw 记忆层写进 `state/` 或 `logs/` 里冒充产品运行态。
3. 不要因为补 `.codex/` 而重构 `src/`、`scripts/`、`docs/workflow/` 的业务结构。
4. 不要新增第二套技能目录路径，正式口径只认 `.codex/skills/`。

## 交付物
1. `../workflow` 改造后的目录清单。
2. `AGENTS.md` 更新说明。
3. 启动读取验证证据。
4. 每日记忆写入验证证据。
5. 运行回归结果。

## 完成判定
1. `../workflow/.codex/` 存在，且含最小 OpenClaw 核心文档与目录。
2. `../workflow/AGENTS.md` 已具备 OpenClaw 风格读取顺序。
3. `.codex/skills/` 与现有文档/代码口径一致。
4. `workflow` 运行链路未因本轮改造受损。
