# WSL2/Ubuntu 环境准备指南

推荐分层：Windows 负责 WSL2、NVIDIA 驱动和可选 Docker Desktop；Ubuntu 负责编译器、CMake、Boost、Eigen、Conda 与可选 CUDA Toolkit。先运行 Windows 与 WSL2 环境检查脚本，再创建 Conda 分析环境。

```powershell
powershell -ExecutionPolicy Bypass -File scripts/check-environment.ps1
```

```bash
bash scripts/check-environment.sh
conda env create -f env/environment.yml
conda activate eda-repro
```

PyTorch 不固定 CUDA 构建。应先记录 `nvidia-smi`、CUDA Toolkit 与 GPU compute capability，再按 DREAMPlace 当前 README 选择兼容组合。本次不执行编译；后续编译需记录 commit、命令、CMake 选项与失败日志。

