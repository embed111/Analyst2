# 执行提示词：trainer 工作区 OpenClaw 试点改造

请按照文件 **`docs/openclaw/workspace-openclaw-governance/需求详情-trainer工作区OpenClaw试点改造.md`** 和 **`docs/openclaw/workspace-openclaw-governance/需求详情-OpenClaw工作区能力基线.md`** 中的要求执行，目标只限定为 `../trainer` 工作区，不要扩散到其他目录。

## 本轮目标
1. 为 `../trainer` 新增 `.codex/` 记忆层。
2. 保持 `.training/` 训练运行目录不变。
3. 让 `trainer` 同时具备：
   - OpenClaw 风格记忆能力；
   - 原有训练流程与约束。

## 必做事项
1. 在 `../trainer/` 下新增：
   - `.codex/`
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - `.codex/MEMORY.md`
   - `.codex/TOOLS.md`
   - `.codex/HEARTBEAT.md`
   - `.codex/memory/`
2. 更新 `../trainer/AGENTS.md`：
   - 保留原有训练角色、约束、流程与摘要读取规则
   - 补齐 OpenClaw 风格读取顺序
   - 明确 `.training/` 与 `.codex/` 的职责边界
3. 验证每日记忆与长期记忆路径可用。
4. 做最小训练链路回归，证明本轮改造未破坏现有训练闭环。

## 禁止事项
1. 不要重构 `.training/` 内部目录。
2. 不要把训练运行日志直接写进 `.codex/MEMORY.md`。
3. 不要修改 `../workflow`、`../openclaw`、`../skill_manager` 等其他工作区。

## 交付物
1. `../trainer` 改造后的目录清单。
2. `AGENTS.md` 更新说明。
3. 记忆读写验证证据。
4. 最小训练链路回归结果。

## 完成判定
1. `../trainer/.codex/` 存在，且含最小 OpenClaw 核心文档与 `memory/`。
2. `../trainer/AGENTS.md` 已兼容 OpenClaw 记忆读取顺序与原有训练读取顺序。
3. `.training/` 训练运行链路未受损。
