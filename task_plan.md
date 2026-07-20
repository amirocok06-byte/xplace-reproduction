# EDA 复现环境续跑计划

## 目标

从 2026-07-20 WSL 重启检查点继续，完成 WSL2/Ubuntu 状态确认、官方工具源码和 benchmark 获取、manifest 更新与最终 Git 验收；不编译 EDA 工具，不覆盖未知文件。

## 阶段

- [x] 阶段 1：恢复检查（Git、manifest、磁盘、残留进程与目录）
- [ ] 阶段 2：确认并完成 WSL2/Ubuntu，运行环境检查脚本（网络阻塞，等待稳定代理/DNS 后续传）
- [ ] 阶段 3：逐个获取并验证 Xplace、DREAMPlace、OpenROAD、OpenROAD-flow-scripts
- [ ] 阶段 4：获取并安全验证至少三个 placement benchmark，核实 DAC 2012 状态
- [ ] 阶段 5：更新 manifests/文档，验证 ignore 与 Git 工作树并提交

## 边界与决策

- 官方来源优先；不使用来源不明镜像。
- 一次仅下载一个工具仓库；已有目录先验证，未知内容不删除、不覆盖。
- 下载归档先验证路径安全与完整性，再解压。
- 本阶段不编译或安装 EDA 工具。

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
