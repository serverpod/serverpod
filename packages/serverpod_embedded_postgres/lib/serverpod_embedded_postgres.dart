/// Run a real PostgreSQL server as a child process for Serverpod local dev.
///
/// No Docker, no port conflicts (UDS by default), persistent across
/// restarts. See `docs/design/serverpod_embedded_postgres_spec.md` for the
/// design rationale.
library;

export 'src/embedded_postgres.dart';
export 'src/exceptions.dart';
export 'src/options.dart';
export 'src/transport.dart';
