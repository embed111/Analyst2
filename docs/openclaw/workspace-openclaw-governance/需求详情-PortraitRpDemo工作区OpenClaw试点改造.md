# 需求详情：PortraitRpDemo 工作区 OpenClaw 试点改造

## 1. 主题目标与价值说明
`../PortraitRpDemo` 当前是一个极简演示型 agent 工作区：顶层仅有 `AGENTS.md` 和少量发布有效性标记文件。其最适合采用“最小补齐”方式接入 OpenClaw 风格记忆层。

## 2. 用户画像与使用场景
1. Owner：希望即使是演示型工作区，也能遵守统一的记忆与目录契约。
2. 演示 agent：需要在不增加复杂度的前提下拥有基础记忆与身份上下文。

## 3. 用户旅程或关键流程
1. 保留当前简洁顶层。
2. 新增 `.codex/` 和记忆层。
3. 在 `AGENTS.md` 中补齐读取顺序。

## 4. 功能需求清单
### FR-PRD-01 顶层保持最小化
1. 顶层继续只保留 `AGENTS.md` 作为 agent 工作文档。
2. `release_valid.txt`、`release_invalid.txt` 作为业务/验证文件保留原位。

### FR-PRD-02 补齐最小 `.codex/`
1. 新增：
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - `.codex/MEMORY.md`
   - `.codex/TOOLS.md`
   - `.codex/HEARTBEAT.md`
   - `.codex/memory/`

### FR-PRD-03 更新 `AGENTS.md`
1. 在保留现有角色画像验收语义的前提下，补齐 OpenClaw 风格读取顺序。
2. 不得削弱现有“发布格式校验”和“预发布判定”的职责边界。

## 5. 非功能需求
1. 最小扰动。
2. 不把 demo 工作区过度复杂化。
3. 仍保持可作为最小样本使用。

## 6. 验收标准
1. Given `../PortraitRpDemo` 完成试点改造
2. When 检查目录与 `AGENTS.md`
3. Then `.codex/` 核心文档已补齐，且 `AGENTS.md` 已包含 OpenClaw 风格读取顺序

## 7. 边界条件与异常处理
1. 若当前阶段不需要本地技能，则不强制新增 `.codex/skills/`。
2. 演示型工作区的长期记忆可保持极简，不要求高频维护。

## 8. 依赖项与开放问题
1. 依赖执行方按最小模板补齐 `.codex/`。
2. 开放问题：后续是否要给该工作区补专用 `TOOLS.md` 内容；本轮不强制。
