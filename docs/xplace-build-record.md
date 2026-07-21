# Xplace build record

Baseline captured on 2026-07-21 (Asia/Shanghai). This record is read-only evidence for a later build; no package was installed, no Xplace source was modified, and no experiment was run.

## Fixed inputs

- Controlled worktree: `F:\GAME\复现路径\.worktrees\xplace-build`
- Controlled branch: `codex/xplace-build`
- Xplace source (outside the worktree): `F:\GAME\复现路径\third_party\Xplace`
- Xplace HEAD: `49cf66bc75ba9908f145bb6686f03cde692367cf`
- pybind11 path: `F:\GAME\复现路径\third_party\Xplace\thirdparty\pybind11`
- pybind11 HEAD: `83b92ceb3537666fb0188f564e1d53bf8c80b0ba`
- Local build/probe path checked in the controlled worktree: `third_party/Xplace/build/probe`
- Ignore evidence: `.gitignore:1:/third_party/*/ third_party/Xplace/build/probe`
- Identity boundary: ordinary sandbox commands run as `CodexSandboxOffline`, while Xplace and the registered WSL distribution belong to the `Lenovo` user. Git verification used per-command `safe.directory` arguments only; global Git configuration was not changed. Linux probes were therefore run read-only in the Lenovo user context.
- WSL stderr warning: WSL reported that the localhost proxy setting was not mirrored into WSL under NAT mode. The current terminal rendered the localized warning as garbled text, so this is a faithful summary rather than a transcription of the corrupted bytes. The warning did not prevent any of the read-only probes below from completing successfully.

## System dependencies

Observed read-only system baseline:

```text
PRETTY_NAME="Ubuntu 24.04.4 LTS"
kernel: 6.18.33.2-microsoft-standard-WSL2
nproc: 32

free -h:
               total        used        free      shared  buff/cache   available
Mem:            15Gi       880Mi        14Gi       3.6Mi       604Mi        14Gi
Swap:          4.0Gi          0B       4.0Gi

df -h / /mnt/f:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdd       1007G  1.4G  955G   1% /
F:\             620G  544G   77G  88% /mnt/f

nvidia-smi --query-gpu=name,driver_version,memory.total,compute_cap --format=csv,noheader:
NVIDIA GeForce RTX 4060 Laptop GPU, 560.94, 8188 MiB, 8.9
```

`apt-cache policy` reported:

| Package | Installed | Candidate / observation |
| --- | --- | --- |
| `cmake` | none | `3.28.3-1build7` |
| `gcc` | none | `4:13.2.0-7ubuntu1` |
| `g++` | none | `4:13.2.0-7ubuntu1` |
| `libboost-all-dev` | pending | command returned no package stanza |
| `libcairo2-dev` | none | `1.18.0-3build1` |
| `nvidia-cuda-toolkit` | pending | command returned no package stanza |

Package installation and repository changes: **pending** (not authorized or performed in this baseline task).

## Conda/PyTorch

- Conda environment name and specification: **pending**.
- Python version: **pending**.
- PyTorch version/build and CUDA compatibility: **pending**.
- Import and device checks: **pending**.

No Conda or PyTorch mutation was performed.

## Xplace build

- Xplace and pybind11 fixed commits verified: complete.
- Required system packages installed: **pending**.
- Build configuration and exact command: **pending**.
- Compiler/CMake/CUDA versions used by a build: **pending**.
- Build output and load/import smoke test: **pending**.

No build command was run and no Xplace source file was changed.

## Non-experiment acceptance

- Worktree branch and clean starting state verified: complete.
- Xplace HEAD equals the fixed input: complete.
- pybind11 HEAD equals the fixed input: complete.
- `third_party/Xplace/build/probe` is ignored in the controlled worktree: complete.
- System, storage, GPU, and package-policy baseline recorded: complete.
- Dependency installation: **pending**.
- Xplace build and non-experiment smoke test: **pending**.
- Experiments and benchmark runs: out of scope and not run.
