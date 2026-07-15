# Building the embedded PostgreSQL bundles

These scripts build the binary bundles that `serverpod_embedded_postgres`
downloads at runtime: **PostgreSQL + PostGIS + pgvector**, with every
component version (and its source SHA-256) pinned in `versions.env` - the
canonical bundle spec, cross-checked against the Dart-side `BundleSpec` by
`bundle_spec_test.dart`. The scripts drive each project's own build system
via a thin compiler wrapper
(`shim/_ccwrap`). The wrapper picks the compiler per platform: **Zig**
(`zig cc`/`zig c++`) on Linux - for an old-glibc target - **Apple clang** on
macOS, and **mingw-w64 gcc** on Windows. No Docker; the output is a single
relocatable `.tar.xz` per platform.

(macOS used zig too until zig's bundled clang 21.1.0 was found to miscompile the
backend into an intermittent segfault - Apple clang builds it crash-free.)

Unlike Zonky's stock binaries, these ship the spatial + vector extensions.

## Run

```sh
# Build on the *target* OS/arch (native per-runner; not cross-compiled).
PGBUILD=/tmp/pgbuild packages/serverpod_embedded_postgres/tool/build_postgres/build-all.sh
# => $PGBUILD/dist/serverpod-postgres-<bom>-r<rev>-<os>-<arch>.tar.xz (+ .sha256)
```

Requires on `PATH`: `cmake`, `pkg-config`, `bison`, `flex`, `make`, `curl`,
`perl`, `tar`/`xz`, `patchelf` (Linux), plus the platform compiler - `zig`
0.16.x on Linux, Apple clang (Xcode) on macOS (also
`xcrun`/`install_name_tool`/`codesign`), mingw-w64 gcc on Windows. CI
(`.github/workflows/build-embedded-postgres.yaml`) runs this per-runner (zig
only on Linux), publishing all five platforms atomically under an append-only
`embedded-postgres-v<bom>-r<rev>` identity. The workflow never updates a
published bundle tag. A bundle fix that keeps the same PG version must bump
`BUNDLE_REVISION` in `versions.env`.

The Linux zig path is zig-version-sensitive (UBSan defaults, glibc target). For
local Linux builds, [anyzig](https://github.com/marler8997/anyzig) is
the recommended way to get the exact version - a single `zig` that fetches any
version on demand. Because there is no `build.zig.zon` for it to read
`minimum_zig_version` from (Zig is used only as a C/C++ compiler here), pass the
version explicitly: `export ZIG_VERSION=0.16.0` and `shim` will invoke
`zig 0.16.0 …`. Leave `ZIG_VERSION` unset with a plain Zig install (CI does).

## Layout

| script | what |
|---|---|
| `fetch-sources.sh` | download + extract all pinned upstream sources |
| `build-core.sh` | PostgreSQL core (force-keeps backend symbols for extensions) |
| `build-deps-c.sh` | sqlite, libxml2, json-c (static) |
| `build-deps-cpp.sh` | GEOS + PROJ (shared dylibs) |
| `build-postgis.sh` | PostGIS against core + deps |
| `package.sh` | stage + relocate + `tar.xz` + sha256 |
| `build-all.sh` | orchestrates all of the above |
| `shim/` | the per-platform compiler wrapper (zig/clang/gcc - see below) |

## The `shim` wrapper

`shim/_ccwrap` is the `CC`/`CXX` the build uses everywhere (so `pg_config`
reports it and PGXS/PostGIS inherit it). It picks the real compiler per platform
and adapts the flags each needs. C++ is selected by the *invocation* (`cxx`)
not just the args, so C++ LINK steps (only `.o` inputs, no `.cpp`) still get the
C++ driver + libc++/libstdc++.

- **macOS -> Apple clang** (`clang`/`clang++`). It implements `-bundle`/
  `-bundle_loader` and `-export_dynamic` natively and defaults UBSan off, so no
  flag rewriting is needed - only `-Wl,-headerpad_max_install_names` on link
  steps, so `package.sh` can rewrite install_names/rpaths for relocation. (macOS
  used zig until its bundled clang 21.1.0 was found to miscompile the backend
  into an intermittent segfault; Apple clang builds it crash-free.)
- **Windows -> mingw-w64 `gcc`/`g++`.** Postgres's win32 build relies on GNU-ld
  semantics zig's lld lacks (notably `--allow-multiple-definition` for its
  `getopt` vs the CRT's); gcc handles `-shared`/`.o`/the win32 LDFLAGS natively.
- **Linux -> `zig cc`/`zig c++`**, plus `-target <arch>-linux-gnu.2.28` so the
  bundle links against the oldest glibc Dart/Flutter support (Debian 10), not
  the build runner's - the redistribution win plain gcc can't give. zig-only
  adaptations: route `.cpp`/`-x c++`/`-std=c++` to `zig c++` (else libc++
  headers like `<algorithm>` are missing); `-fno-sanitize=undefined` (zig
  defaults UBSan on; the `__ubsan_handle_*` calls would be unresolved in
  dlopen'd modules / static libs); `-bundle -> -dynamiclib -undefined
  dynamic_lookup` (zig's lld has no `-bundle` - unused now that only Linux,
  which uses `-shared`, takes this path); and `-Wno-unknown-warning-option` on
  real compiles (postgres bakes GCC-only warning flags into CFLAGS that clang
  doesn't know - left off conftest/cmake probes so they stay discriminating).

`build-core.sh` force-keeps every backend global with `-Wl,-u,<sym>` (+
`-rdynamic`) **on the Linux zig path only** - a belt-and-braces export of the
extension API (postgres's own `--export-dynamic` should suffice on ELF). macOS
(Apple `ld`'s `-export_dynamic`) and Windows (its import library) export the
backend on a plain `make install`, no nm/relink dance.

At runtime the launcher must set `PROJ_LIB=<install>/share/proj` (the supervisor
does this) because PROJ bakes in the build-time data path.

## Platform status

See [`../../PLATFORMS.md`](../../PLATFORMS.md) for the maintained support
matrix and the verification gates each published target must pass. Keeping the
status in one place prevents the build instructions from drifting from the
runtime's published-target list.
