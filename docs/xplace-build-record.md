# Xplace build record

System toolchain installed and verified on 2026-07-21 (Asia/Shanghai). This record was updated at `2026-07-21T16:56:50Z` UTC; that is the documentation time, not a claim about the package transaction's exact completion second. No Xplace source was modified, no Xplace build was run, and no experiment was run.

## Fixed inputs

- Controlled worktree: `F:\GAME\复现路径\.worktrees\xplace-build`
- Controlled branch: `codex/xplace-build`
- Read-only Xplace source: `F:\GAME\复现路径\third_party\Xplace`
- Xplace HEAD: `49cf66bc75ba9908f145bb6686f03cde692367cf`
- pybind11 HEAD: `83b92ceb3537666fb0188f564e1d53bf8c80b0ba`
- Ubuntu distribution: `Ubuntu-24.04`, Ubuntu 24.04.4 LTS under the Lenovo user
- GPU: NVIDIA GeForce RTX 4060 Laptop GPU, Windows driver `560.94`, compute capability `8.9`

## Repository and candidate evidence

Enabled Ubuntu source components were `main universe restricted multiverse`. Before `apt-get update`, `apt-cache policy` returned no stanza for `ninja-build`, `libboost-all-dev`, or `nvidia-cuda-toolkit`; their installed state at that point was therefore **unknown/not reported**, not `pending`. The commands used to capture that evidence, and to inspect the current state now, are:

```bash
grep -RhsE '^[[:space:]]*(deb|Components:)' /etc/apt/sources.list /etc/apt/sources.list.d
apt-cache policy build-essential cmake ninja-build pkg-config libboost-all-dev libcairo2-dev python3-dev flex bison zlib1g-dev nvidia-cuda-toolkit
dpkg-query -W -f='${binary:Package}\t${Status}\t${Version}\n' build-essential cmake ninja-build pkg-config libboost-all-dev libcairo2-dev python3-dev flex bison zlib1g-dev nvidia-cuda-toolkit
```

After `apt-get update`, Ubuntu candidates were:

| Package | Candidate |
| --- | --- |
| `build-essential` | `12.10ubuntu1` |
| `cmake` | `3.28.3-1build7` |
| `ninja-build` | `1.11.1-2` |
| `pkg-config` | `1.8.1-2build1` |
| `libboost-all-dev` | `1.83.0.1ubuntu2` |
| `libcairo2-dev` | `1.18.0-3build1` |
| `python3-dev` | `3.12.3-0ubuntu2.1` |
| `flex` | `2.6.4-8.2build1` |
| `bison` | `2:3.8.2+dfsg-1build2` |
| `zlib1g-dev` | `1:1.3.dfsg-3.1ubuntu2.1` |
| `nvidia-cuda-toolkit` | `12.0.140~12.0.1-4build4` |

The simulated install reported `402 newly installed, 30 upgraded, 0 to remove and 113 not upgraded`. No `upgrade` or `dist-upgrade` command was run. The actual install fetched 2550 MB in 18 minutes 33 seconds and exited successfully. It used only Ubuntu archive/security repositories; no NVIDIA external repository, keyring, Linux display-driver metapackage, or unknown mirror was added.

## Installed system toolchain

Command executed as the Ubuntu distribution root after `sudo -n` reported that a password was required:

```bash
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential cmake ninja-build pkg-config libboost-all-dev \
  libcairo2-dev python3-dev flex bison zlib1g-dev nvidia-cuda-toolkit
```

All requested packages report `Status: install ok installed`. Key evidence:

```text
/usr/bin/gcc     gcc 13.3.0
/usr/bin/g++     g++ 13.3.0
/usr/bin/cmake   cmake 3.28.3
/usr/bin/ninja   ninja 1.11.1
/usr/bin/pkg-config
/usr/bin/nvcc    CUDA compilation tools 12.0, V12.0.140
Cairo            1.18.0 (pkg-config --modversion cairo)
Boost            1.83.0.1ubuntu2 (libboost-dev)
```

The installed toolchain and GPU evidence can be replayed with:

```bash
gcc --version | head -1
g++ --version | head -1
cmake --version | head -1
pkg-config --modversion cairo
dpkg-query -W libboost-dev
nvcc --version
nvidia-smi --query-gpu=name,driver_version,compute_cap --format=csv,noheader
nvcc --list-gpu-code | grep -Fx sm_89
probe_dir=$(mktemp -d)
trap 'rm -rf -- "$probe_dir"' EXIT
nvcc -arch=sm_89 -x cu /dev/null -c -o "$probe_dir/xplace-sm89-probe.o"
file "$probe_dir/xplace-sm89-probe.o"
```

The package archives remain under `/var/cache/apt/archives/`, including:

- `/var/cache/apt/archives/build-essential_12.10ubuntu1_amd64.deb`
- `/var/cache/apt/archives/cmake_3.28.3-1build7_amd64.deb`
- `/var/cache/apt/archives/ninja-build_1.11.1-2_amd64.deb`
- `/var/cache/apt/archives/libboost-all-dev_1.83.0.1ubuntu2_amd64.deb`
- `/var/cache/apt/archives/libcairo2-dev_1.18.0-3build1_amd64.deb`
- `/var/cache/apt/archives/nvidia-cuda-toolkit_12.0.140~12.0.1-4build4_amd64.deb`

## CUDA and Ada verification

