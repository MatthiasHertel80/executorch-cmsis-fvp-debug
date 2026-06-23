# arm-cmsis-fvp devcontainer

Runs the CMSIS all-ops project + `fvp-gdb` debug flow in a Codespace / devcontainer.
The FVP runs natively on Linux — no Docker shim.

## Architecture

```
fvp-gdb  --launch FVP_Corstone_SSE-300  --(Iris)-->  model
   └── serves GDB-RSP on :3333  -->  arm-none-eabi-gdb  -->  (CMSIS Debugger / MCP)
```

Two interchangeable `:3333` providers; gdb rides on either:

| Lane     | Provider                              | Works in Codespaces |
|----------|---------------------------------------|---------------------|
| Virtual  | `fvp-gdb` -> Iris -> avh-fvp           | yes (active lane)   |
| Hardware | `pyocd gdbserver --probe cmsisdap:`   | no USB -> dormant   |

## What the container provisions

- Arm toolchain + **FVP via vcpkg**: `cmsis-toolbox`, `arm-none-eabi-gcc/gdb`,
  `cmake`, `ninja`, and `arm:models/arm/avh-fvp ^11.31.28`. See
  [vcpkg-configuration.json](vcpkg-configuration.json).
- `fvp-gdb` from TestPyPI, `pyocd` from PyPI — installed system-wide so VS Code
  tasks see them.

## First-boot check

VS Code tasks run `bash -c` non-interactively and don't source `~/.bashrc`, so the
vcpkg binaries are symlinked into `/usr/local/bin` by `postCreateCommand.sh`. If a
task can't find `FVP_Corstone_SSE-300` / `cbuild`, re-run that symlink loop or
`source ~/.vcpkg/vcpkg-init && vcpkg activate` in the task shell.
