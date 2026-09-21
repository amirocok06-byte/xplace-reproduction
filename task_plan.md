# EDA 复现环境续跑计划

## 目标

从 2026-07-20 WSL 重启检查点继续，完成 Xplace 依赖安装、固定源码编译、三个 benchmark 数据准备、非实验验收、manifest/文档更新与最终 Git 验收。DREAMPlace、OpenROAD 和 OpenROAD-flow-scripts 仍保持延后；不运行实验或 benchmark。

## 阶段

- [x] 阶段 1：恢复检查（Git、manifest、磁盘、残留进程与目录）
- [x] 阶段 2：确认并完成 WSL2/Ubuntu，运行环境检查脚本
- [x] 阶段 3：获取、固定并编译验收 Xplace（DREAMPlace、OpenROAD、OpenROAD-flow-scripts 因网络不稳定而延后）
- [x] 阶段 4：获取并安全验证三个 placement benchmark（最小集 3/3 完成；DAC 2012 保持 manual-required）
- [x] 阶段 5：更新 manifests/文档，验证非实验验收、ignore 与 Git 工作树并提交

## 边界与决策

- 官方来源优先；不使用来源不明镜像。
- 一次仅下载一个工具仓库；已有目录先验证，未知内容不删除、不覆盖。
- 下载归档先验证路径安全与完整性，再解压。
- 用户已授权安装 Xplace 构建依赖并编译 Xplace；未授权执行 `main.py`、smoke experiment 或 benchmark。
- 本轮只完成 Xplace；DREAMPlace、OpenROAD 和 OpenROAD-flow-scripts 的获取/构建仍延后。

## 错误记录

