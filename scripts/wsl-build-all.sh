#!/usr/bin/env bash
# Build inside WSL: native Linux runtime first (it fetches dxc, which the
# Windows cross-build needs at ../build/runtime/_deps/dxc-src/bin/dxc), then the
# llvm-mingw Windows build. Run from the WSL-side clone (~/mm3dneo), not /mnt/c.
#   JOBS=4 scripts/wsl-build-all.sh [linux|windows|all]
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
stage="${1:-all}"
logs="$root/../build/logs"; mkdir -p "$logs"
export CMAKE_BUILD_PARALLEL_LEVEL="${JOBS:-4}"
prefix="$root/../build/deps-prefix"
if [ "$stage" = linux ] || [ "$stage" = all ]; then
  [ -f "$prefix/lib/cmake/spdlog/spdlogConfig.cmake" ] || PREFIX="$prefix" bash "$root/scripts/wsl-build-deps.sh" 2>&1 | tee "$logs/deps.log"
  export LD_LIBRARY_PATH="$prefix/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  TRIAEVUM_DEPS_PREFIX="$prefix" TRIAEVUM_BUILD_DIR="$root/../build/runtime" \
    bash "$root/scripts/build-linux-runtime.sh" 2>&1 | tee "$logs/linux.log"
fi
if [ "$stage" = windows ] || [ "$stage" = all ]; then
  BUILD="$root/../build/windows" bash "$root/scripts/build-windows-mingw.sh" 2>&1 | tee "$logs/windows.log"
fi
