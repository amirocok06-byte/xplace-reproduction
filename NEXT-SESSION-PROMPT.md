# 重启后交给 Codex 的续跑提示词

> 使用方法：电脑重启后，在 Codex 中打开 `F:\GAME\复现路径`，将本文件完整内容作为任务提示词发送。不要删除本文件；它同时是恢复清单。

---

你正在继续一个 EDA 布局与可布线性科研复现环境准备任务。请直接检查本地状态并继续执行，不要从头重建，不要覆盖已有文件。

## 工作目录与 Git

- 目标仓库：`F:\GAME\复现路径`
- 分支：`main`
- 预期当前提交：`a3ec03e4cd0d85e7fa02258885a9ebec67a61ecf`
- 仓库本地身份：`amirocok <amirocok06@gmail.com>`
- 当前仓库在 Windows 账户之间读取时可能触发 Git `dubious ownership`。优先在普通用户终端运行；Codex 沙箱只在单条命令中使用：

```powershell
git -c safe.directory='F:/GAME/复现路径' -C 'F:\GAME\复现路径' status --short --branch
```

不要修改全局 `safe.directory`，除非用户明确批准。

## 已完成且不要重做

- 桌面实际路径由系统解析为 `F:\GAME`，仓库已初始化并有两个提交。
- 论文已复制到 `papers/2228360.2228500.pdf`，SHA-256：
  `FA403584FE1E5C30E9B729683345FB867B5A53FB2747DB0C7F1968B3FD736F5D`
- ISPD 2005 `adaptec1.tar.gz` 已从官方竞赛页下载并安全解压到：
  `datasets\ispd2005\payload\adaptec1\`
- adaptec1 归档 SHA-256：
  `B694DEDFE15BFFA7CB92DFBEE0BC11906F5D334D211F51D82D0AC1EFFB6C0A08`
- 文档、Conda/pip 清单、环境检查脚本、实验 CSV、论文指标笔记、`.gitignore` 和 manifests 已建立。
- 统一实验表有 45 个唯一字段；不要因旧计划中写了“46”而添加无意义列。
- 已核实官方工具 HEAD（2026-07-19）：
  - DREAMPlace：`6627f3327e6cc17db7782c0b90073a498531ca3c`
  - OpenROAD：`566a2df7ea55bb44c530ff0944b9f4b69b306a23`
  - OpenROAD-flow-scripts：`f255c15b3dd4362a704b6af9f617b4091bdd4e6a`
  - Xplace：`49cf66bc75ba9908f145bb6686f03cde692367cf`
- Xplace 正确官方仓库是 `https://github.com/cuhk-eda/Xplace.git`，不是 `limbo018/Xplace`。
- 上次最终验收：必需文件 0 缺失、Git 工作树干净、无活动 curl、无残留损坏 ZIP。

## 上次中断原因

网络持续只有约 5–30 KB/s。`git clone` DREAMPlace 遇到 connection reset；GitHub codeload 不支持断点续传，DREAMPlace 与 Xplace 源码 ZIP 都在下载十几 MB 后断线并从零开始。损坏临时包已经删除，不要尝试解压不存在或未通过 CRC 的 ZIP。

状态详情见：

- `manifests/download-status.csv`
- `manifests/tools.csv`
- `manifests/files.sha256`

## 本次续跑的执行顺序

### 1. 恢复检查

先运行以下只读检查并报告结果：

```powershell
$root='F:\GAME\复现路径'
git -c safe.directory='F:/GAME/复现路径' -C $root status --short --branch
git -c safe.directory='F:/GAME/复现路径' -C $root log -2 --oneline
Get-Content "$root\manifests\download-status.csv"
Get-PSDrive -Name F | Select-Object Used,Free
Get-Process git,curl -ErrorAction SilentlyContinue
```

若工作树出现未知修改、下载进程仍在运行或目标目录已含非 Git 文件，不要删除或覆盖；先向用户说明。

### 2. 优先完成 WSL2 安装

上次检测到 `wsl.exe` 存在，但 `wsl --status` 返回安装提示；Docker 未安装。先运行：

