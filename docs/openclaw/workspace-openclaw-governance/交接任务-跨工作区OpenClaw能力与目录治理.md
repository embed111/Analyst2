# 交接任务：跨工作区 OpenClaw 能力与目录治理

## 1. 任务目标
请对 `../` 下 9 个一级目录执行统一治理，使所有 agent 工作区具备 OpenClaw 风格的记忆能力与基础工作区能力，同时满足以下目录约束：

1. 顶层只保留 `AGENTS.md` 这一份 agent 工作文档。
2. `SOUL.md`、`MEMORY.md`、`USER.md`、`TOOLS.md`、`HEARTBEAT.md`、`IDENTITY.md`、`BOOTSTRAP.md` 等 agent 工作文档统一迁入 `.codex/`。
3. 属于 agent 内部资产的 `memory/`、`skills/`、`tasks/` 等目录应优先迁入 `.codex/`。
4. 迁移后必须修复读取顺序和旧路径引用，不能只移动文件。

## 2. 本轮范围
### 目录清单
1. `../.codex`
2. `../agent_gen`
3. `../Analyst`
4. `../Analyst2`
5. `../openclaw`
6. `../PortraitRpDemo`
7. `../skill_manager`
8. `../trainer`
9. `../workflow`

### 已知现状
1. 当前已有 `AGENTS.md` 的目录有 8 个：`agent_gen`、`Analyst`、`Analyst2`、`openclaw`、`PortraitRpDemo`、`skill_manager`、`trainer`、`workflow`。
2. 当前只有 `openclaw` 在顶层暴露了完整一组 agent 工作文档：
   - `SOUL.md`
   - `MEMORY.md`
   - `IDENTITY.md`
   - `USER.md`
   - `TOOLS.md`
   - `HEARTBEAT.md`
   - `BOOTSTRAP.md`
3. 当前已有 `.codex/` 的目录主要有：`Analyst`、`Analyst2`、`openclaw`、`skill_manager`。
4. 当前仅 `openclaw` 已有顶层 `memory/` 目录。

## 3. 必做事项
1. 逐目录判定目标状态：
   - agent 工作区；
   - 共享支撑目录；
   - 过渡态目录。
2. 对 agent 工作区补齐最小 OpenClaw 能力基线：
   - 顶层 `AGENTS.md`
   - `.codex/SOUL.md`
   - `.codex/USER.md`
   - `.codex/MEMORY.md`
   - `.codex/TOOLS.md`
   - `.codex/HEARTBEAT.md`
   - `.codex/memory/`
   - `.codex/skills/`（如工作区支持本地技能）
3. 对顶层 agent 工作文档执行迁移：
   - 顶层只保留 `AGENTS.md`
   - 其他 agent 工作文档迁入 `.codex/`
4. 对 agent 内部资产执行收口：
   - `memory/ -> .codex/memory/`
   - `skills/ -> .codex/skills/`
   - `tasks/ -> .codex/tasks/`（若其确属 agent 内部任务目录）
5. 修复所有旧路径引用：
   - `AGENTS.md`
   - 启动脚本
   - 技能说明
   - 治理文档
   - 其他读取链路说明

## 4. 重点样本要求
### `../openclaw`
1. 该目录当前能力最完整，但目录最不符合新治理目标。
2. 必须把它处理成“能力完整 + 顶层收口”的标准样本。
3. 改造后应能证明：
   - 主会话可读取 `.codex/MEMORY.md`
   - 每日记忆从 `.codex/memory/` 读取与写入
   - 顶层 agent 工作文档仅剩 `AGENTS.md`

### 无 `.codex/` 的工作区
1. 必须先补齐 `.codex/` 结构，再迁移文档或接通记忆能力。
2. 不允许出现“顶层文档删掉了，但 `.codex/` 能力未补齐”的中间态。

## 5. 产出物要求
1. 逐目录迁移清单：
   - 当前状态
   - 目标状态
   - 文件/目录映射
   - 例外说明
2. 路径修复清单：
   - 哪些文件改了引用
   - 改前路径
   - 改后路径
3. 验收证据：
   - 每个 agent 工作区至少 1 组启动读取证据
   - 每个 agent 工作区至少 1 组记忆写入证据
   - 至少 1 组全局旧路径清零检索结果

## 6. 禁止事项
1. 不得只移动文件，不修启动链路。
2. 不得把普通项目文档误当成 agent 工作文档整体迁走。
3. 不得直接删除历史事实而不留迁移记录。
4. 不得把“顶层清空”误当成完成，真正完成标准是“`.codex` 能力接通 + 路径引用修复 + 验收通过”。

## 7. 验收口径
1. 目录验收：
   - agent 工作区顶层仅保留 `AGENTS.md` 作为 agent 工作文档。
2. 能力验收：
   - 主会话可加载 `.codex/MEMORY.md`
   - 默认会读取 `.codex/SOUL.md`、`.codex/USER.md`、近两天 `.codex/memory/*.md`
3. 路径验收：
   - 纳入范围的 `AGENTS.md`、脚本、技能文档中无旧顶层 agent 工作文档路径残留。
4. 治理验收：
   - 9 个目录全部有明确目标状态和迁移结果。

## 8. 参考文档
1. [需求概述.md](./需求概述.md)
2. [需求详情-OpenClaw工作区能力基线.md](./需求详情-OpenClaw工作区能力基线.md)
3. [需求详情-Agent工作文档归档与目录迁移验收.md](./需求详情-Agent工作文档归档与目录迁移验收.md)
