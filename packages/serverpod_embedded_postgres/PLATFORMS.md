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
SDK requirement; it does not enforce the OS version. The default transport
automatically falls back to loopback TCP when the running Dart SDK lacks
AF_UNIX support. Explicitly requesting `UnixTransport()` on a Windows version
older than 1803 will fail at PG bind time with a less-friendly error; use
`TcpTransport()` on those hosts.

### 3. Elevated tokens

PostgreSQL refuses to run under an Administrators-group token. Every CI job
that starts the Windows postmaster, including bundle smoke, integration, and
generated-project bootstrap tests, runs under a limited token via `PsExec -l`;
local elevated terminals will see PG's own refusal message.

## What "verified" means

For a tuple to be verified, two gates must pass in CI against a real
Serverpod bundle:

1. The integration test suite (BinaryStore -> ClusterStore -> Supervisor,
   UDS + TCP, attach round-trip, stale-lock recovery).
2. The release smoke battery (`tool/smoke_bundle.sql`): extension loading
   plus the supported spatial/vector contract documented in
   [README.md](README.md), run before any bundle is published.
