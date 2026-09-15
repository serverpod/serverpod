import 'dart:io';

import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../interface/database_pool_manager.dart';
import 'embedded_postgres_user_facing_error.dart';
import 'postgres_pool_manager.dart';

/// Outcome of [startOrAttachEmbeddedPostgres].
class ResolvedEmbeddedPostgres {
  /// Connection coordinates for the resolved postmaster, carrying the
  /// application database name from the source config. Swap
  /// [PostgresDatabaseConfig.name] for `postgres` to run administrative
  /// statements such as `CREATE DATABASE` / `DROP DATABASE`.
  final PostgresDatabaseConfig connectivity;

  /// The postmaster handle, whether launched by this call or attached to.
  final EmbeddedPostgres handle;

  /// Whether this call launched the postmaster. Only then does [stop] tear
  /// it down; an attached postmaster belongs to another process.
  final bool launched;

  /// Tells the user that this call launched the postmaster on another TCP port
  /// than configured because another process held it, or `null`.
  final String? portFallbackWarning;

  /// Creates a [ResolvedEmbeddedPostgres].
  const ResolvedEmbeddedPostgres({
    required this.connectivity,
    required this.handle,
    required this.launched,
    this.portFallbackWarning,
  });

  /// Stops the postmaster this call launched, or `null` when it attached to one
  /// another supervisor already owns. Only invoke it for a non-null value.
  Future<void> Function()? get stop => launched ? handle.stop : null;
}

/// Launches or attaches to the embedded PostgreSQL postmaster backing
/// [config]'s `dataPath`, returning its resolved connection coordinates.
///
/// Returns `null` when [config] has no `dataPath` (it points at an
/// externally-managed server). Relative `dataPath` values are used as-is
/// (typically already resolved with [DatabaseConfig.withResolvedLocalPath]).
///
/// A configured port another process holds is swapped for a free one unless
/// [ephemeralPortFallback] is `false`.
///
/// This pulls `package:serverpod_embedded_postgres` (and its `dart:ffi`
/// dependencies), so it is deliberately NOT exported from the package barrel -
/// it must never reach a web client. Server-side consumers reach it via
/// `package:serverpod_database/embedded.dart`.
Future<ResolvedEmbeddedPostgres?> startOrAttachEmbeddedPostgres(
  PostgresDatabaseConfig config, {
  bool ephemeralPortFallback = true,
}) async {
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
        ephemeralPortFallback: ephemeralPortFallback,
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

  final tcpPort = result.handle.tcpEndpoint?.port;
  return ResolvedEmbeddedPostgres(
    connectivity: config._connectivityFrom(result.handle.endpoint),
    handle: result.handle,
    launched: result.launched,
    portFallbackWarning:
        result.launched && tcpPort != null && tcpPort != config.port
        ? 'Port ${config.port} is held by another process, so the embedded '
              'database listens on TCP port $tcpPort instead. Tools set up '
              'for port ${config.port} reach that other process. Stop it or '
              'change the database port in the config.'
        : null,
  );
}

/// The [ResolvedEmbeddedPostgres.portFallbackWarning] of the embedded database
/// [poolManager] launched, or `null`.
String? embeddedPostgresPortFallbackWarning(DatabasePoolManager poolManager) =>
    poolManager is PostgresPoolManager
    ? poolManager.embeddedPostgres?.portFallbackWarning
    : null;

/// How the embedded postmaster for [config] listens.
///
/// The Unix socket, gated by filesystem permissions, is always served (every
/// platform Serverpod 4 runs on has them). Loopback TCP with scram-sha-256
/// is added only when a database password is configured, on [config]'s
/// port, so external tools can connect the way they did against a Docker
/// database.
///
/// Every launcher and attacher in a project derives the same answer from the
/// same configuration, so it does not matter whether the server or
/// `serverpod database start` comes first.
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
