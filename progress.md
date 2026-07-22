# 续跑进度

## 2026-07-20

- 已读取用户附带的完整恢复提示词。
- 已确认项目此前不存在 `task_plan.md`、`findings.md`、`progress.md` 或 `.planning`。
- 已创建本次续跑规划文件。
- 已完成阶段 1 恢复检查：提交链正确，无残留下载进程，无未知第三方目录。
- F 盘容量字段在当前 PowerShell 执行环境中未正常返回，已记录为待替代检查项。
- 当前阶段：阶段 2，确认 WSL2/Ubuntu。
- 已运行 Windows 环境检查与 WSL 状态命令；确认新版 WSL 包和发行版尚未安装。
- 已从 Microsoft Learn 核对官方离线安装方向，下一步解析并下载官方稳定版 MSI。
- 已解析官方 API：计划下载并校验 WSL 2.7.10 x64 MSI，随后安装固定版本 Ubuntu 24.04 LTS。
- 已确认 F 盘容量与 x64 架构，创建受 Git ignore 保护的 `third_party/wsl-installer/`。
- WSL MSI 下载在沙箱内和获批联网后均失败；已停止重复重试。
- 已定位 GitHub 被解析到 `127.0.0.1`，当前正在诊断 DNS/网络过滤根因。
- 已用单命令 `--resolve` 安全绕过失效 DNS，WSL MSI 正在 `.partial` 中续传；初始速率约 90–150 KB/s。
- 因下载速率持续下降，已安全停止 curl；无残留 curl 进程，保留 36,777,984 字节 partial 供续传。
- 阶段 2 当前阻塞条件：本机 DNS 将 GitHub 解析到回环地址，且手动单命令绕过后的带宽仍不足；等待用户启用稳定 VPN/代理或修复网络。
- 用户通过 Chrome 完成 WSL 2.7.10 MSI 下载；已验证官方 SHA-256 与 Microsoft 数字签名。
- 可见 MSI 向导安装完成并通过版本、状态、日志验证。阶段 2 继续处理 Ubuntu 24.04。
- Ubuntu `.wsl` 已通过官方 SHA-256 校验。
- 提权注册产生账户作用域偏差；普通 Lenovo 会话仍看不到 Ubuntu。下一步由用户在非管理员 PowerShell 注册，不在管理员身份初始化。
- 用户会话确认 `Ubuntu-24.04` 已注册为 WSL2，并完成 `amirocok` 用户初始化。
- Ubuntu 版本经 `/etc/os-release` 确认为 24.04.4 LTS；下一步仅运行仓库 Linux 环境检查脚本。
- Linux 环境检查已运行并记录可用项与缺失依赖；阶段 2 完成。
- 当前阶段：阶段 3。先验证 WSL 内 GitHub DNS/HTTPS，再决定 Xplace 的官方 clone 路径。
- WSL 网络检查确认 GitHub 被回环解析阻断；下一步测试单命令 `http.curloptResolve`，不修改系统配置。
- 单命令 GitHub 解析覆盖验证成功。
- WSL Git 因 F: DrvFS chmod 限制无法 clone；切换 Windows Git 后 Xplace 主仓库与 pybind11 子模块完整下载并验证。
- 已将 Xplace 在 `tools.csv` 与 `download-status.csv` 更新为 `downloaded`；下一资源为 DREAMPlace。
- Xplace 完成记录已提交为 `7740f64`。
- DREAMPlace 只读 HEAD 查询已出现一次 reset 和一次无输出；下一步做最后一次 HTTP/1.1 最小验证。
- DREAMPlace 第三次 HEAD 测试仍失败；已停止网络尝试并更新 `download-status.csv`，等待稳定 VPN/代理。
- 用户 VPN 未恢复系统 GitHub 连接。执行路线切换到官方 ISPD benchmark，先完成 adaptec2/adaptec4，再申请编译授权以运行 Xplace/adaptec1 最小实验。
- adaptec2 已从官方页面下载，完成 tar 路径检查、SHA-256、解压、六个内部 gzip 完整性与 Git ignore 验证；benchmark 进度 2/3。
- adaptec4 已完成同等级验证；最小 benchmark 目标达到 3/3。下一步需用户授权安装依赖并编译 Xplace，或继续处理 DAC 2012 人工阻塞。

## 2026-07-21 Xplace build baseline

- 已在 `codex/xplace-build` worktree 核对 Xplace `49cf66bc75ba9908f145bb6686f03cde692367cf` 与 pybind11 `83b92ceb3537666fb0188f564e1d53bf8c80b0ba`。
- 已确认 `third_party/Xplace/build/probe` 由 `.gitignore` 的 `/third_party/*/` 规则忽略。
- 已只读记录 Ubuntu/WSL kernel、CPU、内存、磁盘、GPU/driver/VRAM/compute capability 与指定包的 `apt-cache policy`。
- 已知身份边界：沙箱默认身份 `CodexSandboxOffline` 不能直接访问 Lenovo 所有的 Xplace Git/WSL 上下文；本次仅在 Lenovo 上下文执行获批的只读探测，且 Git 仅使用单命令 `safe.directory`，未改动全局配置。
- 未安装任何包，未编译 Xplace，未修改 Xplace 源码，未运行实验；后续项保持 pending。

