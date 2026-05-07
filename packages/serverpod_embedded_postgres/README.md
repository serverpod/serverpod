# serverpod_embedded_postgres

Runs a real PostgreSQL server as a child process for Serverpod local
development. Same PG dialect as production, no Docker dependency, no TCP
port allocation by default.

> **Status: scaffolding.** The public API surface and exception hierarchy
> are stable; the runtime is not yet implemented. Track the implementation
> phases in `docs/design/serverpod_embedded_postgres_spec.md`.

## Use

```dart
import 'dart:io';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';

final pg = await EmbeddedPostgres.start(
  EmbeddedPostgresOptions(
    dataDir: Directory('.serverpod/pgdata'),
    databaseName: 'projectname',
  ),
);

// Hand directly to package:postgres:
final conn = await Connection.open(pg.endpoint);
await conn.execute('SELECT 1');

await pg.stop();
```

## Design

See `docs/design/serverpod_embedded_postgres_spec.md` for goals, transport
choice (UDS by default), binary acquisition (Zonky JARs from Maven
Central), supervisor lifecycle, error model, and verification plan.