- Ubuntu's `nvidia-cuda-toolkit` 12.0 satisfies the required CUDA >= 11.3 and was preferred over an external NVIDIA repository.
- Driver `560.94` exposes the RTX 4060 to WSL and `nvidia-smi` reports compute capability `8.9`.
- `nvcc --list-gpu-code` includes `sm_89`.
- `nvcc -arch=sm_89 -x cu /dev/null -c` succeeded and produced an ELF 64-bit relocatable object; the temporary object was removed.
- `dpkg --audit` produced no output after installation.

## Conda and PyTorch

- Miniforge `26.3.2-2` base files were installed offline at `/home/amirocok/miniforge3` at documentation time `2026-07-21T16:23:02Z` UTC, using batch mode only; no shell initialization was requested.
- Installer: `Miniforge3-26.3.2-2-Linux-x86_64.sh`, exact size `106038245` bytes, SHA-256 `42260ffe3830fb953d5eee1bbb32229ff06aa7c3833c1ed7a9a0420a95685d94`.
- Official release URL: `https://github.com/conda-forge/miniforge/releases/download/26.3.2-2/Miniforge3-26.3.2-2-Linux-x86_64.sh`.
- Install command: `bash /mnt/c/Users/Lenovo/Downloads/Miniforge3-26.3.2-2-Linux-x86_64.sh -b -p /home/amirocok/miniforge3` (run as `amirocok`).
- After the user-authorized `wsl.exe --shutdown` returned exit code 0, Ubuntu restarted cleanly. The prefix is owned by `amirocok:amirocok` with mode `755`; `conda --version` reports `conda 26.3.2`, and base Python reports `Python 3.13.13`.
- Conda environment: `eda-repro`, created with `/home/amirocok/miniforge3/bin/conda env create --file /mnt/f/GAME/复现路径/.worktrees/xplace-build/env/environment.yml`; environment Python is `3.10.20`, and its exact interpreter is `/home/amirocok/miniforge3/envs/eda-repro/bin/python`.
- PyTorch installation method: pip only, using the official index `https://download.pytorch.org/whl/cu121`; command: `/home/amirocok/miniforge3/envs/eda-repro/bin/python -m pip install torch==2.5.1 --index-url https://download.pytorch.org/whl/cu121`. The fixed [PyTorch v2.5.1 previous-version section](https://pytorch.org/get-started/previous-versions/#v251) lists the Linux CUDA 12.1 wheel index command.
- Installed PyTorch: `2.5.1+cu121`; bundled CUDA runtime: `12.1`. This was selected instead of a CPU build or newer CUDA bundle because Xplace requires PyTorch >= 1.12/CUDA >= 11.3 and the host compiler is CUDA 12.0. PyTorch v2.5.1's tagged [`torch/utils/cpp_extension.py`](https://github.com/pytorch/pytorch/blob/v2.5.1/torch/utils/cpp_extension.py#L394-L416) raises for a CUDA major-version mismatch but emits `CUDA_MISMATCH_WARN` for a same-major minor-version mismatch.
- Verification at `2026-07-21T16:39:25Z` UTC used `/home/amirocok/miniforge3/envs/eda-repro/bin/python -c "import sys, torch; print(sys.version.split()[0]); print(torch.__version__); print(torch.version.cuda); print(torch.compiled_with_cxx11_abi()); print(torch.cuda.is_available()); print(torch.cuda.get_device_name(0)); print(torch.cuda.get_device_capability(0))"`: Python is `3.10.20`; PyTorch is `2.5.1+cu121`; bundled CUDA is `12.1`; `torch.compiled_with_cxx11_abi()` is `False`; `torch.cuda.is_available()` is `True`; device is `NVIDIA GeForce RTX 4060 Laptop GPU`; capability is `(8, 9)`.
- Pip-only audit commands were `/home/amirocok/miniforge3/bin/conda list -n eda-repro --show-channel-urls`, `/home/amirocok/miniforge3/envs/eda-repro/bin/python -m pip show torch`, and `/home/amirocok/miniforge3/envs/eda-repro/bin/python -c "import torch; print(torch.__file__)"`. The Conda listing contains `torch 2.5.1+cu121 pypi_0 pypi` and no `pytorch`, `torchvision`, or `torchaudio` package; pip reports location `/home/amirocok/miniforge3/envs/eda-repro/lib/python3.10/site-packages`, and the import resolves to `/home/amirocok/miniforge3/envs/eda-repro/lib/python3.10/site-packages/torch/__init__.py`. This confirms a single pip installation rather than a mixed Conda/pip PyTorch installation.
- No Xplace build was run, no Xplace source was modified, and no experiment was run.

## Xplace build

- Required system packages installed: complete through Task 3.
- Compiler, CMake, CUDA, and `sm_89` toolchain verification: complete through Task 3.
- Xplace configure/build command and output: **pending** and intentionally not run through Task 3.
- Xplace import/load smoke test: **pending**.
- Xplace source modification: none.

## Non-experiment acceptance

- Ubuntu package indexes refreshed and requested dependencies installed: complete.
- Apt transaction removal count: 0; Linux display-driver metapackage installed: no.
- RTX 4060, driver 560.94, compute capability 8.9, and nvcc `sm_89` support verified: complete.
- Xplace build and non-experiment smoke test: **pending**.
- Experiments and benchmarks: out of scope and not run.
