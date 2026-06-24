# Building the embedded PostgreSQL bundles

These scripts build the binary bundles that `serverpod_embedded_postgres`
downloads at runtime: **PostgreSQL 16.13 + PostGIS 3.5.4 + pgvector 0.8.3**,
compiled with **Zig** (`zig cc`/`zig c++`) as a drop-in C/C++ compiler driving
each project's own build system. No Docker; the output is a single relocatable
`.tar.xz` per platform.

Unlike Zonky's stock binaries, these ship the spatial + vector extensions.

## Run

```sh
# Build on the *target* OS/arch (native per-runner; not cross-compiled).
PGBUILD=/tmp/pgbuild packages/serverpod_embedded_postgres/tool/build_postgres/build-all.sh
# => $PGBUILD/dist/serverpod-postgres-<bom>-<os>-<arch>.tar.xz (+ .sha256)
```

Requires on `PATH`: `zig` 0.16.x, `cmake`, `pkg-config`, `bison`, `flex`,
`make`, `curl`, `perl`, `tar`/`xz`. macOS also uses `xcrun`,
`install_name_tool`, `codesign`. CI (`.github/workflows/build-embedded-postgres.yaml`)
pins Zig via `mlugg/setup-zig` and runs this per-runner, publishing to a
`embedded-postgres-v<bom>` release.

The recipe is Zig-version-sensitive (Mach-O symbol GC, `-bundle`, UBSan
defaults). For local builds, [anyzig](https://github.com/marler8997/anyzig) is
the recommended way to get the exact version - a single `zig` that fetches any
version on demand. Because there is no `build.zig.zon` for it to read
`minimum_zig_version` from (Zig is used only as a C/C++ compiler here), pass the
version explicitly: `export ZIG_VERSION=0.16.0` and `zigshim` will invoke
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
| `zigshim/` | the `zig cc`/`zig c++` wrapper (see below) |

## The `zigshim` wrapper

Postgres + PGXS + PostGIS emit flags Zig's toolchain doesn't handle the same
way as Apple clang. The wrapper (`zigshim/_zigwrap`) adapts them - all
platform-gated (macOS unless noted) and no-ops elsewhere:

1. **`-x c++` / `.cpp` / `-std=c++` -> `zig c++`.** `zig cc` doesn't wire up the
   libc++ headers; PostGIS compiles `.cpp` via `$(CC) -x c++`.
2. **`-bundle [-bundle_loader X]` -> `-dynamiclib -Wl,-undefined,dynamic_lookup`.**
   Zig's Mach-O linker has no `-bundle`; `dlopen` loads an `MH_DYLIB` fine.
3. **`-fno-sanitize=undefined` for C++.** `zig c++` enables UBSan by default; the
   `__ubsan_handle_*` calls would be unresolved in a `dlopen`'d module.
4. **`-Wl,-headerpad_max_install_names` on macOS link steps** so `package.sh`
   can rewrite install_names/rpaths to make the bundle relocatable.
5. **`-Wno-unknown-warning-option` on real compiles only.** postgres's
   `configure` bakes GCC-only warning flags (`-Wimplicit-fallthrough=3`,
   `-Wno-stringop-truncation`) into CFLAGS, which PostGIS/pgvector inherit;
   clang doesn't recognize them and emits a cosmetic note on every file. This
   silences it for actual compiles while leaving autoconf/cmake probe compiles
   (`conftest.*`, `CMakeScratch/…`, `*CompilerId.c`) untouched, so those probes
   stay discriminating about which flags clang really supports.
6. **`-target x86_64-windows-gnu` on a Windows/MSYS2 host.** Forces the mingw
   (gnu) ABI + Zig's bundled mingw-w64 sysroot, so we don't pick up the MSVC ABI
   when Visual Studio is also present (e.g. GitHub's windows runners).

`build-core.sh` additionally force-keeps every backend global with
`-Wl,-u,<sym>` (+ `-rdynamic`): Zig's Mach-O linker garbage-collects globals
unreferenced in the link graph (ignoring `-rdynamic` / `-exported_symbols_list`),
but extension modules resolve those symbols against the postmaster at load - the
macOS equivalent of Linux `--export-dynamic`.

At runtime the launcher must set `PROJ_LIB=<install>/share/proj` (the supervisor
does this) because PROJ bakes in the build-time data path.

## Platform status

| platform | status |
|---|---|
| macOS x64 | ✅ built + bundle verified end-to-end |
| macOS arm64 | ⏳ same recipe; CI re-signs after `install_name_tool` |
| Linux x64 / arm64 | ⏳ builds; relocation packaging (ELF `$ORIGIN` rpath) is TODO - also pin glibc via a Zig target triple and add `-fPIC` for static deps linked into shared libs |
| Windows x64 | ⏳ builds via MSYS2 + zig->`x86_64-windows-gnu`; geo DLLs beside `postgres.exe` (no rpath). UNVALIDATED - pending CI. Likely rough spots: postgres's `windres` step, postgis-on-mingw configure, where postgres's own DLLs (libpq) land |
