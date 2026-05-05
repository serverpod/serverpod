import 'dart:io';

import 'package:serverpod_cli/src/config_info/config_info.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Runs the project's pending database migrations from outside the pod.
///
/// Reads `config/<runMode>.yaml` and `config/passwords.yaml` from
/// [serverDir], opens a database connection with the same config the
/// pod would use, and applies pending migrations via
/// [MigrationManager]. Returns the list of versions applied (empty if
/// the database was already up to date).
///
/// [moduleName] is used as the value the migration manager checks
/// against the migration definition to detect mismatched protocol
/// classes; the CLI does not have access to a real serialization
/// manager so it passes the project name and surfaces a warning if it
/// disagrees.
Future<List<String>> applyPendingMigrations({
  required String serverDir,
  required String runMode,
  required String moduleName,
}) async {
  final config = _loadServerpodConfig(
    serverDir: serverDir,
    runMode: runMode,
  );
  final dbConfig = config.database;
  if (dbConfig == null) {
    throw StateError('No database configured for run mode "$runMode".');
  }

  final pool = DatabaseProvider.forDialect(
    dbConfig.dialect,
  ).createPoolManager(_CliSerializationManager(moduleName), null, dbConfig);
  pool.start();

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

/// Whether [error] is a FFI resolver failure
///
/// The CLI may be installed as a `pub global activate` snapshot, that doesn't
/// run build hooks for transitive deps.
bool isMissingNativeAssetError(Object error) {
  if (error is! ArgumentError) return false;
  final s = error.toString();
  return s.contains("Couldn't resolve native function") ||
      s.contains('No available native assets');
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

/// Wraps [ConfigInfo] with a chdir into [serverDir] so it picks up
/// `config/<runMode>.yaml` + `config/passwords.yaml` from the project
/// regardless of the caller's cwd.
///
/// TODO: replace this with a base-directory parameter on
/// [ServerpodConfig.load] / [PasswordManager]. Mutating
/// [Directory.current] is racy with anything else in the isolate that
/// reads cwd while this call is in flight.
ServerpodConfig _loadServerpodConfig({
  required String serverDir,
  required String runMode,
}) {
  final originalCwd = Directory.current;
  Directory.current = Directory(serverDir);
  try {
    return ConfigInfo(runMode).config;
  } finally {
    Directory.current = originalCwd;
  }
}

/// Minimal [DatabaseSerializationManager] stub. The CLI doesn't have
/// access to the project's generated serialization manager, but the
/// migration code path only needs the module-name check; raw-SQL paths
/// don't touch the table-for-type or target-table-definitions methods.
///
/// Load-bearing assumption: [MigrationManager.migrateToLatest] never
/// reads [getTargetTableDefinitions] or [getTableForType]. If that
/// changes (e.g. drift detection over the running schema), this stub
/// will silently report no tables - update both sides together.
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
