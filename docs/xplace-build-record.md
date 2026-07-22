# Xplace build record

System toolchain installation began on 2026-07-21 (Asia/Shanghai). This post-build record was updated at `2026-07-22T03:07:51Z` UTC. The pinned Xplace checkout was built, installed, and accepted with non-experiment checks; no Xplace source was modified and no experiment was run.

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
- The Python-environment step did not yet build Xplace. The later build recorded below completed without modifying Xplace source or running an experiment.

## Xplace build

- Windows Git verified Xplace clean at `49cf66bc75ba9908f145bb6686f03cde692367cf` and pybind11 clean at `83b92ceb3537666fb0188f564e1d53bf8c80b0ba` before the build.
- The exact interpreter was `/home/amirocok/miniforge3/envs/eda-repro/bin/python` (Python 3.10.20); PyTorch `2.5.1+cu121` reported C++11 ABI `False`. The toolchain was GCC/G++ 13.3.0 and `/usr/bin/nvcc` CUDA 12.0.140.
- CMake configured the pinned source into `Xplace/build` with Ninja, Release, CUDA architecture 89, ABI 0, and the exact Python executable. Configure exited 0.
- `cmake --build Xplace/build --parallel 8` completed 120/120 and exited 0; `cmake --install Xplace/build` exited 0. Logs are `Xplace/build/configure.log`, `Xplace/build/build.log`, and `Xplace/build/install.log`; these replay artifacts are intentionally Git-ignored. Installation produced 12 Python extensions plus `libflute.so` and `libxplace_common.so` in `cpp_to_py/cpybin`.
- A bare `ldd` and direct extension import initially failed because the installed extension RUNPATH contains only `cpp_to_py/cpybin`, while Torch shared libraries live under `/home/amirocok/miniforge3/envs/eda-repro/lib/python3.10/site-packages/torch/lib`. This was a runtime search-path result, not a compile/link failure.
- Diagnostic A imported `torch` before `cpp_to_py.cpybin.dct_cuda` and exited 0 (`A_OK`). Diagnostic B used that exact Torch lib directory in command-local `LD_LIBRARY_PATH`: `ldd` contained no `not found`, and all 12 extensions imported without preloading Torch (`B_ALL_OK 12`). No global shell setting or Xplace source changed.
- The 12-module import was a one-time diagnostic. The persistent `scripts/check-xplace-build.sh` acceptance checks the GPU, data, and three core modules (`dct_cuda`, `density_map_cuda`, and `hpwl_cuda`), importing Torch first. It exited 0 with final line `PASS: Xplace build prerequisites are ready`; it did not run `main.py` or any experiment.
- Xplace source modification: none.

### Reproducible build and runtime commands

Run these commands inside `Ubuntu-24.04` as `amirocok`:

```bash
readonly XPLACE='/mnt/f/GAME/复现路径/third_party/Xplace'
readonly PYTHON='/home/amirocok/miniforge3/envs/eda-repro/bin/python'

cmake -S "$XPLACE" -B "$XPLACE/build" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CUDA_ARCHITECTURES=89 \
  -DCMAKE_CXX_ABI=0 \
  -DPYTHON_EXECUTABLE="$PYTHON" 2>&1 | tee "$XPLACE/build/configure.log"
cmake --build "$XPLACE/build" --parallel 8 2>&1 | tee "$XPLACE/build/build.log"
cmake --install "$XPLACE/build" 2>&1 | tee "$XPLACE/build/install.log"

cd "$XPLACE"
ldd cpp_to_py/cpybin/dct_cuda.cpython-310-x86_64-linux-gnu.so
"$PYTHON" -c "import importlib; importlib.import_module('cpp_to_py.cpybin.dct_cuda')"

"$PYTHON" -c "import torch, importlib; importlib.import_module('cpp_to_py.cpybin.dct_cuda'); print('A_OK')"

torchlib="$($PYTHON -c "import torch; print(torch.__path__[0] + '/lib')")"
LD_LIBRARY_PATH="$torchlib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
  ldd cpp_to_py/cpybin/dct_cuda.cpython-310-x86_64-linux-gnu.so
LD_LIBRARY_PATH="$torchlib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" "$PYTHON" -c \
  "import importlib; modules=('dct_cuda','density_map_cuda','draw_placement','flute_cpp','gpudp','gpugr','hpwl_cuda','io_parser','routedp','wa_wirelength_hpwl_cuda','gputimer','wirelength_timing_cuda'); [importlib.import_module('cpp_to_py.cpybin.' + name) for name in modules]; print('B_ALL_OK', len(modules))"
```

