import 'dart:io';

import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'embedded_postgres_user_facing_error.dart';

/// Outcome of [startOrAttachEmbeddedPostgres].
class ResolvedEmbeddedPostgres {
  /// Connection coordinates for the resolved postmaster, carrying the
  /// application database name from the source config. Swap
  /// [PostgresDatabaseConfig.name] for `postgres` to run administrative
  /// statements such as `CREATE DATABASE` / `DROP DATABASE`.
  final PostgresDatabaseConfig connectivity;

  /// The postmaster handle, whether launched by this call or attached to.
  final EmbeddedPostgres handle;

  /// Whether this call launched the postmaster, and so owns [stop].
  final bool launched;

  /// Creates a [ResolvedEmbeddedPostgres].
  const ResolvedEmbeddedPostgres({
    required this.connectivity,
    required this.handle,
    required this.launched,
  });

  /// Stops the postmaster when this call launched it, otherwise `null`.
  Future<void> Function()? get stop => launched ? handle.stop : null;
}

/// Launches or attaches to the embedded PostgreSQL postmaster backing
/// [config]'s `dataPath`, returning its resolved connection coordinates.
///
/// Returns `null` when [config] has no `dataPath` (it points at an
/// externally-managed server). Relative `dataPath` values are used as-is
/// (typically already resolved with [DatabaseConfig.withResolvedLocalPath]).
///
/// This pulls `package:serverpod_embedded_postgres` (and its `dart:ffi`
/// dependencies), so it is deliberately NOT exported from the package barrel -
/// it must never reach a web client. Server-side consumers reach it via
/// `package:serverpod_database/embedded.dart`.
Future<ResolvedEmbeddedPostgres?> startOrAttachEmbeddedPostgres(
  PostgresDatabaseConfig config,
) async {
  final dataDir = config._embeddedPostgresDataDir();
  if (dataDir == null) return null;

  final EmbeddedStartResult result;
  try {
    result = await EmbeddedPostgres.startOrAttach(
      EmbeddedPostgresOptions(
        dataDir: dataDir,
        databaseName: config.name,
        username: config.user,
        transport: embeddedTransportFor(config),
        detach: false,
        repairStaleLocks: true,
      ),
    );
  } catch (error, stackTrace) {
    Error.throwWithStackTrace(
      EmbeddedPostgresStartupException(
        formatEmbeddedPostgresFailure(error),
        includeStackTrace: shouldReportEmbeddedPostgresFailure(error),
      ),
      stackTrace,
    );
  }

  return ResolvedEmbeddedPostgres(
    connectivity: config._connectivityFrom(result.handle.endpoint),
    handle: result.handle,
    launched: result.launched,
  );
}

/// How the embedded postmaster for [config] listens.
///
/// Always the Unix socket, plus loopback TCP on [config]'s port when a password
/// is configured. Every process derives the same answer, so start order does
/// not matter.
Transport embeddedTransportFor(PostgresDatabaseConfig config) =>
    config.password.isEmpty
    ? const UnixTransport()
    : DualTransport(port: config.port, password: config.password);

extension on PostgresDatabaseConfig {
  /// The effective PGDATA [Directory] for the embedded PostgreSQL, or `null`
  /// when no `dataPath` is configured.
  Directory? _embeddedPostgresDataDir() {
    final dataPath = this.dataPath?.trim();
    if (dataPath == null || dataPath.isEmpty) return null;
    return Directory(dataPath);
  }

  /// Connection coordinates for [endpoint], falling back to this config's
  /// credentials and database name where the endpoint leaves them unset.
  PostgresDatabaseConfig _connectivityFrom(pg.Endpoint endpoint) =>
      PostgresDatabaseConfig(
        host: endpoint.host,
        port: endpoint.port,
        user: endpoint.username ?? user,
        password: endpoint.password ?? password,
        name: name,
        isUnixSocket: endpoint.isUnixSocket,
      );
}

/// An embedded database startup failure that has already been translated into
/// user-facing guidance.
final class EmbeddedPostgresStartupException implements Exception {
  /// Message that can be shown directly to a Serverpod user.
  final String message;

  /// Whether the original stack trace should be shown for issue reporting.
  final bool includeStackTrace;

  /// Creates a user-facing embedded database startup failure.
  const EmbeddedPostgresStartupException(
    this.message, {
    required this.includeStackTrace,
  });

  @override
  String toString() => message;
}
