/// Helpers for wiring a running embedded Postgres into a Serverpod
/// [DatabaseConfig] or `SERVERPOD_DATABASE_*` env overlay.
///
/// Exposed as a sub-library so consumers that only want to spawn the
/// postmaster (e.g. a generic Dart binary) don't transitively pick up
/// `serverpod_shared`'s config types.
library;

export 'src/serverpod_config_mapping.dart';
