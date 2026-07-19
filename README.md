# EDA 布局与可布线性复现路径

本仓库执行 8 周科研训练路线：建立 DREAMPlace 基线、接入 OpenROAD 全局布线、训练拥塞预测器，并开展基于拥塞图的 cell inflation/spreading 实验。

## 仓库边界

- Git 跟踪文档、环境清单、脚本、配置说明、实验表、资源版本与校验清单。
- Git 不跟踪 `third_party/` 源码、`datasets/*/payload/` 大型数据、构建产物和 `results/` 输出。
- 本阶段只下载与准备，不编译或安装 DREAMPlace、OpenROAD、Xplace、CUDA 和 WSL2。

## 快速开始

```powershell
powershell -ExecutionPolicy Bypass -File scripts/check-environment.ps1
powershell -ExecutionPolicy Bypass -File scripts/fetch-resources.ps1 -WhatIf
powershell -ExecutionPolicy Bypass -File scripts/fetch-resources.ps1 -ToolsOnly
powershell -ExecutionPolicy Bypass -File scripts/write-resource-manifest.ps1
```

WSL2 中运行 `bash scripts/check-environment.sh`，再用 `conda env create -f env/environment.yml` 创建分析环境。

实验必须使用相同 benchmark 和 config，至少重复三次，记录随机种子，并同时报告 HPWL、density overflow、routing congestion 与 runtime。

