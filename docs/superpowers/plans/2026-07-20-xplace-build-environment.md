# Xplace Build Environment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (- [ ]) syntax for tracking.

**Goal:** 在 Ubuntu 24.04.4 WSL2 中建立隔离的 eda-repro Python/CUDA 环境，编译固定提交的 Xplace，并在不运行 placement 的前提下验证 GPU 与核心扩展。

**Architecture:** Ubuntu 系统层承载编译器、CMake、Boost、Cairo 与 CUDA Toolkit；Miniforge 的 eda-repro 环境承载 Python 3.10、科学包和官方 CUDA PyTorch。Xplace 源码保持不变，产物留在已忽略目录，可重复验收逻辑放入主仓库脚本。

**Tech Stack:** WSL2, Ubuntu 24.04.4, APT, CUDA Toolkit, Miniforge, Python 3.10, PyTorch, CMake, GCC, Bash, Git

---

## 文件结构

- Create: scripts/check-xplace-build.sh — 非实验验收。
- Create: docs/xplace-build-record.md — 实际版本、命令与结果。
- Modify: docs/setup-guide.md, manifests/download-status.csv, progress.md, task_plan.md。
- Generated/ignored: third_party/Xplace/build, cpp_to_py/cpybin/*.so, data/raw/ispd2005。

### Task 1: 冻结基线

**Files:** Create docs/xplace-build-record.md; Modify progress.md

- [ ] **Step 1: 验证工作树和 ignore**

~~~powershell
git -c safe.directory='F:/GAME/复现路径' -C 'F:\GAME\复现路径' status --short --branch
git -c safe.directory='F:/GAME/复现路径/third_party/Xplace' -C 'F:\GAME\复现路径\third_party\Xplace' status --short --branch
git -c safe.directory='F:/GAME/复现路径' -C 'F:\GAME\复现路径' check-ignore -v third_party/Xplace/build/probe
~~~

Expected: Xplace main clean；build 命中 ignore。未知改动则停止。

- [ ] **Step 2: 探测硬件和候选版本**

~~~powershell
wsl.exe -d Ubuntu-24.04 -- bash -lc '. /etc/os-release; echo "$PRETTY_NAME"; uname -r; nproc; free -h; df -h / /mnt/f; /usr/lib/wsl/lib/nvidia-smi --query-gpu=name,driver_version,memory.total,compute_cap --format=csv,noheader; apt-cache policy cmake gcc g++ libboost-all-dev libcairo2-dev nvidia-cuda-toolkit'
~~~

Expected: Ubuntu 24.04.4、RTX 4060、driver 560.94、capability 8.9、F 盘可见。

- [ ] **Step 3: 创建记录**

docs/xplace-build-record.md 必须包含固定 Xplace HEAD 49cf66bc75ba9908f145bb6686f03cde692367cf、pybind11 83b92ceb3537666fb0188f564e1d53bf8c80b0ba、探测输出，以及 System dependencies、Conda/PyTorch、Build、Non-experiment acceptance 四节；未知项写 pending。

- [ ] **Step 4: 提交**

~~~powershell
git -c safe.directory='F:/GAME/复现路径' -C 'F:\GAME\复现路径' add docs/xplace-build-record.md progress.md
git -c safe.directory='F:/GAME/复现路径' -C 'F:\GAME\复现路径' commit -m "docs: record Xplace build baseline"
~~~

### Task 2: 安装系统工具链和 CUDA

**Files:** Modify docs/xplace-build-record.md, progress.md, task_plan.md

- [ ] **Step 1: 安装基础包**

~~~bash
sudo apt-get update
sudo apt-get install -y build-essential cmake ninja-build pkg-config libboost-all-dev libcairo2-dev python3-dev flex bison zlib1g-dev
~~~

Expected: exit 0，无 removals；禁止 upgrade/dist-upgrade。

- [ ] **Step 2: 验证版本**

~~~bash
gcc --version | head -n 1
g++ --version | head -n 1
cmake --version | head -n 1
pkg-config --modversion cairo
dpkg-query -W libboost-all-dev libcairo2-dev
~~~

Expected: GCC/G++ >= 7.5，CMake >= 3.24。

- [ ] **Step 3: 选择并安装 CUDA**

~~~bash
apt-cache policy nvidia-cuda-toolkit
/usr/lib/wsl/lib/nvidia-smi
~~~

仅安装 CUDA >= 11.3 且 driver 560.94 支持的版本。优先 sudo apt-get install -y nvidia-cuda-toolkit；若候选不满足，采用 NVIDIA 当前官方 WSL-Ubuntu keyring 和 cuda-toolkit-X-Y 包，先记录 URL、keyring SHA-256、包名。禁止安装 Linux display driver。

- [ ] **Step 4: 验证并提交记录**

~~~bash
nvcc --version
/usr/lib/wsl/lib/nvidia-smi --query-gpu=name,driver_version,compute_cap --format=csv,noheader
~~~

Expected: nvcc >= 11.3，GPU/capability 不变。写入真实版本和 UTC，提交受控记录，失败写 task_plan.md。

### Task 3: 建立 Conda/PyTorch 环境

**Files:** Modify docs/xplace-build-record.md, progress.md, task_plan.md

- [ ] **Step 1: 下载校验 Miniforge**

~~~bash
mkdir -p "$HOME/Downloads/eda-repro-bootstrap"
curl -fL --retry 3 --retry-delay 5 -o "$HOME/Downloads/eda-repro-bootstrap/Miniforge3-Linux-x86_64.sh.partial" https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
mv "$HOME/Downloads/eda-repro-bootstrap/Miniforge3-Linux-x86_64.sh.partial" "$HOME/Downloads/eda-repro-bootstrap/Miniforge3-Linux-x86_64.sh"
sha256sum "$HOME/Downloads/eda-repro-bootstrap/Miniforge3-Linux-x86_64.sh"
~~~

Expected: 完整文件和 SHA-256；同一网络错误三次后停止，不用未知镜像。

- [ ] **Step 2: 安装并创建环境**

~~~bash
bash "$HOME/Downloads/eda-repro-bootstrap/Miniforge3-Linux-x86_64.sh" -b -p "$HOME/miniforge3"
"$HOME/miniforge3/bin/conda" env create -f '/mnt/f/GAME/复现路径/env/environment.yml'
"$HOME/miniforge3/bin/conda" run -n eda-repro python --version
~~~

Expected: Python 3.10.x；已有环境只检查，不覆盖。

- [ ] **Step 3: 安装官方 CUDA PyTorch**

根据当前 PyTorch 官方矩阵，记录版本、官方 channel/index、bundled CUDA 与 URL。选择 driver 560.94 支持且能与 Toolkit 编译的 CUDA build；禁止 CPU-only。只运行 selector 给出的一种命令，不混用 Conda/pip。

- [ ] **Step 4: GPU/ABI 验证**

~~~bash
"$HOME/miniforge3/bin/conda" run -n eda-repro python -c 'import torch; print(torch.__version__, torch.version.cuda, torch.compiled_with_cxx11_abi()); print(torch.cuda.is_available(), torch.cuda.get_device_name(0), torch.cuda.get_device_capability(0))'
~~~

Expected: True、RTX 4060、(8, 9)；记录 CXX ABI 0/1 并提交受控记录。

### Task 4: 创建非实验验收脚本

**Files:** Create scripts/check-xplace-build.sh

- [ ] **Step 1: 先确认缺失**

~~~bash
bash '/mnt/f/GAME/复现路径/scripts/check-xplace-build.sh'
~~~

Expected: No such file or directory。

- [ ] **Step 2: 写脚本**

~~~bash
#!/usr/bin/env bash
set -euo pipefail
repo='/mnt/f/GAME/复现路径'
xplace="$repo/third_party/Xplace"
conda_bin="$HOME/miniforge3/bin/conda"
test "$(git -C "$xplace" rev-parse HEAD)" = '49cf66bc75ba9908f145bb6686f03cde692367cf'
test -z "$(git -C "$xplace" status --porcelain)"
gcc --version | head -n 1
cmake --version | head -n 1
nvcc --version | tail -n 1
cd "$xplace"
"$conda_bin" run -n eda-repro python - <<'PY'
import importlib, pathlib, torch
assert torch.cuda.is_available()
assert torch.cuda.get_device_capability(0) == (8, 9)
assert 'RTX 4060' in torch.cuda.get_device_name(0)
for name in ('dct_cuda', 'density_map_cuda', 'hpwl_cuda'):
    importlib.import_module(f'cpp_to_py.cpybin.{name}')
root = pathlib.Path('/mnt/f/GAME/复现路径/third_party/Xplace/data/raw/ispd2005')
for design in ('adaptec1', 'adaptec2', 'adaptec4'):
    for suffix in ('aux', 'nets', 'nodes', 'pl', 'scl', 'wts'):
        assert (root / design / f'{design}.{suffix}').is_file()
print('xplace_non_experiment_checks=pass')
PY
~~~

- [ ] **Step 3: 构建前验证失败并提交**

运行脚本，Expected: GPU 通过后因扩展或数据缺失失败；确认未调用 main.py。提交：

~~~powershell
git -c safe.directory='F:/GAME/复现路径' -C 'F:\GAME\复现路径' add scripts/check-xplace-build.sh
git -c safe.directory='F:/GAME/复现路径' -C 'F:\GAME\复现路径' commit -m "test: add Xplace build acceptance check"
~~~

### Task 5: 编译并准备数据

**Files:** Generated ignored paths; Modify docs/xplace-build-record.md, progress.md, task_plan.md

- [ ] **Step 1: 配置前门禁**

~~~bash
cd '/mnt/f/GAME/复现路径/third_party/Xplace'
test "$(git rev-parse HEAD)" = '49cf66bc75ba9908f145bb6686f03cde692367cf'
test -z "$(git status --porcelain)"
test ! -e build || { echo 'inspect existing build'; exit 1; }
~~~

- [ ] **Step 2: 配置**

从已安装的 PyTorch 直接读取 ABI，再传给 CMake：

~~~bash
mkdir build
cd build
abi=$("$HOME/miniforge3/bin/conda" run -n eda-repro python -c 'import torch; print(int(torch.compiled_with_cxx11_abi()))')
case "$abi" in 0|1) ;; *) printf 'invalid ABI: %s\n' "$abi" >&2; exit 1;; esac
cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_CUDA_ARCHITECTURES=89 -DCMAKE_CXX_ABI="$abi" -DPYTHON_EXECUTABLE="$HOME/miniforge3/envs/eda-repro/bin/python" .. 2>&1 | tee configure.log
~~~

Expected: architecture 89、Conda Python、CUDA Torch、Cairo 均被发现。

- [ ] **Step 3: 编译安装与链接检查**

~~~bash
jobs=$(nproc); if [ "$jobs" -gt 8 ]; then jobs=8; fi
cmake --build . --parallel "$jobs" 2>&1 | tee build.log
cmake --install . 2>&1 | tee install.log
find ../cpp_to_py/cpybin -maxdepth 1 -name '*.so' -print
ldd ../cpp_to_py/cpybin/dct_cuda*.so
~~~

Expected: exit 0，ldd 无 not found。首错即停；未经授权不改源码。

- [ ] **Step 4: 准备数据**

~~~bash
repo='/mnt/f/GAME/复现路径'; xplace="$repo/third_party/Xplace"
mkdir -p "$xplace/data/raw/ispd2005"
for design in adaptec1 adaptec2 adaptec4; do
  test ! -e "$xplace/data/raw/ispd2005/$design"
  mkdir "$xplace/data/raw/ispd2005/$design"
  for source in "$repo/datasets/ispd2005/payload/$design/$design".*.gz; do
    gzip -cd -- "$source" > "$xplace/data/raw/ispd2005/$design/$(basename "${source%.gz}")"
  done
done
~~~

Expected: 每个设计六个 Bookshelf 文件；不运行转换或 placement。记录参数、jobs、产物、archive SHA-256 后提交受控记录。

### Task 6: 最终验收与状态提交

**Files:** Modify docs/xplace-build-record.md, docs/setup-guide.md, manifests/download-status.csv, progress.md, task_plan.md

- [ ] **Step 1: 运行验收**

~~~bash
cd '/mnt/f/GAME/复现路径/third_party/Xplace'
bash '/mnt/f/GAME/复现路径/scripts/check-xplace-build.sh'
~~~

Expected: exit 0，末行 xplace_non_experiment_checks=pass。

- [ ] **Step 2: 更新文档和 manifest**

setup-guide 写入环境激活与验收命令并明确不运行 main.py。Xplace download-status 改为 built，detail 包含 exact HEAD、CUDA/PyTorch、完成 UTC 和 non-experiment acceptance passed；不改变其他工具。

- [ ] **Step 3: 验证边界**

~~~powershell
git -c safe.directory='F:/GAME/复现路径' -C 'F:\GAME\复现路径' check-ignore -v third_party/Xplace/build/CMakeCache.txt
git -c safe.directory='F:/GAME/复现路径' -C 'F:\GAME\复现路径' check-ignore -v third_party/Xplace/data/raw/ispd2005/adaptec1/adaptec1.aux
git -c safe.directory='F:/GAME/复现路径/third_party/Xplace' -C 'F:\GAME\复现路径\third_party\Xplace' status --short --branch
git -c safe.directory='F:/GAME/复现路径' -C 'F:\GAME\复现路径' diff --check
~~~

Expected: 生成物 ignored，Xplace clean。

- [ ] **Step 4: 最终提交**

~~~powershell
git -c safe.directory='F:/GAME/复现路径' -C 'F:\GAME\复现路径' add docs/xplace-build-record.md docs/setup-guide.md manifests/download-status.csv progress.md task_plan.md
git -c safe.directory='F:/GAME/复现路径' -C 'F:\GAME\复现路径' commit -m "docs: complete Xplace build environment"
git -c safe.directory='F:/GAME/复现路径' -C 'F:\GAME\复现路径' status --short --branch
~~~

Expected: clean；只将 Xplace 报告为 built。