```powershell
powershell -ExecutionPolicy Bypass -File 'F:\GAME\复现路径\scripts\check-environment.ps1'
```

若 WSL2 尚未安装，向用户申请管理员授权后执行 Windows 官方安装流程。WSL2 安装可能再次要求重启；若要求重启，先更新本文件或新增进度记录并提交，再停止。

### 3. 在稳定网络下逐个下载工具

一次只处理一个仓库，顺序：Xplace → DREAMPlace → OpenROAD → OpenROAD-flow-scripts。优先使用官方 Git clone，因为它能记录 commit 和子模块：

```powershell
git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/cuhk-eda/Xplace.git 'F:\GAME\复现路径\third_party\Xplace'
git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/limbo018/DREAMPlace.git 'F:\GAME\复现路径\third_party\DREAMPlace'
git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/The-OpenROAD-Project/OpenROAD.git 'F:\GAME\复现路径\third_party\OpenROAD'
git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git 'F:\GAME\复现路径\third_party\OpenROAD-flow-scripts'
```

规则：

- 若目录已存在，先验证 `.git`、`remote.origin.url`、HEAD 和工作树；不要覆盖。
- 若 clone 失败且只留下空的 `.git` 半成品，精确核验后才可删除该单一目录。
- 不使用来源不明的镜像。
- 不再用 codeload ZIP 反复从零下载，除非网络已稳定且能完成 CRC 校验。
- 每完成一个仓库就立即记录 remote、HEAD、branch、submodule status 与磁盘占用。

### 4. 补齐 benchmark

先完成科研计划前两周所需的三个小 benchmark。adaptec1 已存在，因此再从官方竞赛页选择两个较小设计，推荐 adaptec2、adaptec4；若需要 ISPD 2006 趋势，再补 adaptec5。

官方入口：

- ISPD 2005：https://www.ispd.cc/contests/05/contest.htm
- ISPD 2006：https://www.ispd.cc/contests/06/contest.html
- DAC 2012：http://archive.sigda.org/dac2012/contest/dac2012_contest.html

下载必须使用 `.partial` 临时名或下载工具的完整性机制；下载后先列出 tar 内容，拒绝绝对路径和 `..` traversal，再解压、计算 SHA-256 并更新 manifest。DAC 2012 官方归档上次超时；若仍不可达，保留 `manual-required`，不要使用不明镜像。获取后必须验证 `.route` 与 `.shapes`。

### 5. 环境准备边界

本阶段继续遵循“下载源码、数据、环境清单和脚本，不编译安装工具”。WSL2/Ubuntu 安装完成后，只运行 `scripts/check-environment.sh` 并记录缺失依赖；不要直接开始长时间编译，除非用户再次授权。

### 6. 更新记录并提交

每个资源完成后更新：

- `manifests/tools.csv`
- `manifests/download-status.csv`
- `manifests/files.sha256`
- 必要时更新 `docs/setup-guide.md` 和 dataset README

第三方源码、dataset payload、build 和 results 必须保持 Git ignored。提交前运行：

```powershell
git -c safe.directory='F:/GAME/复现路径' -C 'F:\GAME\复现路径' status --short
git -c safe.directory='F:/GAME/复现路径' -C 'F:\GAME\复现路径' check-ignore -v third_party/Xplace/README.md
git -c safe.directory='F:/GAME/复现路径' -C 'F:\GAME\复现路径' check-ignore -v datasets/ispd2005/payload/adaptec1.tar.gz
```

只提交受控的文档、脚本和 manifests。最终报告每个工具/数据集的 `downloaded`、`manual-required` 或 `network-failed` 状态，不把未完成下载描述为成功。

## 本次续跑验收条件

- WSL2 状态明确；若安装完成，记录 Ubuntu 版本。
- 至少 Xplace 与 DREAMPlace 两个源码仓库完整，HEAD 与 manifest 一致；理想状态是四个工具均完整。
- 至少三个小 placement benchmark 完整、可列包、已解压且有 SHA-256。
- DAC 2012 已获得且含 `.route/.shapes`，或有可验证的人工下载阻塞说明。
- Git 工作树干净，第三方与数据大文件未被主仓库跟踪。

