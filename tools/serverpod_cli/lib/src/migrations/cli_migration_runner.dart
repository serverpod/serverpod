import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/config_info/config_info.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_shared/serverpod_shared.dart' hide ExitException;

/// Runs the project's pending database migrations from outside the pod.
///
/// Reads `config/<runMode>.yaml` and `config/passwords.yaml` from
/// [serverDir], opens a database connection with the same config the
/// pod would use, and applies pending migrations via
/// [MigrationManager]. Returns the list of versions applied (empty if
/// the database was already up to date).
///
/// Does not require a running pod — the database can be migrated
/// while the pod is offline. The resulting database may be
/// inconsistent with the project's protocol; the pod verifies
/// integrity on its next start.
///
/// [moduleName] is passed through to the migration manager as the
/// expected module name; if the migration definition's module name
/// disagrees, the manager logs a warning.
Future<List<String>> applyPendingMigrations({
  required String serverDir,
  required String runMode,
  required String moduleName,
}) async {
  final config = ConfigInfo.fromDir(
    serverDir: serverDir,
    runMode: runMode,
  ).config;
  final dbConfig = config.database;
  if (dbConfig == null) {
    throw StateError('No database configured for run mode "$runMode".');
  }

  final serializationManager = _CliSerializationManager(moduleName);

  // Resolve relative SQLite paths against [serverDir] so the CLI opens
  // the same file the pod will
  final resolvedDbConfig = _resolveDbConfigPaths(dbConfig, serverDir);

  final pool = DatabaseProvider.forDialect(resolvedDbConfig.dialect)
      .createPoolManager(
        serializationManager,
        null,
        resolvedDbConfig,
      );
  await pool.started;

  try {
    // Session and Database have a circular construction dependency:
    // DatabaseConstructor.create needs a session, the session needs a
    // db. We break the cycle by initializing _db post-construction.
    final session = _CliDatabaseSession();
    session._db = DatabaseConstructor.create(
      session: session,
      poolManager: pool,
    );

    final manager = MigrationManager.fromDirectory(
      Directory(serverDir),
      runMode: runMode,
    );
    final applied = await manager.migrateToLatest(session);

    if (applied != null) {
      log.info(
        formatAppliedMigrations(applied),
        type: applied.isEmpty ? TextLogType.normal : TextLogType.success,
      );
    }

    return applied ?? const [];
  } finally {
    await pool.stop();
  }
}

/// Formats the result of a migration run for the CLI logger.
String formatAppliedMigrations(List<String> applied) {
  if (applied.isEmpty) return 'Database is already up to date.';
  final plural = applied.length == 1 ? '' : 's';
  return 'Applied ${applied.length} migration$plural: ${applied.join(", ")}';
}

/// Extracts `--mode` / `-m` from [serverArgs] (the passthrough args
/// that `serverpod start [-- <server-args>]` forwards to the pod), so
/// the CLI applies migrations against the same config the pod will
/// load.
///
/// Hand-rolled rather than using [ArgParser] because the pod accepts
/// many flags the CLI doesn't know about; a strict parser would throw
/// on the first unfamiliar flag and lose the mode. Recognized forms:
/// `--mode <v>`, `--mode=<v>`, `-m <v>`, `-m=<v>`.
///
/// Returns `'development'` when the flag isn't present - matches the
/// pod's `CommandLineArgs.runMode` default.
String runModeFromServerArgs(List<String> serverArgs) {
  for (var i = 0; i < serverArgs.length; i++) {
    final arg = serverArgs[i];
    if (arg == '--mode' || arg == '-m') {
      if (i + 1 < serverArgs.length) return serverArgs[i + 1];
    } else if (arg.startsWith('--mode=')) {
      return arg.substring('--mode='.length);
    } else if (arg.startsWith('-m=')) {
      return arg.substring('-m='.length);
    }
  }
  return 'development';
}

/// Returns [dbConfig] with any relative SQLite [SqliteDatabaseConfig.filePath]
/// resolved against [serverDir]. Non-SQLite configs and already-absolute
/// paths are returned unchanged.
DatabaseConfig _resolveDbConfigPaths(
  DatabaseConfig dbConfig,
  String serverDir,
) {
  if (dbConfig is! SqliteDatabaseConfig) return dbConfig;
  if (p.isAbsolute(dbConfig.filePath)) return dbConfig;
  return SqliteDatabaseConfig(
    filePath: p.normalize(p.join(serverDir, dbConfig.filePath)),
    maxConnectionCount: dbConfig.maxConnectionCount,
  );
}

/// Minimal [DatabaseSerializationManager] stub. The CLI doesn't have
/// access to the project's generated serialization manager, but the
/// migration code path only needs the module-name check.
class _CliSerializationManager extends DatabaseSerializationManager {
  _CliSerializationManager(this._moduleName);

  final String _moduleName;

  @override
  String getModuleName() => _moduleName;

  @override
  Table? getTableForType(Type t) => null;

  @override
  List<TableDefinition> getTargetTableDefinitions() => const [];
}

/// Minimal [DatabaseSession] for CLI-driven SQL execution. No
/// transaction, no logging - the migration manager wraps its work in
/// its own transaction via [MigrationRunner].
class _CliDatabaseSession implements DatabaseSession {
  late Database _db;

  @override
  Database get db => _db;

  @override
  Transaction? get transaction => null;

  @override
  LogQueryFunction? get logQuery => null;

  @override
  LogWarningFunction? get logWarning => null;
}
