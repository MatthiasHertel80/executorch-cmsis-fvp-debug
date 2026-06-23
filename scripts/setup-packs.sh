#!/bin/bash
# Install the bundled ExecuTorch CMSIS pack so csolution/cbuild can resolve
# `PyTorch::ExecuTorch` offline. The ARM::* packs (CMSIS, Cortex_DFP, CMSIS-NN)
# still resolve from the public index, so the first build needs network.
set -uo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
export CMSIS_PACK_ROOT="${CMSIS_PACK_ROOT:-$HOME/.cache/arm/packs}"
mkdir -p "$CMSIS_PACK_ROOT"

if ! command -v cpackget >/dev/null 2>&1; then
  echo "cpackget not on PATH — activate the toolchain first:" >&2
  echo "  source ~/.vcpkg/vcpkg-init && vcpkg activate" >&2
  exit 1
fi

# Public index so ARM::* packs resolve.
cpackget init "https://www.keil.com/pack/index.pidx" 2>/dev/null || cpackget update-index || true

# Local ExecuTorch pack (not published to any public index).
cpackget add "$REPO/packs/PyTorch.ExecuTorch.1.3.1-rc2.pack" --force --agree-embedded-license

echo "== installed packs =="
cpackget list 2>/dev/null || true
