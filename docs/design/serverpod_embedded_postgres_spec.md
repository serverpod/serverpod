# `serverpod_embedded_postgres` - Spec

A Dart package that runs a real PostgreSQL server as a child process for
Serverpod local dev. Replaces the docker-compose dev DB with an in-tree
process speaking over a Unix Domain Socket. Same PG version and dialect as
production; only the connection transport changes.

Status: **draft**. Audience: implementors.

---

## 1. Goals

- **No docker dependency** for local Serverpod dev.
- **No TCP port** by default - UDS sidesteps port 5432 contention, Windows
  firewall prompts, and conflicts between two open Serverpod projects.
- One Dart call boots a working PG instance; persistent across restarts.
- Same PG major version as Serverpod Cloud - no dialect drift.
- Trivial swap to a remote PG connection string for cloud deploy.

## 2. Non-goals

- Production use.
- iOS / Android / WASM. Desktop only.
- Replacing `package:postgres` as the driver. We produce a connection string.
- Multi-version-PG-side-by-side in one project.
- PostgreSQL extensions beyond the bundled PostGIS and pgvector. See §11.

## 3. Public API

```dart
final pg = await EmbeddedPostgres.start(
  EmbeddedPostgresOptions(
    dataDir: Directory('.serverpod/pgdata'),
    databaseName: 'projectname',
  ),
);

print(pg.connectionString);
// *nix:    postgres:///projectname?host=/abs/.serverpod/run&user=postgres
// Windows: postgres:///projectname?host=C:/abs/.serverpod/run&user=postgres

await pg.stop();
```

```dart
class EmbeddedPostgresOptions {
  /// Project-local PGDATA. Survives restarts; never cleaned on stop.
  final Directory dataDir;

  /// Database to create on first run.
  final String databaseName;

  /// Default: 'postgres' (matches existing Serverpod conventions).
  final String username;

  /// How the postmaster listens. Default: const UnixTransport().
  final Transport transport;

  /// Default: matches Serverpod Cloud (currently 16.x).
  final Version version;

  /// Override per-user binary cache.
  final Directory? binaryCache;

  /// Cap on initdb + start. Default: 60s.
  final Duration startTimeout;

  /// If true, PG survives parent exit; reattach via [attach]. Default: false.
  final bool detach;

  /// Best-effort cleanup of stale lock state from an abrupt prior exit
  /// (debugger stop, killed VM, orphaned postmaster reparented to init).
  /// Removes dead pidfiles and, on POSIX, terminates an orphan postmaster
  /// whose recorded supervisor is gone. Default: false.
  final bool repairStaleLocks;

  /// Progress callback for binary download/extraction.
  final void Function(double fraction, String stage)? onProgress;
}

/// How the embedded postmaster listens. Mode-specific options live on
/// the variants so [EmbeddedPostgresOptions] stays free of fields that
/// only apply to one transport.
sealed class Transport {
  const Transport();
}

/// Connection over a Unix Domain Socket in `<dataDir>/../run`.
/// Default; auth is `trust` (the project dir already gates access).
final class UnixTransport extends Transport {
  const UnixTransport();
}

/// Connection over loopback TCP. Auth is `scram-sha-256`.
final class TcpTransport extends Transport {
  /// 0 = ephemeral (bind :0, retry up to 3 times on EADDRINUSE).
  final int port;

  /// Password for [EmbeddedPostgresOptions.username]. Default: random.
  final String? password;

  const TcpTransport({this.port = 0, this.password});
}
```

```dart
// Instance methods
Future<void> stop({Duration timeout = const Duration(seconds: 10)});
Future<void> reset();   // stop, wipe dataDir + run/ + pidfile + log, fresh initdb
String       get connectionString;     // libpq-style URI; for psql, pg_dump, etc.
Uri          get connectionUri;
pg.Endpoint  get endpoint;             // package:postgres consumers. UDS: host is the
                                       // socket FILE path, run through shortestPath()
                                       // to fit sockaddr_un.sun_path on all platforms.
Version      get version;
int?         get pid;
bool         get isRunning;

// Statics
static Future<EmbeddedPostgres> start(EmbeddedPostgresOptions opts);
static Future<EmbeddedPostgres> attach(Directory dataDir);
static Future<void> prefetch(Version v, {OsArch? target});
static Directory defaultBinaryCache();
```

`start()` is idempotent: if `dataDir`'s pidfile points at our live PG, returns
the existing handle.

## 4. Architecture

