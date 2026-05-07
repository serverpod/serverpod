# Platform support

Status of `serverpod_embedded_postgres` on each `(OS, arch)` tuple
covered by Zonky's binaries.

| Tuple              | Verified on this machine | Notes |
| ------------------ | :----------------------: | ----- |
| `macos-arm64`      | indirectly (universal)   | Zonky's `darwin-arm64v8` ships a universal Mach-O; the same artifact ran natively on the Intel host used for development. Direct M-series testing pending. |
| `macos-x64`        | yes                      | Full integration test suite (BinaryStore -> ClusterStore -> Supervisor -> SELECT 1, UDS + TCP, attach round-trip) passes on a 2019 Intel Mac running macOS 25.3. |
| `linux-x64`        | not yet                  | Should work; relies only on cross-platform Dart APIs. CI matrix in phase 10. |
| `linux-arm64`      | not yet                  | Same as above. |
| `windows-x64`      | partial (see below)      | UDS path is wired correctly; orphan recovery is intentionally degraded - see "Windows gaps". |

## Windows gaps (phase 9 follow-up)

The following pieces compile on Windows and the cross-platform Dart APIs
should make them work, but full validation requires a Windows host. The
package is shipped with conservative behavior in the meantime - **we
never signal a foreign process** even at the cost of degrading some
features.

### 1. Process identity verification

`verifyIdentity()` on Windows currently returns `IdentityMatch.foreign`
for any live PID, on the principle that we'd rather lose `attach()`
functionality than ever signal a PID-recycled foreign process.

The proper fix uses [`QueryFullProcessImageName`][qfpin] via FFI
(`package:ffi` + `package:win32` is one route) to read a target
process's executable path, which we'd compare against
`ProcessIdentity.executable`. cwd verification on Windows requires
`NtQueryInformationProcess` + `PEB.ProcessParameters.CurrentDirectory`
which is more involved.

**User-visible effect today:** `EmbeddedPostgres.attach(dataDir)` always
throws on Windows. Workaround: don't use `detach: true` on Windows;
the supervisor's parent-exit hooks handle Ctrl+C cleanly via
`CTRL_BREAK_EVENT`.

[qfpin]: https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-queryfullprocessimagenamew

### 2. AF_UNIX availability

PostgreSQL 13+ on Windows 10 1803+ supports AF_UNIX, and Zonky's
`windows-amd64` artifact is built with that flag. Dart 3.11+ added
`InternetAddressType.unix` support on Windows.

`requireUnixSocketSupport()` (in `serverpod_shared`) enforces the Dart
SDK requirement; it does not enforce the OS version. Calling
`EmbeddedPostgres.start` with `UnixTransport()` on a Windows version
older than 1803 will fail at PG bind time with a less-friendly error.
**Workaround:** use `TcpTransport()` on those hosts; loopback works
back to all supported Windows versions.

## What "verified" means

For a tuple to be verified, the integration test suite (currently 14
end-to-end tests) must pass against a real Zonky 16.13 install. The
suite covers: cold + warm install, initdb, conf reconcile, supervisor
spawn + ready-detect + signal escalation, UDS connect, TCP connect with
scram-sha-256, ephemeral port allocation, password persistence,
detach + attach round-trip, and the StaleClusterException major-mismatch
path.

CI matrix landing the remaining tuples is tracked in phase 10.
