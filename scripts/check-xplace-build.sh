#!/usr/bin/env bash
set -euo pipefail

readonly REPO='/mnt/f/GAME/复现路径'
readonly XPLACE="$REPO/third_party/Xplace"
readonly XPLACE_GIT_PATH='F:/GAME/复现路径/third_party/Xplace'
readonly EXPECTED_XPLACE_HEAD='49cf66bc75ba9908f145bb6686f03cde692367cf'
readonly PYBIND="$XPLACE/thirdparty/pybind11"
readonly PYBIND_GIT_PATH="$XPLACE_GIT_PATH/thirdparty/pybind11"
readonly EXPECTED_PYBIND_HEAD='83b92ceb3537666fb0188f564e1d53bf8c80b0ba'
readonly CONDA='/home/amirocok/miniforge3/bin/conda'

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

[[ -d "$XPLACE/.git" ]] || fail "Xplace checkout not found: $XPLACE"
command -v git.exe >/dev/null || fail 'Windows git.exe is unavailable from WSL'

actual_head="$(git.exe -c safe.directory="$XPLACE_GIT_PATH" -C "$XPLACE_GIT_PATH" rev-parse HEAD)"
[[ "$actual_head" == "$EXPECTED_XPLACE_HEAD" ]] ||
  fail "Xplace HEAD is $actual_head; expected $EXPECTED_XPLACE_HEAD"

[[ -z "$(git.exe -c safe.directory="$XPLACE_GIT_PATH" -C "$XPLACE_GIT_PATH" status --porcelain)" ]] ||
  fail 'Xplace checkout is dirty'

[[ -e "$PYBIND/.git" ]] || fail "pybind11 checkout not found: $PYBIND"
actual_pybind_head="$(git.exe -c safe.directory="$PYBIND_GIT_PATH" -C "$PYBIND_GIT_PATH" rev-parse HEAD)"
[[ "$actual_pybind_head" == "$EXPECTED_PYBIND_HEAD" ]] ||
  fail "pybind11 HEAD is $actual_pybind_head; expected $EXPECTED_PYBIND_HEAD"

[[ -z "$(git.exe -c safe.directory="$PYBIND_GIT_PATH" -C "$PYBIND_GIT_PATH" status --porcelain)" ]] ||
  fail 'pybind11 checkout is dirty'

[[ -x "$CONDA" ]] || fail "conda executable not found: $CONDA"

for tool in gcc cmake nvcc; do
  "$CONDA" run --no-capture-output -n eda-repro "$tool" --version >/dev/null ||
    fail "$tool is unavailable in conda environment eda-repro"
done

cd "$XPLACE"

"$CONDA" run --no-capture-output -n eda-repro python - <<'PY'
import importlib
import torch

if not torch.cuda.is_available():
    raise SystemExit('FAIL: torch.cuda.is_available() is not True')

capability = torch.cuda.get_device_capability(0)
if capability != (8, 9):
    raise SystemExit(f'FAIL: CUDA capability is {capability!r}; expected (8, 9)')

device_name = torch.cuda.get_device_name(0)
if 'RTX 4060' not in device_name:
    raise SystemExit(f'FAIL: CUDA device is {device_name!r}; expected RTX 4060')

for module in (
    'cpp_to_py.cpybin.dct_cuda',
    'cpp_to_py.cpybin.density_map_cuda',
    'cpp_to_py.cpybin.draw_placement',
    'cpp_to_py.cpybin.flute_cpp',
    'cpp_to_py.cpybin.gpudp',
    'cpp_to_py.cpybin.gpugr',
    'cpp_to_py.cpybin.hpwl_cuda',
    'cpp_to_py.cpybin.io_parser',
    'cpp_to_py.cpybin.routedp',
    'cpp_to_py.cpybin.wa_wirelength_hpwl_cuda',
    'cpp_to_py.cpybin.gputimer',
    'cpp_to_py.cpybin.wirelength_timing_cuda',
):
    importlib.import_module(module)
PY

readonly DATA_ROOT="$XPLACE/data/raw/ispd2005"
for design in adaptec1 adaptec2 adaptec4; do
  for extension in aux nodes nets pl scl wts; do
    file="$DATA_ROOT/$design/$design.$extension"
    [[ -s "$file" ]] || fail "missing or empty uncompressed Bookshelf file: $file"
  done
done

printf 'PASS: Xplace build prerequisites are ready\n'
printf 'xplace_non_experiment_checks=pass\n'