| 时间 | 错误 | 处理 |
|---|---|---|
| 2026-07-20 | `Get-ChildItem -Name` 误传多个名称给单值 `Filter`，导致只读规划文件枚举失败 | 改用逐项 `Test-Path`，确认三个规划文件与 `.planning` 均不存在 |
| 2026-07-20 | `Get-PSDrive F` 在当前执行环境中仅返回 `Used=0`、`Free` 空值 | 暂不据此判断容量；下载前改用目标路径/卷的其他只读容量查询 |
| 2026-07-20 | `scripts/check-environment.ps1` 中 WMI/CIM 查询被当前 Codex 普通会话拒绝，CPU 为空且内存/磁盘误报 0 | 记录为脚本权限限制；不把 0 当作真实硬件状态，不因此阻塞 WSL |
| 2026-07-20 | 重启后旧版 `wsl.exe` 仍提示安装；`--status` 退出 50，`--version` 与 `--list --verbose` 退出 1 | 采用微软文档的官方离线 MSI + `.wsl` 安装流程，避开返回 403 的入口 |
| 2026-07-20 | 沙箱拒绝在 `third_party` 下创建 `wsl-installer` 目录 | 经用户授权，以精确路径提权创建；该目录受 `/third_party/*/` ignore 规则保护 |
| 2026-07-20 | 官方 WSL MSI 下载在沙箱内及获批联网后均无法连接 `github.com:443` | 第二次失败后停止重试；诊断发现 `github.com` 被解析为 `127.0.0.1`，转向 DNS 根因排查 |
| 2026-07-20 | 普通会话读取网卡 DNS 地址被 CIM 权限拒绝 | 使用 `nslookup` 对比默认 DNS 与指定公共 DNS；不修改系统 DNS，除非用户批准 |
| 2026-07-20 | 绕过 DNS 后官方 WSL MSI 可下载，但速率持续降至约 40 KB/s，预计单文件仍需近一小时 | 安全停止 curl，保留 `36777984/258605056` 字节 `.partial`；等待用户启用稳定代理/VPN 后用同一 URL 续传 |
| 2026-07-20 | 首次被动 MSI 启动未实际安装且未生成日志 | 改用可见 MSI 向导；用户完成向导后以 `wsl --version`、`--status` 和 MSI 日志三重验证成功 |
| 2026-07-20 | 沙箱内注册 Ubuntu 报 `E_ACCESSDENIED`；提权后命令成功，但普通 Lenovo 会话看不到发行版并报 `WSL_E_DISTRO_NOT_FOUND` | WSL 发行版按 Windows 用户注册；不得在管理员/沙箱身份继续初始化，改由用户在普通非管理员 PowerShell 注册已校验的本地 `.wsl` 文件 |
| 2026-07-20 | 用户普通 PowerShell 再次注册时返回 `ERROR_ALREADY_EXISTS` | 用户的 `wsl --list --verbose` 已显示 `Ubuntu-24.04 Stopped 2`，证明发行版实际已存在；直接首次启动并初始化，不重复安装 |
| 2026-07-20 | Linux 环境脚本在 `cmake`/`nvcc` 缺失后仍调用版本命令，输出两条 `command not found` | 视为脚本诊断噪声；缺失状态已由前置探测明确，不在本阶段安装或修改脚本 |
| 2026-07-20 | WSL 内 `github.com` 同样解析为 `127.0.0.1`，`git ls-remote` 36 ms 内连接本机 443 失败 | 不修改 hosts/DNS/全局 Git；先按 Git 官方 `http.curloptResolve` 使用仅单命令解析覆盖验证 HTTPS |
| 2026-07-20 | WSL Git 在 F 盘 clone 时对 `.git/config.lock` 执行 chmod，DrvFS 返回 `Operation not permitted` 并自动清理目标目录 | 改用 Windows Git + 单命令 DNS 覆盖；避免在 NTFS/DrvFS 上强行使用 Linux Git |
| 2026-07-20 | Codex 沙箱验证 Xplace 时触发 `dubious ownership`，且 Git shell 找不到 `basename/sed` | 沙箱外只读验证，并仅在命令中传入 main/submodule `safe.directory`；不改全局配置 |
| 2026-07-20 | DREAMPlace HEAD 查询使用旧 GitHub IP 时 connection reset；最新 DoH IP 查询无可验证输出 | 第三次最小测试改为最新 IP + 单命令 `http.version=HTTP/1.1`；若仍失败则停止该资源尝试并保留 `network-failed` |
| 2026-07-20 | DREAMPlace 第三次 HEAD 测试使用 HTTP/1.1 仍在 21 秒后 TCP 443 连接失败（exit 128） | 遵循三次失败协议停止该资源及其他 GitHub clone；目标目录不存在，等待用户提供稳定 VPN/代理 |
| 2026-07-20 | 更新 DREAMPlace 记录的首次补丁因现有文本含额外空格而上下文校验失败 | 读取精确行后重新应用；首次失败未产生任何部分修改 |
| 2026-07-20 | 用户 VPN 下系统 Git 仍无法连接 GitHub 443 | 不再依赖 GitHub 完成当前最小目标；转向 ISPD 官方站下载 benchmark，并将 DREAMPlace/OpenROAD/ORFS 延后 |
| 2026-07-20 | 首次写入 Xplace 构建设计文档时，目标 `docs/superpowers/specs` 尚不存在，补丁无法创建文件 | 先精确创建该文档目录，再用补丁写入设计文档；未覆盖任何已有文件 |
| 2026-07-20 | 普通沙箱会话无权在 F 盘目标仓库创建上述目录 | 经用户授权后仅对该精确目录执行提权创建，未扩大写入范围 |
| 2026-07-20 | `rg --files` 在当前 Windows 沙箱中返回“拒绝访问” | 改用 PowerShell `Get-ChildItem` 和 `Select-String` 只读检查仓库及 Xplace 构建文件；未影响文件状态 |
| 2026-07-20 | 首次实施计划补丁有两次格式问题：一处多行新增缺少补丁前缀，一处 JavaScript 模板被 Markdown 反引号截断 | 两次均在写入前失败；改用不含反引号的安全模板生成补丁 |
| 2026-07-20 | 首次创建实施计划文件时 `docs/superpowers/plans` 尚不存在 | 经用户授权精确创建该目录后重新应用补丁；未覆盖已有文件 |

## Task 2 execution notes (2026-07-21)

