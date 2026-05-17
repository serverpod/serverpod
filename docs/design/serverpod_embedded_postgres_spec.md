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
- PostgreSQL extensions (PostGIS, pgvector, ...). See §11.

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
  ├── BinaryStore   - fetch + verify + extract Zonky tarballs (per-user cache)
  ├── ClusterStore  - initdb, postgresql.conf / pg_hba.conf rewrites (per-project)
  ├── Supervisor    - spawn `postgres`, pidfile, signals, orphan reaper
  └── Transport     - UDS path / TCP port -> connection URI
```

## 5. Binary acquisition

### Source

Zonky's `embedded-postgres-binaries-<platform>-<arch>` JARs on Maven Central.

```
https://repo1.maven.org/maven2/io/zonky/test/postgres/
  embedded-postgres-binaries-<platform>-<arch>/<bom>/
  embedded-postgres-binaries-<platform>-<arch>-<bom>.jar
```

Each JAR contains exactly one `.txz` at its root. The inner filename does
**not** match the outer artifact's `<platform>-<arch>` suffix - Zonky uses
a different naming inside the JAR (e.g. outer `darwin-amd64` -> inner
`postgres-darwin-x86_64.txz`; outer `darwin-arm64v8` -> inner
`postgres-darwin-arm_64.txz`). Glob for the single root-level `.txz` rather
than constructing the name.

Linux: Zonky compiles from source. Darwin/Windows: Zonky repackages
EnterpriseDB binaries. Always fetch + verify the `.sha256` sidecar before
unpacking.

### Extraction

Pure Dart via `package:archive` (`XZDecoder` + `TarDecoder`). Two patterns
are required, both validated by the spike:

1. **Symlinks must be deferred to a second pass** and created via `Link()`.
   The naive single-pass loop writes 0-byte regular files for symlink
   entries, which breaks PG's versioned dylib chain
   (`libicudata.68.dylib` -> `.68.2.dylib`) and yields
   `dyld: Library not loaded` at the first `initdb` invocation.
2. **Restore exec bits after writing.** `OutputFileStream` does not preserve
   TAR mode bits; after writing each file, set the executable bit if
   `entry.mode & 0o111 != 0`. Cheap shell-out to `chmod` on POSIX; no-op on
   Windows (which doesn't honor POSIX exec bits).

Spike measured ~40s for 1048 entries / 17 symlinks on macOS-amd64 - XZ
decompression dominates and is fundamentally serial. `OutputFileStream`
already streams content to disk without buffering.

### Platform mapping

| OS      | Arch  | Zonky `<platform>-<arch>` |
| ------- | ----- | ------------------------- |
| linux   | x64   | `linux-amd64`             |
| linux   | arm64 | `linux-arm64v8`           |
| macos   | x64   | `darwin-amd64`            |
| macos   | arm64 | `darwin-arm64v8`          |
| windows | x64   | `windows-amd64`           |

Detect via `Abi.current()`. Fail loudly on unsupported tuples.

### Pinned PG version

Default: **latest 16.x patch**, matching `pgvector/pgvector:pg16` used by the
project templates today and `postgres:16.3` in the test docker-composes.
PG 14-17 ship universal binaries on macOS via EDB; only PG 18.0-18.2 had a
regression ([edb-installers#409](https://github.com/EnterpriseDB/edb-installers/issues/409)).
Bump in lockstep with Serverpod Cloud.

### Cache layout

```
<userCache>/serverpod/pg-binaries/<pg-version>/<platform>-<arch>/
  bin/  lib/  share/  .meta.json   # source URL, sha256, install timestamp
```

`<userCache>`:

- Linux: `$XDG_CACHE_HOME/serverpod` or `~/.cache/serverpod`
- macOS: `~/Library/Caches/serverpod`
- Windows: `%LOCALAPPDATA%\serverpod\Cache`

### Concurrency

Per-cache file lock (`flock` POSIX, `LockFileEx` Windows, or `<cache>/.lock`
with O_EXCL retry) prevents two `start()` calls from extracting the same
tarball. Installed dir is treated read-only.

### Acquisition triggers

Downloaded on demand via `BinaryStore.ensure()`; never bundled in the pub
package (~30-50 MB/platform). `serverpod_cli start` calls `ensure()` before
launching, with progress reported through the existing CLI progress UI via
`onProgress`.

`dart run serverpod_embedded_postgres:prefetch` is exposed for CI warm-up
and offline prep. Accepts a target `(os, arch)` so CI hosts can prefetch
artifacts for other platforms.

### Eviction

Never auto-evict. Different versions add `<pg-version>/` subdirs alongside
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
  the same way; PG `chdir`s to PGDATA on Windows too. AF_UNIX support in
  Zonky's Windows binaries manually verified.

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
yields byte-wise-stable collation across machines and avoids Zonky-locale
availability surprises.

## 11. Out of scope for v1

Ships with Serverpod 3.5.

- **PostgreSQL extensions.** No pgvector, PostGIS, or others beyond what
  Zonky's stock binaries include. **Note**: the default Serverpod project
  template uses `pgvector/pgvector:pg16`, so this package cannot be a
  drop-in replacement for newly-created projects until pgvector lands. The
  intended path: ship pgvector-only `.so/.dylib/.dll` artifacts compiled
  against the pinned Zonky PG version, fetched on demand. Tracked
  separately for v1.1.
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

- Unit tests: URL construction, sha verification, config-block rewrite
  (idempotence + preservation of unmanaged lines).
- Integration matrix on each (OS, arch) tuple in CI. Spike measurements on
  macOS-amd64 + residential broadband set the budgets:
  1. **Cold network** (empty binary cache): target < 90 s. Spike: 75 s
     (20 s download, 40 s extract, 14 s initdb). Network-bound; CI tunes
     by mirroring Maven internally.
  2. **Cold local** (binaries cached, no cluster): target < 5 s. Spike: 2.5 s
     (initdb dominates).
  3. **Warm** (binaries + cluster cached): target < 2 s. Spike: 0.9 s.
  4. UDS round-trip `SELECT 1`.
  5. TCP round-trip `SELECT 1`.
  6. Hard-kill PG process; restart succeeds via orphan cleanup.
  7. Hard-kill Dart parent; restart succeeds without manual cleanup.
  8. `reset()` produces a clean cluster.
  9. Two parallel `start()` calls share the binary cache safely.
  10. Idempotent `start()`: second call returns same handle, no second PG.
- **macOS arch check on every PG bump:** `lipo -archs <cache>/.../bin/postgres`
  must show both `x86_64` and `arm64`. If not, flag in release notes or pick
  a different patch version.
- Benchmarks: cold start, warm start, query latency vs. Docker `postgres:16`.
