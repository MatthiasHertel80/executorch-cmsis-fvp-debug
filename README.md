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
packs/                    bundled PyTorch.ExecuTorch CMSIS pack (offline install)
scripts/setup-packs.sh    installs the bundled pack via cpackget
```

## Quick start

1. **Code → Create codespace** on this repo (default machine; amd64).
2. `postCreate` auto-installs the bundled pack; if a build can't find
   `PyTorch::ExecuTorch`, run `scripts/setup-packs.sh` once.
3. Build the project (cbuild/csolution flow).
4. *Run Task → `FVP: Start`*, then **F5** (`FVP via fvp-gdb (attach)`).

## CMSIS pack

`cmsis-all-ops-project/all_ops.csolution.yml` requires the `PyTorch::ExecuTorch`
pack, which isn't on any public pack index — so it's **bundled** at
[`packs/PyTorch.ExecuTorch.1.3.1-rc2.pack`](packs/) and installed offline by
`scripts/setup-packs.sh` (`cpackget add … --force --agree-embedded-license`). The
`ARM::*` packs (CMSIS, Cortex_DFP, CMSIS-NN) still resolve from the public index,
so the first build needs network. `models/` and `all_ops.cproject.yml` are
committed as seed data (normally generated upstream).

## Lanes

| Lane     | Provider                            | In Codespaces       |
|----------|-------------------------------------|---------------------|
| Virtual  | `fvp-gdb` → Iris → avh-fvp           | active              |
| Hardware | `pyocd --probe cmsisdap:`            | dormant (no USB)    |
