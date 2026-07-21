# 重启后交给 Codex 的续跑提示词

> 使用方法：电脑重启后，在 Codex 中打开 `F:\GAME\复现路径`，将本文件完整内容作为任务提示词发送。不要删除本文件；它同时是恢复清单。

---

你正在继续一个 EDA 布局与可布线性科研复现环境任务。用户已经授权安装依赖并编译 Xplace，但明确不在本阶段运行 placement 实验。请从下述检查点继续，不要从头重建，不要删除或覆盖未知文件。

## 2026-07-22 暂停检查点

### 主仓库与隔离 worktree

- 主仓库：`F:\GAME\复现路径`
- 主仓库分支：`main`
- 主仓库在本提示词更新前的实施基线：`33ee4af chore: ignore local worktrees`；重启后以实际 `git log -2` 为准，不要因提示词提交使 HEAD 更新而回退。
- 隔离 worktree：`F:\GAME\复现路径\.worktrees\xplace-build`
- 实施分支：`codex/xplace-build`
- 实施分支最后完成提交：`ac869edbff69ad7cc17aecdf2126879764ec8e90`
- 不要在 `main` 上继续实施；进入上述 worktree 继续。
- 不要修改全局 `safe.directory`。只在单条命令使用：

```powershell
git -c safe.directory='F:/GAME/复现路径/.worktrees/xplace-build' -C 'F:\GAME\复现路径\.worktrees\xplace-build' status --short --branch
```

### 暂停时必须保留的未提交 Task 4 工作

隔离 worktree 当前有以下已知、预期的未提交文件：

```text
 M progress.md
 M task_plan.md
?? scripts/check-xplace-build.sh
```

这些文件属于正在实施的 Task 4。不要 reset、checkout、clean、删除或覆盖。先查看 diff 和脚本内容，再继续验证与提交。

暂停前 Task 4 的最新证据：

- TDD 红灯：缺失脚本时 exit 1，输出 `./scripts/check-xplace-build.sh: No such file or directory`。
- `bash -n scripts/check-xplace-build.sh` exit 0。
- 脚本静态搜索 `main.py` 匹配数为 0，不运行实验。
- Linux Git 在 DrvFS 上把约 675 个 CRLF 文件误判为修改；脚本已改用 WSL 内的 Windows `git.exe` 检查 F 盘 Xplace HEAD/clean 状态。不要改回 Linux Git，也不要放宽 clean 门禁。
- 为确保 heredoc 传入 Python，Conda 调用已加入 `--no-capture-output`。
- 构建前运行脚本 exit 1，GPU 检查已经通过，首个预期失败为：
  `ModuleNotFoundError: No module named 'cpp_to_py'`
- 该失败准确表示 Xplace CUDA/Python 扩展尚未构建；此前出现的 data-missing 输出是 stdin 未透传造成的假象，`task_plan.md` 应如实记录。
- Task 4 子代理已在提交前被用户要求暂停；没有 Task 4 commit。

## 已完成且不要重做

### WSL、Ubuntu 与 GPU

- WSL `2.7.10.0`，kernel `6.18.33.2-microsoft-standard-WSL2`。
- Ubuntu `24.04.4 LTS`，发行版名 `Ubuntu-24.04`，Linux 用户 `amirocok`。
- GPU：NVIDIA GeForce RTX 4060 Laptop GPU，driver `560.94`，8188 MiB，compute capability `8.9`。
- WSL 有时出现 localhost proxy/NAT 警告；此前不影响只读探测。
- Codex 沙箱账户看不到 Lenovo 用户注册的 WSL；需要 WSL 命令时在普通 Lenovo 用户上下文执行。

### 系统构建工具链

Task 2 已完成并通过规格/质量审查，提交：
`39563e92e4f5d78e974e09c8cca2ed150ad6423e`

已安装并验证：

- GCC/G++ `13.3.0`
- CMake `3.28.3`
- Ninja `1.11.1`
- Cairo `1.18.0`
- Boost `1.83`
- Ubuntu 官方 `nvidia-cuda-toolkit` `12.0.140`
- `nvcc -arch=sm_89` 空编译成功
- APT 事务：402 new、30 dependency upgrades、0 removals；没有执行 `upgrade`/`dist-upgrade` 命令，没有安装 Linux display driver metapackage。