```
EmbeddedPostgres (facade)
  ├── BinaryStore   - fetch + verify + extract Serverpod PG bundles (per-user cache)
  ├── ClusterStore  - initdb, postgresql.conf / pg_hba.conf rewrites (per-project)
  ├── Supervisor    - spawn `postgres`, pidfile, signals, orphan reaper
  └── Transport     - UDS path / TCP port -> connection URI
```

## 5. Binary acquisition

### Source

Serverpod-built PostgreSQL bundles (PostgreSQL + PostGIS + pgvector), published
as GitHub Release assets under `serverpod/serverpod`. Built natively per
`(OS, arch)` by `tool/build_postgres/` (Zig on Linux, Apple clang on macOS,
mingw-w64 on Windows) and published by
`.github/workflows/build-embedded-postgres.yaml`.

```
https://github.com/serverpod/serverpod/releases/download/
  embedded-postgres-v<bom>-r<rev>/
  serverpod-postgres-<bom>-r<rev>-<os>-<arch>.tar.xz
  serverpod-postgres-<bom>-r<rev>-<os>-<arch>.tar.xz.sha256
```

Bundle identity is append-only: `<bom>-r<revision>` (e.g. `16.13.0-r1`). Any
change that alters shipped bytes while the PG version stays the same must bump
the revision so a fixed bundle reaches users whose cache already holds the
previous one. Keep `lib/src/binary/bundle_spec.dart` in sync with
`tool/build_postgres/versions.env`.

Always fetch + verify the `.sha256` sidecar before unpacking, then validate
the embedded `serverpod-bundle-manifest.json` (postgres / revision / platform /
postgis / pgvector) so a mislabeled archive cannot be promoted into the cache.

Default acquisition mode is download-only (`BinarySource.download`); a missing
release asset is an error. `BinarySource.build` (or `SERVERPOD_PG_SOURCE=build`)
forces a local rebuild for development/CI and requires the native toolchain.
`BinarySource.auto` downloads and falls back to build only on a definitive
"not available" response.

### Extraction

Pure Dart via `package:archive` (`XZDecoder` + `TarDecoder`) over the
downloaded `.tar.xz`. Two patterns are required for correctness:

1. **Symlinks must be deferred to a second pass** and created via `Link()`.
   The naive single-pass loop writes 0-byte regular files for symlink
   entries, which breaks versioned dylib chains and yields
   `dyld: Library not loaded` at the first `initdb` invocation.
