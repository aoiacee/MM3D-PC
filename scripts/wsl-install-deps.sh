#!/usr/bin/env bash
# Install the Ubuntu packages needed for the Linux runtime build and the
# llvm-mingw Windows cross-build (scripts/build-linux-runtime.sh,
# scripts/build-windows-mingw.sh). Tested on Ubuntu 26.04 under WSL2.
set -euo pipefail
sudo apt-get update
sudo apt-get install -y \
  clang lld cmake ninja-build pkg-config python3 zstd xz-utils curl git \
  libsdl2-dev libvulkan-dev vulkan-tools glslc glslang-tools spirv-tools libshaderc-dev \
  libspdlog-dev libfmt-dev libzip-dev zipcmp zipmerge ziptool libtinyxml2-dev nlohmann-json3-dev \
  libpng-dev libglew-dev libbz2-dev liblzma-dev libzstd-dev zlib1g-dev \
  libogg-dev libopus-dev libopusfile-dev libvorbis-dev
