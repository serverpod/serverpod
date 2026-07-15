/// Run a real PostgreSQL server as a child process for Serverpod local dev.
///
/// No Docker, no port conflicts (UDS by default), persistent across
/// restarts. See the package README for the runtime and lifecycle contract.
library;

export 'src/binary/binary_source.dart' show BinarySource;
export 'src/embedded_postgres.dart';
export 'src/exceptions.dart';
export 'src/options.dart';
export 'src/transport.dart';
