# 8 周执行计划

## 第 1–2 周：DREAMPlace 基线

- 选择 ISPD 2005/2006 三个较小设计，固定配置和随机种子并重复三次。
- 保存 HPWL、density overflow、runtime 与 HPWL-iteration 曲线。

## 第 3–4 周：可布线性评价

- 将 placement 结果接入 OpenROAD global routing。
- 保存 TOF、MOF、ACE、routing report 和 congestion heatmap，并核对 legalization。

## 第 5–6 周：简化拥塞预测器

- 特征从 cell density、pin density、RUDY demand 开始。
- 先实现 CNN baseline，再评估 GNN；预测图与 global-routing 真值图使用同一网格。

## 第 7–8 周：小创新实验

- 在高拥塞区域执行 cell inflation 或局部 spreading。
- 重新 placement/legalization 和 global routing，比较 HPWL、overflow、congestion、runtime 与位移。

原始日志放在 `results/<date>/<benchmark>/<run-id>/`，汇总使用 `experiments/experiment-template.csv`。

