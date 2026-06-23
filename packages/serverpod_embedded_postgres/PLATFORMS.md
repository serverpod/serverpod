# Platform support

Status of `serverpod_embedded_postgres` on each `(OS, arch)` tuple
covered by Zonky's binaries.

| Tuple              | Verified on this machine | Notes |
| ------------------ | :----------------------: | ----- |
| `macos-arm64`      | indirectly (universal)   | Zonky's `darwin-arm64v8` ships a universal Mach-O; the same artifact ran natively on the Intel host used for development. Direct M-series testing pending. |
| `macos-x64`        | yes                      | Full integration test suite (BinaryStore -> ClusterStore -> Supervisor -> SELECT 1, UDS + TCP, attach round-trip) passes on a 2019 Intel Mac running macOS 25.3. |
| `linux-x64`        | not yet                  | Should work; relies only on cross-platform Dart APIs. CI matrix in phase 10. |
| `linux-arm64`      | not yet                  | Same as above. |
| `windows-x64`      | partial (see below)      | UDS path is wired correctly; identity check uses exe-path equality only (no dataDir match); orphan-kill works via TerminateProcess. |

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