## ISPD 2005 runtime data

- The previously absent target `Xplace/data/raw/ispd2005` was created. For each of `adaptec1`, `adaptec2`, and `adaptec4`, six source gzip members (`aux`, `nets`, `nodes`, `pl`, `scl`, `wts`) were decompressed with `gzip -cd`; every output was checked absent first and noclobber behavior was enabled.
- Each target design contains exactly six non-empty expected files. Source gzip members and tar archives were not modified.
- Archive SHA-256 values match `datasets/ispd2005/payload/files.sha256` / recovery evidence: adaptec1 `B694DEDFE15BFFA7CB92DFBEE0BC11906F5D334D211F51D82D0AC1EFFB6C0A08`, adaptec2 `E5A7BC0E343A97F3D9D3A1C871636A4B51DA7F64EE71D2F04E7DB295655A09A2`, and adaptec4 `CA894BCF93ACE5998DD393A6B6D5F240D3C695159CDC62AB055B8EDF70EF46AB`.

Replay the non-overwriting data preparation and verification from the main repository root:

```bash
readonly REPO='/mnt/f/GAME/复现路径'
readonly XPLACE="$REPO/third_party/Xplace"
readonly SRC="$REPO/datasets/ispd2005/payload"
readonly DST="$XPLACE/data/raw/ispd2005"
set -o noclobber
for design in adaptec1 adaptec2 adaptec4; do
  test ! -e "$DST/$design"
  mkdir -p "$DST/$design"
  for extension in aux nets nodes pl scl wts; do
    test ! -e "$DST/$design/$design.$extension"
    gzip -cd "$SRC/$design/$design.$extension.gz" > "$DST/$design/$design.$extension"
  done
  test "$(find "$DST/$design" -maxdepth 1 -type f | wc -l)" -eq 6
done
sha256sum "$SRC/adaptec1.tar.gz" "$SRC/adaptec2.tar.gz" "$SRC/adaptec4.tar.gz"
printf '%s  %s\n' \
  B694DEDFE15BFFA7CB92DFBEE0BC11906F5D334D211F51D82D0AC1EFFB6C0A08 "$SRC/adaptec1.tar.gz" \
  E5A7BC0E343A97F3D9D3A1C871636A4B51DA7F64EE71D2F04E7DB295655A09A2 "$SRC/adaptec2.tar.gz" \
  CA894BCF93ACE5998DD393A6B6D5F240D3C695159CDC62AB055B8EDF70EF46AB "$SRC/adaptec4.tar.gz" | sha256sum -c -
bash "$REPO/.worktrees/xplace-build/scripts/check-xplace-build.sh"
```

The equivalent Windows archive evidence command is:

```powershell
Get-FileHash -Algorithm SHA256 `
  F:\GAME\复现路径\datasets\ispd2005\payload\adaptec1.tar.gz, `
  F:\GAME\复现路径\datasets\ispd2005\payload\adaptec2.tar.gz, `
  F:\GAME\复现路径\datasets\ispd2005\payload\adaptec4.tar.gz
```

## Non-experiment acceptance

- Ubuntu package indexes refreshed and requested dependencies installed: complete.
- Apt transaction removal count: 0; Linux display-driver metapackage installed: no.
- RTX 4060, driver 560.94, compute capability 8.9, and nvcc `sm_89` support verified: complete.
- Xplace build and non-experiment smoke test: complete.
- Experiments and benchmarks: out of scope and not run.