## 2026-07-21 Xplace system toolchain

- Documentation timestamp: `2026-07-21T15:30:38Z` UTC (recording time, not the package transaction's exact completion second).
- Refreshed Ubuntu 24.04 package indexes from official Ubuntu archive/security repositories.
- Installed the authorized Xplace system dependencies with `apt-get install` and Ubuntu `nvidia-cuda-toolkit` 12.0; the transaction had 30 dependency upgrades and 0 removals, and installed no Linux display-driver metapackage.
- Verified gcc/g++ 13.3, CMake 3.28.3, Ninja 1.11.1, Cairo 1.18.0, Boost 1.83, and nvcc 12.0.
- Verified RTX 4060 driver 560.94 / compute capability 8.9 and successful `sm_89` compilation.
- Did not modify or build Xplace and did not run an experiment.

## 2026-07-22 Xplace Python environment

- Verified the browser-downloaded Miniforge `26.3.2-2` Linux x86_64 installer: `106038245` bytes and SHA-256 `42260ffe3830fb953d5eee1bbb32229ff06aa7c3833c1ed7a9a0420a95685d94`.
- Confirmed `/home/amirocok/miniforge3` was absent immediately before installation, then ran the verified installer offline as `amirocok` with `-b -p /home/amirocok/miniforge3`; no shell initialization was requested.
- A compound WSL verification stalled. After explicit user approval, `wsl.exe --shutdown` returned exit code 0 and Ubuntu restarted successfully; short commands verified Conda 26.3.2, prefix owner/mode `amirocok:amirocok:755`, and base Python 3.13.13.
- Chrome `web-access` succeeded in Lenovo user context (Chrome port 9222, proxy ready).
- Created `eda-repro` from `env/environment.yml`; verified environment Python 3.10.20.
- Installed the pip CUDA build `torch==2.5.1` from the official cu121 index. Verified `torch=2.5.1+cu121`, bundled CUDA 12.1, C++11 ABI false, CUDA available, RTX 4060 Laptop GPU, and capability `(8, 9)` at `2026-07-21T16:39:25Z` UTC.
- Did not build Xplace, modify Xplace source, or run an experiment.

## 2026-07-22 Xplace build completion

- Configure, Ninja build (120/120 with 8 jobs), and install exited 0; logs remain in `Xplace/build/{configure,build,install}.log`.
- Bare `ldd`/direct import exposed the Torch runtime search-path boundary. Preloading `torch` succeeded (`A_OK`); command-local `LD_LIBRARY_PATH` produced an `ldd` result with no `not found` and imported all 12 extensions (`B_ALL_OK 12`). No global shell or Xplace source changed.
- adaptec1/adaptec2/adaptec4 each contain six non-empty Bookshelf files; archive SHA-256 values match `files.sha256` / recovery evidence.
- `scripts/check-xplace-build.sh` exited 0 with `PASS: Xplace build prerequisites are ready`.
- No `main.py`, experiment, or benchmark was run.

## 2026-07-22 Xplace build acceptance check

- TDD red: before implementation, `./scripts/check-xplace-build.sh` exited 1 with `No such file or directory`.
- Added a read-only acceptance check for the pinned Xplace HEAD/clean state, Conda toolchain, RTX 4060 CUDA capability, required CUDA extension imports, and uncompressed adaptec1/adaptec2/adaptec4 Bookshelf files.
- `bash -n scripts/check-xplace-build.sh` exited 0; static search found no `main.py` execution.
- The first WSL run exposed a DrvFS/CRLF false dirty result from Linux Git. The check now requires WSL-visible Windows `git.exe`, with command-local `safe.directory`, so clean validation matches the Windows checkout without changing global configuration.
- Cross-directory red verification exposed a cwd-dependent import result: from the worktree the script failed with `No module named 'cpp_to_py'`, while from Xplace it failed with `No module named 'cpp_to_py.cpybin'`.
- The script now changes to the pinned Xplace checkout before the Python import gate, making imports independent of the caller's cwd.
- Final pre-build runs from both the worktree and `/tmp` exited 1 with the same first error, `ModuleNotFoundError: No module named 'cpp_to_py.cpybin'`. This is the expected pre-build `cpp_to_py` artifact failure: Xplace contains no `cpp_to_py/cpybin` directory and no `.so` or `.pyd` extension artifacts. The later data gate was not reached and was not the cause of either failure.
- Did not build Xplace, prepare data, modify Xplace source, or run an experiment.

## 2026-07-22 Task 6 final acceptance

- Final non-experiment acceptance completed at `2026-07-22T03:19:37Z` UTC.
- `bash -n` passed, static inspection found no `main.py`, and the direct Ubuntu acceptance script exited 0 with exact final line `xplace_non_experiment_checks=pass`.
- The persistent acceptance script verified Python 3.10.20, PyTorch 2.5.1+cu121, CUDA availability on the RTX 4060, pinned clean Xplace and pybind11 checkouts, all 12 explicitly named extension imports, and non-empty adaptec1/adaptec2/adaptec4 data.
- No experiment, benchmark, or `main.py` was run.
