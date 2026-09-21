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

Xplace 构建完成后，在仓库根目录中先激活固定环境，再直接运行非实验验收脚本：

```bash
source /home/amirocok/miniforge3/etc/profile.d/conda.sh
conda activate eda-repro
REPO_ROOT="$PWD"
bash "$REPO_ROOT/scripts/check-xplace-build.sh"
```

成功时末行必须精确为 `xplace_non_experiment_checks=pass`。该步骤不运行 `main.py`，不执行实验或 benchmark。

PyTorch 不固定 CUDA 构建。应先记录 `nvidia-smi`、CUDA Toolkit 与 GPU compute capability，再按 DREAMPlace 当前 README 选择兼容组合。本次不执行编译；后续编译需记录 commit、命令、CMake 选项与失败日志。

