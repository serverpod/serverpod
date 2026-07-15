# Platform support

Status of `serverpod_embedded_postgres` on each `(OS, arch)` tuple covered
by the Serverpod PostgreSQL bundles (PostgreSQL + PostGIS + pgvector).

| Tuple           | Verified | How |
| --------------- | :------: | --- |
| `linux-x64`     | yes      | Full integration suite + release smoke gate in CI (`ubuntu-22.04` / `ubuntu-latest`). |
| `linux-arm64`   | yes      | Same, on `ubuntu-22.04-arm` / `ubuntu-24.04-arm`. |
| `macos-x64`     | yes      | Same, on `macos-15-intel`. |
| `macos-arm64`   | yes      | Same, on `macos-15`. |
| `windows-x64`   | yes      | Same, on `windows-2022` / `windows-latest`, under a limited (non-admin) token. |

These are the only published targets; `serverpodPlatformSuffixes` (and the
`prefetch --target` validation) reflects exactly this set. Native Windows
ARM64 is not yet published.

## The bundle

Bundles are built by `.github/workflows/build-embedded-postgres.yaml` from
the scripts in `tool/build_postgres/`, natively on each target platform.
The compiler is **Zig on Linux**, **Apple clang on macOS**, and
**MinGW-w64 GCC on Windows**. Every component version (and its source
SHA-256) is pinned in `tool/build_postgres/versions.env`, the canonical
bundle specification, cross-checked against the Dart-side `BundleSpec`.

### Bundle revisions and immutability

A bundle's identity is `<pg-version>-r<revision>`, e.g. `16.13.0-r1` -
release tag `embedded-postgres-v16.13.0-r1`, archive
`serverpod-postgres-16.13.0-r1-<os>-<arch>.tar.xz`, cache directory
`<cache>/16.13.0-r1/<os>-<arch>/`. Published releases are **immutable**
and **complete** (all five platforms publish atomically or not at all).
Any fix that changes the shipped bytes while the PostgreSQL version stays
the same must bump `BUNDLE_REVISION`; the new revision has its own release,
URLs, and cache entries, so it reaches users whose cache holds the previous
one. Every archive embeds a `serverpod-bundle-manifest.json` that is
validated after extraction against the requested identity.

### Download by default

The runtime **downloads** the prebuilt bundle by default and fails with an
actionable error when it is not published (`SERVERPOD_PG_SOURCE=download`).
Building from source (`build`, or `auto` to fall back on a 404) is an
explicit development/CI mode requiring the native toolchain; end users are
not expected to build.

### Supported extension surface

The bundle is **not a full PostGIS distribution**. It ships the subset that
Serverpod's model and column APIs use: geography values (point, line
string, polygon, geometry collection) with `ST_Intersects`, `ST_DWithin`,
`ST_Distance`, `ST_Covers`, `ST_CoveredBy`, plus pgvector's `vector`,
`halfvec`, `sparsevec`, and bit distance operators with HNSW/IVFFlat
indexes. Raster, the address standardizer, protobuf-backed output (e.g.
vector tiles), and PROJ network grids are compiled out. The release smoke
gate (`tool/smoke_bundle.sql`) exercises exactly this contract on every
platform before publication.

## Windows notes

### 1. Process identity verification

`verifyIdentity()` on Windows compares `identity.executable` against the
running process's exe path read via [`QueryFullProcessImageName`][qfpin]
(through `package:win32`). It does NOT match `identity.dataDir` against
the running process's command line - reading another process's command
line on Windows requires `NtQueryInformationProcess` +
`PEB.ProcessParameters.CommandLine`, which is not yet wired. The
exe-only check is sufficient for orphan recovery because the supervisor
PID identity (also recorded) gives a second pin.

[qfpin]: https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-queryfullprocessimagenamew

### 2. AF_UNIX availability

PostgreSQL 13+ on Windows 10 1803+ supports AF_UNIX, and the Windows
bundle is built with that flag. Dart 3.11+ added
`InternetAddressType.unix` support on Windows.

`requireUnixSocketSupport()` (in `serverpod_shared`) enforces the Dart
SDK requirement; it does not enforce the OS version. Calling
`EmbeddedPostgres.start` with `UnixTransport()` on a Windows version
older than 1803 will fail at PG bind time with a less-friendly error.
**Workaround:** use `TcpTransport()` on those hosts; loopback works
back to all supported Windows versions.

### 3. Elevated tokens

PostgreSQL refuses to run under an Administrators-group token. CI runs
the Windows integration and smoke jobs under a limited token via
`PsExec -l`; local elevated terminals will see PG's own refusal message.

## What "verified" means

For a tuple to be verified, two gates must pass in CI against a real
Serverpod bundle:

1. The integration test suite (BinaryStore -> ClusterStore -> Supervisor,
   UDS + TCP, attach round-trip, stale-lock recovery).
2. The release smoke battery (`tool/smoke_bundle.sql`): extension loading
   plus the supported spatial/vector contract above, run before any
   bundle is published.
