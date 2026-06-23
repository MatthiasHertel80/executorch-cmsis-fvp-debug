#!/bin/bash
# Provision the Arm CMSIS toolchain + AVH FVP (via vcpkg) and the debug bridges
# (fvp-gdb, pyOCD) for the Codespace. Mirrors Arm's CMSIS_6 devcontainer flow.
set -euo pipefail

echo ">> Bootstrapping vcpkg ..."
. <(curl -sL https://aka.ms/vcpkg-init.sh)
grep -q "vcpkg-init" ~/.bashrc || \
  printf '\n# Initialize vcpkg\n. ~/.vcpkg/vcpkg-init\n' >> ~/.bashrc

echo ">> Activating Arm tools (cmsis-toolbox, arm-none-eabi-gcc/gdb, cmake, ninja, avh-fvp) ..."
pushd "$(dirname "$0")" >/dev/null
vcpkg-shell x-update-registry --all
vcpkg-shell activate
popd >/dev/null

# VS Code tasks/launch run `bash -c` non-interactively and do NOT source ~/.bashrc,
# so expose the vcpkg-resolved binaries on a stable global PATH for them.
echo ">> Linking vcpkg tools into /usr/local/bin for VS Code tasks ..."
for t in FVP_Corstone_SSE-300 arm-none-eabi-gdb arm-none-eabi-gcc cbuild csolution cpackget cbuild2cmake; do
  p="$(command -v "$t" || true)"
  [ -n "$p" ] && sudo ln -sf "$p" "/usr/local/bin/$t"
done

echo ">> Installing debug bridges (system-wide, always on PATH) ..."
# fvp-gdb is published on TestPyPI; its deps come from prod PyPI.
sudo pip install --no-cache-dir \
  -i https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ fvp-gdb
sudo pip install --no-cache-dir pyocd

echo ">> Done. Sanity check:"
command -v FVP_Corstone_SSE-300 cbuild fvp-gdb pyocd arm-none-eabi-gdb || true
