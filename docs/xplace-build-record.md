# Xplace build record

System toolchain installed and verified on 2026-07-21 (Asia/Shanghai). This record was updated at `2026-07-21T15:30:38Z` UTC; that is the documentation time, not a claim about the package transaction's exact completion second. No Xplace source was modified, no Xplace build was run, and no experiment was run.

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

- Conda environment name and specification: **pending**.
- Python environment version: **pending**.
- PyTorch version/build and CUDA compatibility: **pending**.
- PyTorch import and device checks: **pending**.
- No Conda or PyTorch mutation was performed in Task 2.

## Xplace build

- Required system packages installed: complete in Task 2.
- Compiler, CMake, CUDA, and `sm_89` toolchain verification: complete in Task 2.
- Xplace configure/build command and output: **pending** and intentionally not run in Task 2.
- Xplace import/load smoke test: **pending**.
- Xplace source modification: none.

## Non-experiment acceptance

- Ubuntu package indexes refreshed and requested dependencies installed: complete.
- Apt transaction removal count: 0; Linux display-driver metapackage installed: no.
- RTX 4060, driver 560.94, compute capability 8.9, and nvcc `sm_89` support verified: complete.
- Xplace build and non-experiment smoke test: **pending**.
- Experiments and benchmarks: out of scope and not run.
