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
