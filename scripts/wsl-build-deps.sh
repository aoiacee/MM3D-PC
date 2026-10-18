#!/usr/bin/env bash
# Build fmt + spdlog into a private prefix. Ubuntu 26.04's spdlog 1.15 / fmt 10.1
# fail under clang 21 (consteval FMT_STRING inside spdlog's SPDLOG_LOGGER_CATCH);
# this matches the spdlog 1.17 the Windows build uses.
#   PREFIX=<dir> scripts/wsl-build-deps.sh
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
prefix="${PREFIX:-$root/../build/deps-prefix}"
src="$root/../build/deps-src"
mkdir -p "$src" "$prefix"
fetch() { [ -d "$src/$2" ] || curl -fL "$1" | tar xz -C "$src"; }
fetch https://github.com/fmtlib/fmt/archive/refs/tags/12.0.0.tar.gz fmt-12.0.0
fetch https://github.com/gabime/spdlog/archive/refs/tags/v1.17.0.tar.gz spdlog-1.17.0
common=(-G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX="$prefix" -DCMAKE_PREFIX_PATH="$prefix")
cmake -S "$src/fmt-12.0.0" -B "$src/fmt-build" "${common[@]}" \
  -DBUILD_SHARED_LIBS=ON -DFMT_TEST=OFF -DFMT_DOC=OFF
cmake --build "$src/fmt-build" --target install
cmake -S "$src/spdlog-1.17.0" -B "$src/spdlog-build" "${common[@]}" \
  -DSPDLOG_BUILD_SHARED=ON -DSPDLOG_FMT_EXTERNAL=ON -DSPDLOG_BUILD_EXAMPLE=OFF -DSPDLOG_BUILD_TESTS=OFF
cmake --build "$src/spdlog-build" --target install
echo "deps installed in $prefix"