### Miniforge、Conda 与 PyTorch

Task 3 已完成并通过规格/质量审查，提交：
`ac869edbff69ad7cc17aecdf2126879764ec8e90`

- Miniforge `26.3.2`：`/home/amirocok/miniforge3`
- prefix owner/mode：`amirocok:amirocok:755`
- 环境：`eda-repro`
- 精确解释器：`/home/amirocok/miniforge3/envs/eda-repro/bin/python`
- Python `3.10.20`
- PyTorch `2.5.1+cu121`，仅通过官方 pip cu121 index 安装
- PyTorch bundled CUDA `12.1`
- `torch.compiled_with_cxx11_abi()` 为 `False`，Xplace CMake ABI 应为 `0`
- `torch.cuda.is_available()` 为 `True`
- GPU 为 RTX 4060，capability `(8, 9)`
- `conda list` 显示 `torch 2.5.1+cu121 pypi_0 pypi`；没有 Conda/PyPI 混装的 pytorch/torchvision/torchaudio。
- PyTorch 官方兼容证据已记录在 `docs/xplace-build-record.md`。

Miniforge 官方安装器：

- Windows 文件：`C:\Users\Lenovo\Downloads\Miniforge3-26.3.2-2-Linux-x86_64.sh`
- 精确大小：`106038245` bytes
- SHA-256：`42260ffe3830fb953d5eee1bbb32229ff06aa7c3833c1ed7a9a0420a95685d94`
- 已验证与 conda-forge 官方值一致。
- WSL 中仍可能保留早期慢速下载的 `.partial`；不要把它当完成文件，也不要覆盖已安装环境。

### Xplace 源码与数据

- Xplace：`F:\GAME\复现路径\third_party\Xplace`
- remote：`https://github.com/cuhk-eda/Xplace.git`
- branch：`main`
- HEAD：`49cf66bc75ba9908f145bb6686f03cde692367cf`
- pybind11：`83b92ceb3537666fb0188f564e1d53bf8c80b0ba`
- Windows Git 检查工作树为 clean。
- Xplace 尚未配置、编译或安装扩展。
- 不修改 Xplace 源码来规避兼容问题；若编译暴露源码问题，先保留错误证据，再向用户征求授权。

三个 ISPD 2005 benchmark 已从官方来源下载、安全检查、解压并记录 SHA-256：

- adaptec1：`B694DEDFE15BFFA7CB92DFBEE0BC11906F5D334D211F51D82D0AC1EFFB6C0A08`
- adaptec2：`E5A7BC0E343A97F3D9D3A1C871636A4B51DA7F64EE71D2F04E7DB295655A09A2`
- adaptec4：`CA894BCF93ACE5998DD393A6B6D5F240D3C695159CDC62AB055B8EDF70EF46AB`

