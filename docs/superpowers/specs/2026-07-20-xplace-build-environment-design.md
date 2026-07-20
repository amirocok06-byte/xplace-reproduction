# Xplace 构建环境设计

## 目标

在现有 Ubuntu 24.04.4 WSL2 环境中安装 Xplace 所需依赖，构建提交 `49cf66bc75ba9908f145bb6686f03cde692367cf` 的全部 C++/CUDA 扩展，并完成非实验性验收。本阶段不运行 placement，不生成或解读科研实验结果。

## 已确认基础

- WSL `2.7.10.0`，默认版本为 WSL2。
- Ubuntu `24.04.4 LTS`，日常 Linux 用户为 `amirocok`。
- GPU 为 NVIDIA GeForce RTX 4060 Laptop GPU，Windows 驱动 `560.94`，WSL `nvidia-smi` 可用。
- Xplace 官方仓库、`main` 分支和 pybind11 子模块已经完整检出；HEAD 为 `49cf66bc75ba9908f145bb6686f03cde692367cf`。
- adaptec1、adaptec2、adaptec4 已从 ISPD 2005 官方站获取并完成归档及内部 gzip 完整性验证。
- 当前缺少 GCC/G++、CMake、Conda 和 CUDA 编译器 `nvcc`。

## 采用方案

采用“系统编译工具链 + Conda Python/PyTorch 环境”的混合方案。

### 系统层

通过 Ubuntu 包管理器安装构建基础、CMake、Boost、Cairo、Python 开发头和其他由 CMake 实际探测证明必需的开发包。安装 NVIDIA CUDA Toolkit 以提供 `nvcc`、CUDA 头文件和链接库。不得执行无边界的系统升级，也不安装 Docker。

### Conda 层

在 `amirocok` 用户目录安装 Miniforge，创建名为 `eda-repro` 的 Python 3.10 环境。以仓库已有 `env/environment.yml` 为基础安装科研 Python 包，再安装与实际 CUDA Toolkit 兼容的官方 PyTorch 构建。所有 Python 包均进入该环境，不修改 Ubuntu 系统 Python。

### 版本选择

不得预先猜测 CUDA/PyTorch 组合。实施时先记录驱动、可用 Toolkit、Conda 和 Python 版本，再根据 PyTorch 官方兼容矩阵选定组合并写入环境记录。RTX 4060 的编译架构固定为 compute capability 8.9，即 CMake 参数 `CMAKE_CUDA_ARCHITECTURES=89`。

## 源码、构建与数据布局

- 源码保持在 `F:\GAME\复现路径\third_party\Xplace`。
- 构建产物位于 Xplace 的 `build/` 或项目既有安装目录，二者均须被主仓库忽略。
- 不修改 Xplace 源码来规避依赖问题。若现代工具链暴露源码兼容性问题，先保留完整错误证据，再单独征求修改授权。
- adaptec1、adaptec2、adaptec4 放入 Xplace 期望的 ISPD2005 数据布局。优先使用链接以避免重复数据；若 DrvFS/WSL 链接语义不可靠，则复制到已忽略的数据目录并记录来源 SHA-256。
- 不调用 Xplace 自带的全量 benchmark 下载脚本。

## 构建流程

1. 只读探测 Ubuntu、GPU、驱动、磁盘、CPU、内存和现有包状态。
2. 安装系统构建依赖与 CUDA Toolkit，并分别验证 `gcc`、`g++`、`cmake`、`nvcc`。
3. 安装 Miniforge，创建 `eda-repro`，安装仓库环境清单与兼容 PyTorch。
4. 验证 Python、PyTorch、CUDA runtime、CUDA 编译器和 GPU 可见性。
5. 在干净的忽略目录运行 CMake，显式传入 Conda Python 和 `CMAKE_CUDA_ARCHITECTURES=89`。
6. 按硬件资源选择保守并行度进行编译和安装，不使用官方示例中的固定 `-j40`。
7. 验证核心 Python 扩展可以导入，并验证链接库来自预期的 Conda/CUDA 环境。
8. 准备三个已验证 benchmark 的 Xplace 数据布局，但不运行 `main.py`。

## 验收条件

- `gcc`、`g++`、CMake、`nvcc` 版本满足 Xplace 官方最低要求。
- `eda-repro` 使用 Python 3.10，PyTorch 可导入，`torch.cuda.is_available()` 为真且识别 RTX 4060。
- Xplace CMake 配置、编译和安装命令均退出 0。
- Xplace 工作树保持干净；主仓库不跟踪 build、结果、第三方源码或 benchmark payload。
- 至少一个不执行 placement 的核心扩展导入检查成功；不得以仅存在构建文件替代导入验证。
- adaptec1、adaptec2、adaptec4 已进入 Xplace 可识别的数据布局并保持来源可追溯。
- manifests、环境记录和进度文档反映真实版本与状态。

## 错误处理与回滚

- 每次只解决一个已确认的依赖或编译错误，保留失败命令和关键输出。
- 同一失败不得无变化重复三次；第三次失败后停止并重新评估版本组合或构建架构。
- Conda 环境可通过删除单一 `eda-repro` 环境回滚；构建产物可通过清理精确的 Xplace `build/` 目录回滚。
- 系统包与 CUDA Toolkit 不自动卸载。任何系统级回滚须单独确认具体包和影响。
- 不删除用户下载文件、已验证 benchmark 或 Xplace 源码。

## 明确不在本阶段执行

- 不运行 `python main.py` 或任何 placement、routing、timing 实验。
- 不比较 HPWL、拥塞、运行时间或论文指标。
- 不下载 DREAMPlace、OpenROAD 或 OpenROAD-flow-scripts。
- 不安装 Innovus、Docker 或与 Xplace 构建无关的工具。

