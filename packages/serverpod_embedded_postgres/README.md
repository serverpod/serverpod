# serverpod_embedded_postgres

Run a real PostgreSQL server as a child process for Serverpod local
development. Same PG dialect as production, no Docker dependency, no TCP
port conflicts by default. One Dart call boots the cluster, persistent
across restarts.

## Quickstart

```dart
import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';

Future<void> main() async {
  final pg = await EmbeddedPostgres.start(
    EmbeddedPostgresOptions(
      dataDir: Directory('.serverpod/pgdata'),
      databaseName: 'projectname',
    ),
  );

  final conn = await Connection.open(pg.endpoint);
  final rs = await conn.execute('SELECT 1');
  print(rs.first.first); // 1

  await conn.close();
  await pg.stop();
}
```

The first call downloads ~30 MB of Zonky's
[`embedded-postgres-binaries`][zonky] from Maven Central into the
per-user cache (`~/Library/Caches/serverpod/pg-binaries` on macOS,
`$XDG_CACHE_HOME/serverpod/pg-binaries` on Linux,
`%LOCALAPPDATA%\serverpod\Cache\pg-binaries` on Windows). Subsequent
starts reuse the cache and reach ready in under a second on a warm
cluster.

[zonky]: https://central.sonatype.com/artifact/io.zonky.test.postgres/embedded-postgres-binaries-bom

## Two transports

**Unix Domain Socket (default).** Trust authentication; the project
directory already gates filesystem access to the socket. PG `chdir`s to
`PGDATA` before binding so `unix_socket_directories = '../run'` lands a
~20-byte path in `sockaddr_un.sun_path`, well under the 104-byte macOS
cap regardless of how deep your project lives.

**TCP loopback (`TcpTransport`).** scram-sha-256 against `127.0.0.1`,
password via [TcpTransport.password] (Serverpod passes `config/passwords.yaml`
`database` here) or a random dev credential when omitted. Persisted to
`<.serverpod>/postgres.password` for warm-restart consistency. The default
`TcpTransport(port: 0)` gets an ephemeral port; explicit ports are honored.
Port-race collision is retried up to 3 times before bubbling up.

```dart
// TCP variant:
final pg = await EmbeddedPostgres.start(
  EmbeddedPostgresOptions(
    dataDir: Directory('.serverpod/pgdata'),
    databaseName: 'projectname',
    transport: const TcpTransport(),
  ),
);

print(pg.endpoint.port);     // some ephemeral port like 49152
print(pg.endpoint.password); // random 32-char string
```

## Detach + attach for cross-VM dev DBs

Set `detach: true` to keep the postmaster alive after your Dart VM
exits, then reconnect from a fresh process:

```dart
// First VM (e.g. `serverpod start --watch`):
await EmbeddedPostgres.start(
  EmbeddedPostgresOptions(
    dataDir: Directory('.serverpod/pgdata'),
    databaseName: 'projectname',
    detach: true,
  ),
);

// Second VM (e.g. `dart test`):
final pg = await EmbeddedPostgres.attach(Directory('.serverpod/pgdata'));
final conn = await Connection.open(pg.endpoint);
// ...
```

`attach()` reads the pidfile and `embedded_postgres_state.json` left by
the original `start()`, verifies the recorded PID is still our
postmaster (cmdline + cwd, NOT just PID - the OS recycles those), and
hands back a fully usable handle. Stale pidfiles (process gone) are
cleaned up; PID-recycled foreign processes are left strictly alone.

## Prefetch for CI

Pre-populate the cache without booting a postmaster:

```sh
dart run serverpod_embedded_postgres:prefetch
dart run serverpod_embedded_postgres:prefetch --version 16.13.0
dart run serverpod_embedded_postgres:prefetch --target linux-amd64
```

`--target` lets a CI runner warm the cache for non-host platforms, e.g.
a macOS shared-cache job pre-extracting the `linux-amd64` bundle for
test workers to consume.

## What's exposed

```dart
abstract class EmbeddedPostgres {
  // Boot or reattach.
  static Future<EmbeddedPostgres> start(EmbeddedPostgresOptions opts);
  static Future<EmbeddedPostgres> attach(Directory dataDir);

  // Cache utilities.
  static Future<void> prefetch(Version version, {String? target});
  static Directory defaultBinaryCache();

  // Connection handles.
  pg.Endpoint get endpoint;        // package:postgres consumers
  String get connectionString;     // libpq URI for psql, pg_dump, etc.
  Uri get connectionUri;

  // Lifecycle.
  Version get version;
  int? get pid;
  bool get isRunning;
  Future<void> stop({Duration timeout = const Duration(seconds: 10)});
  Future<void> reset();            // wipe data dir, ready for fresh init
}
```

The `Transport` sealed class has two variants:

```dart
sealed class Transport { const Transport(); }
final class UnixTransport extends Transport {
  final String? password;
  const UnixTransport({this.password});
}
final class TcpTransport extends Transport {
  final int port;          // 0 = ephemeral
  final String? password;  // null = generate random
  const TcpTransport({this.port = 0, this.password});
}
```

Errors are a sealed hierarchy rooted at `EmbeddedPostgresException`:
`BinaryFetchException`, `BinaryVerificationException`,
`UnsupportedPlatformException`, `InitdbException`,
`StartupTimeoutException`, `CrashedException` (carries `logTail`),
`AttachException`, `StaleClusterException`. `switch` over them
exhaustively.

## What's not included

- **PostgreSQL extensions** beyond what Zonky's stock binaries ship.
  Notably, the default Serverpod project template uses
  `pgvector/pgvector:pg16`, so this package isn't yet a drop-in for
  newly-created projects until pgvector artifacts ship - tracked
  separately for a follow-up release.
- **Replication / logical decoding / hot standby** - out of scope for
  a dev-loop tool.
- **pg_dump / pgAdmin wrappers** - use `pg_dump` directly against
  `connectionString`.
- **Encryption at rest** - dev tool.
- **Connection pooling** - delegated to `package:postgres`.

## Design

See `docs/design/serverpod_embedded_postgres_spec.md` for the full
design, including the rationale for UDS-by-default, binary-source
choice, supervisor lifecycle, error model, and verification plan.

## Platform support

See [PLATFORMS.md](PLATFORMS.md) for which `(OS, arch)` tuples have
been verified end-to-end and where Windows currently degrades.
