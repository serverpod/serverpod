# serverpod_embedded_postgres

Run a real PostgreSQL server as a child process for Serverpod local
development. Same PG dialect as production, no Docker dependency, no TCP
fixed-port conflicts. One Dart call boots the cluster, persistent
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

The first call downloads a Serverpod PostgreSQL bundle (PostgreSQL +
PostGIS + pgvector) from GitHub Releases into the per-user cache
(`~/Library/Caches/serverpod/pg-binaries` on macOS,
`$XDG_CACHE_HOME/serverpod/pg-binaries` on Linux,
`%LOCALAPPDATA%\serverpod\Cache\pg-binaries` on Windows). Subsequent
starts reuse the cache and reach ready in under a second on a warm
cluster. The bundle ships **PostGIS 3.5.4** and **pgvector 0.8.3**, so
`CREATE EXTENSION postgis` / `CREATE EXTENSION vector` work out of the
box. See `tool/build_postgres/` for how the bundles are built and
[PUBLISH.md](PUBLISH.md) for bundle versioning and publishing instructions.

Bundles are downloaded by default; a missing release asset is an error,
not a silent multi-minute source build. Set `SERVERPOD_PG_SOURCE=build`
(or `binarySource: BinarySource.build`) to force a local build - this
requires the native toolchain and is intended for development and CI,
not end users.

## Three transports

**Unix Domain Socket (default when supported).** Trust authentication; the
project directory already gates filesystem access to the socket. PG `chdir`s
to `PGDATA` before binding so `unix_socket_directories = '../run'` lands a
~20-byte path in `sockaddr_un.sun_path`, well under the 104-byte macOS cap
regardless of how deep your project lives. No password is involved.

**TCP loopback (`TcpTransport`).** scram-sha-256 against `127.0.0.1`,
password via [TcpTransport.password] (Serverpod passes `config/passwords.yaml`
`database` here) or a random credential for this launch when omitted. The
default `TcpTransport(port: 0)` gets an ephemeral port; explicit ports are
honored. Port-race collision is retried once before bubbling up. Platforms
without Unix domain socket support select this transport by default.

**Both (`DualTransport`).** One postmaster serving the trusted socket and
scram-sha-256 loopback TCP at the same time. `endpoint` is the socket;
`tcpEndpoint` and `tcpConnectionUri` carry the loopback coordinates for
external tools. Serverpod uses the socket alone without a database password
and this transport with one; it never uses TCP alone. For any transport, a pinned port that another process holds fails
the start with `PortInUseException`; only an ephemeral request is re-allocated.

**The password lives in your configuration, not on disk.** Every start of an
existing cluster that binds TCP sets the superuser's password to the value it
was given, via `postgres --single` before the postmaster is spawned. Rotating
the password is a restart; a cluster initialised without one heals itself.
A process that attaches to a running postmaster passes the same password to
`EmbeddedPostgres.attach` to use `tcpEndpoint`; the socket needs none.

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

## Connect with external tools

From a Serverpod project configured with `database.dataPath`, run:

```sh
serverpod database start
```

The command reads `config/development.yaml` and `config/passwords.yaml`, starts
the embedded database (or joins the one the server already runs), and prints
connection URIs for tools such as `psql`, DBeaver, and DataGrip. With a
database password configured the postmaster also listens on the configured
TCP port; without one only the Unix socket is served. It keeps the database
running until interrupted. The server and this command agree on the listeners
because both derive them from the same configuration, so start order does not
matter. Use `--mode` to select a different configuration or `--server-dir` to
select a server project explicitly.

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
cleaned up; PID-recycled foreign processes are left strictly alone. Pass
`password:` when the postmaster binds TCP and you need `tcpEndpoint`.

## Prefetch for CI

Pre-populate the cache without booting a postmaster:

```sh
dart run serverpod_embedded_postgres:prefetch
dart run serverpod_embedded_postgres:prefetch --version 16.13.0
dart run serverpod_embedded_postgres:prefetch --target linux-x64
```

`--target` lets a CI runner warm the cache for non-host platforms, e.g.
a macOS shared-cache job pre-extracting the `linux-x64` bundle for test
workers to consume. Valid targets: `linux-x64`, `linux-arm64`,
`macos-x64`, `macos-arm64`, `windows-x64`.

## What's exposed

```dart
abstract class EmbeddedPostgres {
  // Boot, coordinate ownership, or reattach.
  static Future<EmbeddedPostgres> start(EmbeddedPostgresOptions opts);
  static Future<EmbeddedStartResult> startOrAttach(
    EmbeddedPostgresOptions opts,
  );
  static Future<EmbeddedPostgres> attach(
    Directory dataDir, {
    String? password,
  });

  // Cache utilities.
  static Future<void> prefetch(
    Version version, {
    String? target,
    BinarySource? source,
  });
  static Directory defaultBinaryCache();

  // Connection handles.
  pg.Endpoint get endpoint;        // package:postgres consumers
  String get connectionString;     // libpq URI for psql, pg_dump, etc.
  Uri get connectionUri;
  pg.Endpoint? get tcpEndpoint;    // loopback, null when socket-only
  Uri? get tcpConnectionUri;

  // Lifecycle.
  Version get version;
  int? get pid;
  bool get isRunning;
  Future<void> stop({Duration timeout = const Duration(seconds: 10)});
  Future<void> reset();            // wipe data dir, ready for fresh init
}
```

The `Transport` sealed class has three variants:

```dart
sealed class Transport { const Transport(); }
final class UnixTransport extends Transport {
  const UnixTransport();
}
final class TcpTransport extends Transport {
  final int port;          // 0 = ephemeral
  final String? password;  // null = generate random for this launch
  const TcpTransport({this.port = 0, this.password});
}
final class DualTransport extends Transport {
  final int port;          // 0 = ephemeral
  final String? password;  // null = generate random for this launch
  const DualTransport({this.port = 0, this.password});
}
```


## What's not included

- **PostgreSQL extensions** beyond PostGIS and pgvector (which the bundle
  ships) - others would need to be added to the build in
  `tool/build_postgres/`.
- **Full PostGIS.** The bundled PostGIS covers Serverpod's supported
  surface (geography types + `ST_Intersects`/`ST_DWithin`/`ST_Distance`/
  `ST_Covers`/`ST_CoveredBy`); raster, the address standardizer, and
  protobuf-backed output are compiled out.
- **Replication / logical decoding / hot standby** - out of scope for
  a dev-loop tool.
- **pg_dump / pgAdmin wrappers** - use `pg_dump` directly against
  `connectionString`.
- **Encryption at rest** - dev tool.
- **Connection pooling** - delegated to `package:postgres`.

## Further documentation

- [PLATFORMS.md](PLATFORMS.md): supported targets and platform-specific
  limitations.
- [tool/build_postgres/README.md](tool/build_postgres/README.md): native build
  recipe and archive invariants.
- [PUBLISH.md](PUBLISH.md): bundle revision, tagging, publication, and recovery
  runbook for maintainers.

## Platform support

See [PLATFORMS.md](PLATFORMS.md) for which `(OS, arch)` tuples have
been verified end-to-end and where Windows currently degrades.