- Permission boundary: the default sandbox could not access the Lenovo-owned F: worktree/WSL context; approved elevated execution was required.
- `sudo -n true` reported `sudo: a password is required`; the authorized package transaction was run through `wsl.exe -u root` instead.
- The first compound WSL probe failed before any apt action because PowerShell/Bash quoting corrupted `$(...)`; a simplified command without command substitution succeeded.
- No apt network failure occurred: `apt-get update` and the 2550 MB install download completed from official Ubuntu repositories.
- Quality-review inspection could not execute `rg.exe` under the current Windows identity (`Access is denied`); PowerShell `Select-String` supplied the equivalent read-only heading/context check.
- A PowerShell-wrapped attempt to replay the documented Bash `mktemp` probe expanded `$probe_dir` before Bash ran, producing a denied `/xplace-sm89-probe.o` path; this was a host-shell quoting failure, and no file was created. The documented standalone Bash commands retain quoted `$probe_dir` references.

## Task 3 execution notes (2026-07-22)

- Chrome `web-access` checks initially remained disconnected after opening `chrome://inspect/#remote-debugging` because they ran under the sandbox identity; network-dependent environment creation was held until the identity boundary was diagnosed.
- The offline Miniforge installer completed extraction and created the expected prefix files. The first immediate verification raced with WSL startup/filesystem state and reported `bin/conda` missing; a later inspection showed `bin/conda`, `bin/python`, and `conda-meta/history` present with `amirocok` ownership and no installer process.
- A subsequent compound read-only WSL verification stalled and was terminated without deleting the prefix or rerunning the installer. After explicit user approval, `wsl.exe --shutdown` returned exit code 0; Ubuntu restarted successfully, and independent short commands verified Conda 26.3.2, base Python 3.13.13, prefix ownership `amirocok:amirocok:755`, and that only the base environment existed before environment creation.
- Chrome checks failed under the sandbox identity but succeeded under the required Lenovo identity (exit 0, Chrome port 9222, proxy ready); this confirmed an identity-boundary issue rather than a missing Chrome checkbox.
- `eda-repro` creation and the official PyTorch cu121 pip installation subsequently completed successfully; no remaining Task 3 error is open.

## Task 4 execution notes (2026-07-22)

- TDD red was observed before implementation: the acceptance script path returned `No such file or directory` (exit 1).
- The initial Linux Git clean check reported the entire Windows checkout dirty because DrvFS exposed line-ending differences. `core.fileMode=false` did not address CRLF differences. Resolution: use WSL-visible Windows `git.exe` for pinned HEAD and clean checks, retain command-local `safe.directory`, and fail explicitly if `git.exe` is unavailable.
- Syntax validation passed (`bash -n`, exit 0), and the script contains no `main.py` invocation.
- Cross-directory red verification showed that the import gate depended on caller cwd: it failed at `cpp_to_py` from the worktree and at `cpp_to_py.cpybin` from Xplace.
- The script now changes to the pinned Xplace checkout before importing. Final runs from both the worktree and `/tmp` exited 1 with the same first error, `ModuleNotFoundError: No module named 'cpp_to_py.cpybin'`. This is the expected pre-build `cpp_to_py` artifact failure; no `cpybin`, `.so`, or `.pyd` artifact exists. The later data gate was not reached and was not the cause of either failure.
- No Xplace build, data preparation, or experiment execution was performed.

## Task 5 completion (2026-07-22) — canonical status

- [x] Configure, build, and install pinned Xplace with CUDA architecture 89 and ABI0.
- [x] Prepare non-overwriting adaptec1/adaptec2/adaptec4 Bookshelf data and verify archive hashes.
- [x] Pass the controlled non-experiment acceptance script and record runtime-loader diagnostics.
- [x] Preserve Xplace source and avoid `main.py`/experiment execution.

## Task 6 completion (2026-07-22) — canonical status

- [x] Pass final direct Ubuntu non-experiment acceptance with exact final line `xplace_non_experiment_checks=pass`.
- [x] Verify Python/PyTorch/GPU, clean pinned Xplace/pybind11, all 12 build artifacts, and three prepared datasets.
- [x] Record final UTC, setup command, and built manifest state.
- [x] Verify ignore rules and repository cleanliness without running `main.py` or an experiment.
