#!/usr/bin/env bash
set -u
printf 'timestamp=%s\n' "$(date -u +%FT%TZ)"
[ -r /etc/os-release ] && . /etc/os-release && printf 'ubuntu=%s\n' "${PRETTY_NAME:-unknown}"
for command_name in git gcc g++ cmake python3 conda nvcc nvidia-smi; do
  if command -v "$command_name" >/dev/null 2>&1; then
    printf '%s=%s\n' "$command_name" "$(command -v "$command_name")"
  else
    printf '%s=missing\n' "$command_name"
  fi
done
python3 --version 2>&1 || true
cmake --version 2>&1 | head -n 1 || true
nvcc --version 2>&1 | tail -n 1 || true
nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader 2>&1 || true
df -h .

