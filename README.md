# EDA 布局与可布线性复现路径

建立 DREAMPlace 基线、接入 OpenROAD 全局布线、训练拥塞预测器，并开展基于拥塞图的 cell inflation/spreading 实验。



## 快速开始

```powershell
powershell -ExecutionPolicy Bypass -File scripts/check-environment.ps1
powershell -ExecutionPolicy Bypass -File scripts/fetch-resources.ps1 -WhatIf
powershell -ExecutionPolicy Bypass -File scripts/fetch-resources.ps1 -ToolsOnly
powershell -ExecutionPolicy Bypass -File scripts/write-resource-manifest.ps1
```

WSL2 中运行 `bash scripts/check-environment.sh`，再用 `conda env create -f env/environment.yml` 创建分析环境。

实验必须使用相同 benchmark 和 config，至少重复三次，记录随机种子，并同时报告 HPWL、density overflow、routing congestion 与 runtime。

