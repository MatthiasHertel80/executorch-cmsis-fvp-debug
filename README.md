# executorch-cmsis-fvp-debug

Codespaces-ready harness for debugging the ExecuTorch Arm/Cortex-M **all-ops**
test on an Arm Corstone-300 FVP, using `fvp-gdb` (Iris → GDB-RSP) and
`arm-none-eabi-gdb`. The whole stack — toolchain and FVP — is provisioned in the
devcontainer via the Arm vcpkg registry, so a Codespace boots straight into a
working virtual debug target with no physical hardware.

## Layout

```
.devcontainer/            Arm toolchain + avh-fvp (vcpkg) + fvp-gdb + pyocd
.vscode/                  FVP: Start/Stop tasks, fvp-gdb attach launch config
cmsis-all-ops-project/    the csolution project (one model per op)
```

## Quick start

1. **Code → Create codespace** on this repo (default machine; amd64).
2. Build the project (cbuild/csolution flow) — see notes below.
3. *Run Task → `FVP: Start`*, then **F5** (`FVP via fvp-gdb (attach)`).

## Status / known gap

This is a virtual-debug scaffold. The toolchain + FVP install and the debug
plumbing (`fvp-gdb` → `:3333` → gdb) are wired. The one piece still to wire for a
clean end-to-end build is the **`PyTorch::ExecuTorch` CMSIS pack** that
`cmsis-all-ops-project/all_ops.csolution.yml` requires — it needs to be built and
`cpackget add`-ed (or pulled from a pack index) before `cbuild`. `models/` and
`all_ops.cproject.yml` are committed as seed data (normally generated upstream).

## Lanes

| Lane     | Provider                            | In Codespaces       |
|----------|-------------------------------------|---------------------|
| Virtual  | `fvp-gdb` → Iris → avh-fvp           | active              |
| Hardware | `pyocd --probe cmsisdap:`            | dormant (no USB)    |
