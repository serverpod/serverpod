/// Server-only entry point for launching embedded PostgreSQL.
///
/// Kept out of the main `serverpod_database.dart` barrel so that web clients
/// never pull `package:serverpod_embedded_postgres` and its `dart:ffi`
/// dependencies into the compile graph. Import this only from server-side code.
library;

export 'src/adapters/postgres/embedded_postgres_resolver.dart';