源 payload 位于 `F:\GAME\复现路径\datasets\ispd2005\payload\`。Xplace 的 `data/raw/ispd2005` 布局尚未准备。

### 其他工具状态

- DREAMPlace：`network-failed`，目标目录不存在；三次只读 HEAD 失败后已停止。
- OpenROAD：`deferred`。
- OpenROAD-flow-scripts：`deferred`。
- DAC 2012：`manual-required`。
- 不要在本轮 Xplace 编译任务中重新下载这些工具。

## 已完成实施提交链

```text
ac869ed docs: record Xplace Python environment
39563e9 docs: record Xplace system toolchain
e145b3a docs: record Xplace build baseline
33ee4af chore: ignore local worktrees
1255f0d docs: plan Xplace build environment
321c060 docs: design Xplace build environment
```

设计与实施计划：

- `docs/superpowers/specs/2026-07-20-xplace-build-environment-design.md`
- `docs/superpowers/plans/2026-07-20-xplace-build-environment.md`

## 重启后的第一组检查

先报告结果，不要修改文件：

```powershell
$root='F:\GAME\复现路径'
$wt="$root\.worktrees\xplace-build"
git -c safe.directory='F:/GAME/复现路径' -C $root status --short --branch
git -c safe.directory='F:/GAME/复现路径/.worktrees/xplace-build' -C $wt status --short --branch
git -c safe.directory='F:/GAME/复现路径/.worktrees/xplace-build' -C $wt diff -- progress.md task_plan.md scripts/check-xplace-build.sh
git -c safe.directory='F:/GAME/复现路径/.worktrees/xplace-build' -C $wt log -6 --oneline
Get-Process git,curl,wsl -ErrorAction SilentlyContinue
wsl.exe --list --verbose
```

然后逐条短命令验证，不要使用容易挂起的超长复合 WSL 命令：

```powershell
wsl.exe -d Ubuntu-24.04 -u amirocok -- /home/amirocok/miniforge3/bin/conda --version
wsl.exe -d Ubuntu-24.04 -u amirocok -- /home/amirocok/miniforge3/bin/conda run -n eda-repro python -c "import torch; print(torch.__version__, torch.version.cuda, torch.cuda.is_available(), torch.cuda.get_device_name(0), torch.cuda.get_device_capability(0))"
```

若 WSL 再次出现命令长期无返回，先检查是否有安装/编译进程；不要直接删除环境。`wsl.exe --shutdown` 会终止所有 WSL 进程，必须再次取得用户授权才能执行。

## 接下来严格执行顺序

### 1. 完成 Task 4，不重写现有脚本

1. 阅读 worktree 中未提交的 `scripts/check-xplace-build.sh`、`progress.md`、`task_plan.md`。
2. 复核脚本使用 Windows `git.exe` 检查 F 盘 Xplace clean/HEAD。
3. 运行 `bash -n` 和静态 `main.py` 检查。
4. 在 Lenovo 用户的 Ubuntu 中运行脚本；构建前应在 GPU 检查通过后因 `cpp_to_py` 扩展未构建而非 0。
5. 确认失败不是 stdin、路径、Git CRLF 或 Conda 捕获问题。
6. 更新记录，`git diff --check`，只 stage 三个 Task 4 文件，提交：
   `test: add Xplace build acceptance check`
7. 按 `subagent-driven-development` 流程完成规格审查，再完成质量审查；有问题由原实施者修复并复审。

### 2. Task 5：编译 Xplace 并准备数据

- 源码目录必须仍 clean、HEAD 固定。
- 若 `build/` 已存在，先检查，不自动删除。
- CMake 关键参数：

```text
-G Ninja
-DCMAKE_BUILD_TYPE=Release
-DCMAKE_CUDA_ARCHITECTURES=89
-DCMAKE_CXX_ABI=0
-DPYTHON_EXECUTABLE=/home/amirocok/miniforge3/envs/eda-repro/bin/python
```

- 并行度最多 8，不使用 `-j40`。
- 保存 `configure.log`、`build.log`、`install.log` 于 ignored build 目录。
- 首个编译错误立即保留证据；未经用户新授权，不修改 Xplace 源码。
- 编译成功后检查 `.so`、`ldd` 无 `not found`、核心扩展可导入。
- 将 adaptec1/2/4 的六个 `.gz` Bookshelf 文件解压复制到 Xplace ignored 的 `data/raw/ispd2005/<design>/`，源 payload 不变；目标存在时不覆盖。
- 不运行 `main.py`、placement、routing、timing 或论文指标实验。
- 完成后更新受控记录、提交并进行规格/质量审查。

### 3. Task 6：最终非实验验收

- 运行 `scripts/check-xplace-build.sh`，预期末行：
  `xplace_non_experiment_checks=pass`
- 更新 `docs/xplace-build-record.md`、`docs/setup-guide.md`、`manifests/download-status.csv`、`progress.md`、`task_plan.md`。
- Xplace 状态只有在构建和非实验验收真实通过后才写 `built`。
- 验证 Xplace 工作树 clean，build/data 生成物被主仓库忽略。
- 最终提交并进行整体代码审查；不要把 deferred/network-failed 资源描述为完成。

## 执行边界

- 用户授权：安装依赖、编译 Xplace、准备数据、进行非实验导入/GPU验收。
- 用户未授权：运行 placement 实验、修改 Xplace 源码、删除未知文件、修改全局 Git/DNS/hosts、安装 Docker/Innovus、重新获取其他大型工具。
- 网络只用官方来源；相同失败三次停止，不使用未知镜像。
- 所有第三方源码、dataset payload、build、结果继续保持 Git ignored。