2. **Restore exec bits after writing.** `OutputFileStream` does not preserve
   TAR mode bits; after writing each file, set the executable bit if
   `entry.mode & 0o111 != 0`. Cheap shell-out to `chmod` on POSIX; no-op on
   Windows (which doesn't honor POSIX exec bits).

XZ decompression dominates and is fundamentally serial.
`OutputFileStream` already streams content to disk without buffering.

### Platform mapping

| OS      | Arch  | Bundle `<os>-<arch>` |
| ------- | ----- | -------------------- |
| linux   | x64   | `linux-x64`          |
| linux   | arm64 | `linux-arm64`        |
| macos   | x64   | `macos-x64`          |
| macos   | arm64 | `macos-arm64`        |
| windows | x64   | `windows-x64`        |

Detect via `Abi.current()`. Fail loudly on unsupported tuples (including
Windows ARM64, which is not yet published). Bundles are native per target -
not cross-compiled, not universal macOS binaries.

### Pinned PG version

Default: **latest 16.x patch** (currently `16.13.0`), matching
`ghcr.io/serverpod/postgres:16` used by the project templates (and by the
primary test docker-composes). Some older test/example compose files still
pin `postgres:16.3` or `pgvector/pgvector:pg16`. Bump in lockstep with
Serverpod Cloud and the published bundle BOM.

### Cache layout

```
<cacheRoot>/<bundleId>/<os>-<arch>/
  bin/  lib/  share/  serverpod-bundle-manifest.json  meta.json
```

`<cacheRoot>` (`BinaryStore.defaultCacheRoot()`):

- Linux: `$XDG_CACHE_HOME/serverpod/pg-binaries` or `~/.cache/serverpod/pg-binaries`
- macOS: `~/Library/Caches/serverpod/pg-binaries`
- Windows: `%LOCALAPPDATA%\serverpod\Cache\pg-binaries`
- Override: `SERVERPOD_PG_CACHE_DIR` (used by CI to stage a portable cache)

`<bundleId>` is `<bom>-r<revision>` so two revisions of the same PG version
never share a cache entry.

### Concurrency

Per-artifact claim/lease under the install dir prevents two `start()` calls
from extracting the same tarball. A loser polls for the winner's `meta.json`;
stale claims are stolen after a timeout. Installed dir is treated read-only.

### Acquisition triggers

Downloaded on demand via `BinaryStore.ensure()`; never bundled in the pub
package. Progress is reported through `onProgress`.

`dart run serverpod_embedded_postgres:prefetch` is exposed for CI warm-up
and offline prep. Accepts a target `<os>-<arch>` so CI hosts can prefetch
artifacts for other platforms (validated against `serverpodPlatformSuffixes`).

### Eviction

Never auto-evict. Different bundle IDs add sibling subdirs alongside
existing ones. Removal only via explicit `prune` command.

## 6. Filesystem layout (per project)

```
<project>/.serverpod/
  pgdata/            # PGDATA. Survives across restarts.
  run/               # UDS dir. Mode 0700. PG creates .s.PGSQL.<port> here.
  postgres.pid       # supervisor pidfile (NOT postmaster.pid)
  postgres.log       # captured stdout+stderr (rotated to .log.1 on start)
```

- `.serverpod/` MUST be gitignored.
- `pgdata/` owned exclusively by embedded PG. Never copy into it.
- `run/` lives next to `pgdata/` so PG can bind via the relative path
  `../run` after its `chdir(PGDATA)` - keeps `sun_path` ~20 bytes regardless
  of how deep the project is on disk. macOS caps `sun_path` at 104 bytes
  (Linux/Windows AF_UNIX: 108). Validation at start is defensive only -
  the relative bind path is always short enough; the check guards against
  pathological custom configs.

### Path-length handling

Both `bind()` and `connect()` pack the path into `sockaddr_un.sun_path`,
which has a per-OS cap. We minimize on both sides:

- **Bind (postmaster)**: `unix_socket_directories = '../run'`. PG `chdir`s
  to PGDATA before binding, so this resolves to `<dataRoot>/run` on disk
  while keeping `sun_path = "../run/.s.PGSQL.<port>"` (~20 bytes). Verified
  via spike: `LOG: listening on Unix socket "../run/.s.PGSQL.5432"`.
- **Connect (consumer)**: the `endpoint.host` getter returns the socket
  *file* path passed through `shortestPath()` (relative to the consumer's
  cwd if shorter than absolute, else absolute). Same kernel inode either
  way - the kernel keys UNIX sockets by inode, not by path string.

Reuse Serverpod's existing util at
`tools/serverpod_cli/lib/src/util/platform_check.dart:40-99`:
`shortestPath`, `requireUnixSocketPathFits`, `maxUnixSocketPathBytes`,
`bindUnixSocket`, `connectUnixSocket`. The util is already used by the
CLI's MCP socket plumbing (`commands/start/mcp_socket.dart`), so it's
not database-specific.

Prerequisites for this package:
1. Move the util from `serverpod_cli` (a tool, not a runtime dep) to
   `packages/serverpod_shared/lib/src/utils/unix_socket.dart`. Update the
   existing CLI call sites (`platform_check.dart`, `mcp_socket.dart` and
   tests) to import from the new location.
2. Add a `shortestPathRelativeTo(path, {required String from})` variant -
   the existing `shortestPath` shortens against `Directory.current`, which
   is the wrong frame when generating PG's conf file (PG's cwd at bind time
   is PGDATA, not the spawning Dart process's cwd).

## 7. Lifecycle

```
uninstalled ─fetch+verify+extract─► installed ─initdb (first run)─►
  initialized ─spawn─► starting ─► ready ─stop()─► stopping ─► stopped
```

### `start()`

1. Validate options (socket path length, dataDir writable).
2. Check pidfile: if present and PID is alive and matches our `postgres` in
   PGDATA (verify via cmdline/cwd, not just PID), return existing handle
   (idempotent). Stale pidfile -> remove and continue.
3. `BinaryStore.ensure(version)`.
4. If `<dataDir>/PG_VERSION` missing -> `ClusterStore.initdb()`. If present
   and major doesn't match `version` -> throw `StaleClusterException`
   pointing at `reset()`.
5. Reconcile `postgresql.conf` and `pg_hba.conf` (idempotent rewrite of a
   delimited managed block; never touch lines outside it).
6. `Supervisor.start()` - spawn `postgres` directly, not `pg_ctl`.
7. Wait for ready (poll socket / TCP connect with backoff). Cap at
   `startTimeout`; on timeout, throw with last N log lines.
8. First run only: connect as superuser, `CREATE DATABASE` (idempotent).

### `stop()`

1. SIGINT (smart shutdown).
2. After half timeout -> SIGTERM (fast).
3. After full timeout -> SIGKILL.
4. Remove pidfile. Do NOT delete `pgdata/`.

Windows: `GenerateConsoleCtrlEvent(CTRL_BREAK_EVENT)` then `TerminateProcess`.

### Orphan recovery

On `start()` if the pidfile points at a live process: identify via process
cmdline + cwd (not PID alone - PIDs get recycled). If it's our PG against
this PGDATA, reuse. Else throw - we don't kill foreign processes. Stale
pidfile with no live process -> remove.

### Parent-exit behavior

Default: supervisor registers Dart VM shutdown hooks (sigint/sigterm/zone)
and calls `stop()` on parent exit. Orphans holding the data dir are the
most common "why won't my dev DB start" cause.

`detach: true` skips the hooks. PG survives parent exit; reconnect with
`EmbeddedPostgres.attach(dataDir)`. Use case: long-lived dev DB across many
short `dart test` invocations.

## 8. Transport

### UDS (default)

```
listen_addresses = ''
unix_socket_directories = '../run'
unix_socket_permissions = 0700
```

`../run` is relative to PGDATA (PG `chdir`s there at startup), keeping
`sun_path` ~20 bytes. See §6 for the path-length rationale.

URI: `postgres:///<db>?host=<shortest socket file path>&user=<user>`
(libpq form). Dart consumers should use `endpoint` instead - see §3.

- **Linux/macOS**: works out of the box.
- **Windows**: PG 13+ on Win10 1803+. The relative form `../run` works
  the same way; PG `chdir`s to PGDATA on Windows too. The Windows bundle is
  built with AF_UNIX enabled; Dart 3.11+ is required for
  `InternetAddressType.unix` on Windows.

### TCP (opt-in)

```
listen_addresses = '127.0.0.1'
unix_socket_directories = ''
port = <chosen>
```

`tcpPort == 0`: bind a temporary `ServerSocket` to `127.0.0.1:0`, read the
allocated port, close it, pass to `postgres`. There's a race between close
and `postgres` binding; retry up to 3 times on `EADDRINUSE` before throwing.

URI: `postgres://<user>:<pw>@127.0.0.1:<port>/<db>`

## 9. Authentication

Auth is implied by transport, not configurable:

- UDS: `local trust` (anyone with read access to the project dir already has
  the data; a 0700 socket adds nothing).
- TCP: `host scram-sha-256` with a random password (returned in
  `connectionString`).

`pg_hba.conf` managed block (preserve everything outside):

```
# >>> serverpod_embedded_postgres BEGIN
local   all   all                  trust
host    all   all   127.0.0.1/32   scram-sha-256
host    all   all   ::1/128        scram-sha-256
# <<< serverpod_embedded_postgres END
```

## 10. PostgreSQL configuration

`postgresql.conf` managed block. Defaults are fixed for v1 - no user override.

```
cluster_name = 'serverpod_dev'

# Resources (laptop-friendly)
shared_buffers = 128MB
work_mem = 4MB
maintenance_work_mem = 64MB

# Logging
log_min_messages = warning
log_min_error_statement = error
log_connections = off
log_disconnections = off
log_statement = 'none'
log_destination = 'stderr'
logging_collector = off       # we capture stdout/stderr

# Durability (dev)
fsync = on                    # off causes corruption on crash
synchronous_commit = off      # acceptable: lose last txn on crash
full_page_writes = on

# Maintenance
autovacuum = on
autovacuum_naptime = 60s

# Misc
max_connections = 100
shared_preload_libraries = ''
```

`initdb` flags: `--username=postgres --encoding=UTF8 --no-locale
--auth-local=trust --auth-host=scram-sha-256 --no-sync`. `--no-locale`
yields byte-wise-stable collation across machines and avoids host-locale
availability surprises.

## 11. Out of scope for v1

Ships with Serverpod 3.5.

- **PostgreSQL extensions beyond PostGIS and pgvector.** The Serverpod-built
  bundles already ship PostGIS and pgvector (matching
  `ghcr.io/serverpod/postgres:16`), so newly created projects can use
  embedded Postgres as a drop-in for the template docker-compose DB. Other
  extensions would need to be added to `tool/build_postgres/`.
- Replication, logical decoding, hot standby.
- Backup/restore tooling - use `pg_dump` directly.
- pgAdmin / web UI.
- Encryption at rest.
- Connection pooling (delegated to `package:postgres`).

## 12. Process management

- Spawn `postgres` directly (not `pg_ctl`) so we own the PID cleanly.
- `Process.start(..., mode: ProcessStartMode.normal)`.
- Tee stdout+stderr to `.serverpod/postgres.log` and a 200-line ring buffer
  for inclusion in exception messages. Rotate `postgres.log` to
  `postgres.log.1` on each `start()`.
- Shutdown hooks via `runZonedGuarded` + `ProcessSignal.sigint.watch()`.
- Pidfile written atomically (write `.tmp`, rename).

### Detecting "ready"

- UDS: poll `FileSystemEntity.type(socketPath)` every 50ms; on socket,
  no-op connect+close.
- TCP: `Socket.connect(loopback, port, timeout: 100ms)` in a loop.

Cap at `startTimeout`. On timeout, throw with last N log lines.

## 13. Errors

Sealed hierarchy. All carry the captured PG log tail when relevant.

```dart
sealed class EmbeddedPostgresException implements Exception { ... }

final class BinaryFetchException;
final class BinaryVerificationException;
final class UnsupportedPlatformException;
final class InitdbException;
final class StartupTimeoutException;
final class CrashedException;
final class AttachException;
final class PostmasterLockBusyException;
final class StaleClusterException;
```

Socket-path-length validation is delegated to `serverpod_shared`'s
`unix_socket` util, which throws `SocketException` directly.

## 14. Serverpod integration

Embedded-PG lifecycle is owned by `PostgresPoolManager` in
`serverpod_database`, not by the CLI. A new `dataPath` field on the
postgres arm of `DatabaseConfig` is the only knob; setting it turns
embedded PG on, omitting it keeps the pool talking to whatever
host/port/user/password the config supplies.

### Configuration field

```yaml
database:
  dialect: postgres
  dataPath: .serverpod/pgdata   # turn on embedded PG; omit to use host/port below
  host: ...
  port: ...
  user: ...
```

- Relative paths resolve from the pool's `Directory.current` when it
  bootstraps (typically the server package root). The CLI normalises to
  absolute before opening a pool for migrations.
- Silently ignored for `dialect: sqlite`.
- Env override: `SERVERPOD_DATABASE_DATA_PATH=<path>`.

### Pool-manager behaviour

When `dataPath` is set, `PostgresPoolManager._bootstrap`:

1. Tries `EmbeddedPostgres.start(repairStaleLocks: true)` against `dataPath`.
2. On `PostmasterLockBusyException` (another process already supervises
   that PGDATA), falls back to `EmbeddedPostgres.attach(dataPath)` and
   holds a client-only handle - `stop()` will close the pool but leave
   the postmaster alone.
3. On any other failure, `stop()`s the just-spawned postmaster and
   rethrows.

The pool's connection endpoint is rewritten from the supervised
postmaster's `pg.Endpoint`, so the host/port/user fields in the config
are overridden when `dataPath` wins.

### Watch-loop note

A pod child VM started by `serverpod start --watch` spawns its own
postmaster (no `detach`) and tears it down on shutdown, so each
file-save restart cycles the postmaster. Acceptable for v1; revisit
with a measurement if save-to-ready latency becomes a developer
complaint.

## 15. Verification plan

- Unit tests: URL construction, sha verification, manifest validation,
  config-block rewrite (idempotence + preservation of unmanaged lines).
- Integration matrix on each published `(OS, arch)` tuple in CI
  (`linux-x64`, `linux-arm64`, `macos-x64`, `macos-arm64`, `windows-x64`).
  Budgets (network-bound cold path varies with GitHub Releases latency):
  1. **Cold network** (empty binary cache): target < 90 s.
  2. **Cold local** (binaries cached, no cluster): target < 5 s
     (initdb dominates).
  3. **Warm** (binaries + cluster cached): target < 2 s.
  4. UDS round-trip `SELECT 1`.
  5. TCP round-trip `SELECT 1`.
  6. Hard-kill PG process; restart succeeds via orphan cleanup.
  7. Hard-kill Dart parent; restart succeeds without manual cleanup.
  8. `reset()` produces a clean cluster.
  9. Two parallel `start()` calls share the binary cache safely.
  10. Idempotent `start()`: second call returns same handle, no second PG.
  11. Bundle smoke: `CREATE EXTENSION postgis` / `vector` plus the supported
      spatial/vector contract (`tool/smoke_bundle.sql`) before every release
      publish.
- Benchmarks: cold start, warm start, query latency vs.
  `ghcr.io/serverpod/postgres:16`.
