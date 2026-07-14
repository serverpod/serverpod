import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_database/embedded.dart';
import 'package:serverpod_shared/serverpod_shared.dart' show PasswordManager;
import 'package:serverpod_test/src/test_database_manager.dart';

/// An ephemeral database for a test group or suite.
///
/// Backends differ: PostgreSQL is created empty on the project postmaster;
/// SQLite records a per-group file path (the file appears when the server
/// migrates). Callers apply schema and decide whether to [drop].
abstract interface class EphemeralTestDatabase {
  /// Identifier for this instance (PostgreSQL database name, or the token
  /// embedded in the SQLite file name).
  String get name;

  /// Tears down this database: `DROP DATABASE` for PostgreSQL, or deleting the
  /// SQLite file and its WAL/SHM/journal sidecars.
  Future<void> drop();

  /// Provisions an ephemeral database for the project's configured backend.
  ///
  /// - PostgreSQL: creates an empty database on the (embedded) postmaster.
  /// - SQLite: returns a handle for the per-group file path used later by
  ///   [drop] (nothing is created here).
  /// - No database / unsupported config: `null`.
  ///
  /// The embedded postmaster, when used, is left running for other suites in
  /// the same process.
  ///
  /// [serverDirectory] is the server package root used to load
  /// config/passwords and to resolve relative paths. [configOverride] matches
  /// [Serverpod]'s override hook and is applied before reading the database
  /// config (still without any per-test name swap).
  static Future<EphemeralTestDatabase?> create({
    required String runMode,
    required String databaseName,
    required Directory serverDirectory,
    ServerpodConfig Function(ServerpodConfig)? configOverride,
  }) async {
    final database = resolveProjectDatabaseConfig(
      runMode: runMode,
      serverDirectory: serverDirectory.path,
      configOverride: configOverride,
    );
    return switch (database) {
      PostgresDatabaseConfig() => _PostgresEphemeralTestDatabase.create(
        database: database,
        databaseName: databaseName,
        serverDirectory: serverDirectory,
      ),
      SqliteDatabaseConfig() => _SqliteEphemeralTestDatabase.create(
        database: database,
        databaseName: databaseName,
        serverDirectory: serverDirectory,
      ),
      _ => null,
    };
  }

  /// Loads the project's database config the way [Serverpod] would (run mode,
  /// passwords, and an optional [configOverride]) but without any per-test
  /// name swap, so the shared postmaster is launched against the project
  /// database.
  static DatabaseConfig? resolveProjectDatabaseConfig({
    required String runMode,
    String? serverDirectory,
    ServerpodConfig Function(ServerpodConfig)? configOverride,
  }) {
    final passwords = PasswordManager(runMode: runMode).loadPasswords(
      serverDir: serverDirectory,
    );
    var config = ServerpodConfig.load(
      runMode,
      null,
      passwords,
      serverDir: serverDirectory,
    );
    config = configOverride?.call(config) ?? config;
    return config.database;
  }

  /// Per-group SQLite file path derived from [original] by inserting
  /// [databaseName] (e.g. `db/test.db` → `db/sp_test_<token>.db`).
  /// Relative paths stay relative so the SQLite adapter can anchor them
  /// against the server directory.
  ///
  /// Throws a [StateError] for `:memory:`: an in-memory database is private to
  /// each connection, so it cannot back a test server.
  static String sqliteFilePath(String original, String databaseName) {
    if (original == ':memory:') {
      throw StateError(
        "SQLite ':memory:' databases are not supported in tests; "
        'configure a file-backed database instead.',
      );
    }
    return p.join(
      p.dirname(original),
      '$databaseName${p.extension(original)}',
    );
  }
}

final class _PostgresEphemeralTestDatabase implements EphemeralTestDatabase {
  _PostgresEphemeralTestDatabase({
    required this.name,
    required TestDatabaseManager manager,
  }) : _manager = manager;

  @override
  final String name;

  final TestDatabaseManager _manager;

  /// Embedded postmasters launched while provisioning, keyed by data directory.
  /// Cached for the process lifetime so every consumer shares one instance -
  /// otherwise the first caller that stopped it would strand the rest. Never
  /// stopped here; reclaimed when the test process exits.
  static final Map<String, ResolvedEmbeddedPostgres> _sharedEmbeddedPostgres =
      {};

  static Future<_PostgresEphemeralTestDatabase> create({
    required PostgresDatabaseConfig database,
    required String databaseName,
    required Directory serverDirectory,
  }) async {
    final connectivity = await _resolveConnectivity(
      database,
      baseDirectory: serverDirectory,
    );
    final manager = TestDatabaseManager(connectivity);
    await manager.createEmptyDatabase(databaseName);
    return _PostgresEphemeralTestDatabase(
      name: databaseName,
      manager: manager,
    );
  }

  @override
  Future<void> drop() => _manager.dropDatabase(name);

  /// Starts or attaches the embedded postmaster for [database] when it has a
  /// `dataPath`, caching by data directory. Returns the resolved coordinates,
  /// or [database] itself for an externally-managed server.
  static Future<PostgresDatabaseConfig> _resolveConnectivity(
    PostgresDatabaseConfig database, {
    required Directory baseDirectory,
  }) async {
    if (database.dataPath == null) return database;

    final key = '${baseDirectory.path}|${database.dataPath}';
    final existing = _sharedEmbeddedPostgres[key];
    if (existing != null) return existing.connectivity;

    final resolved = await startOrAttachEmbeddedPostgres(
      database,
      baseDirectory: baseDirectory,
    );
    if (resolved != null) {
      _sharedEmbeddedPostgres[key] = resolved;
      return resolved.connectivity;
    }
    return database;
  }
}

final class _SqliteEphemeralTestDatabase implements EphemeralTestDatabase {
  _SqliteEphemeralTestDatabase({
    required this.name,
    required String filePath,
  }) : _filePath = filePath;

  @override
  final String name;

  /// Absolute path to the per-group SQLite file (sidecars share this prefix).
  final String _filePath;

  /// Returns a drop-handle for the per-group file. The file itself is created
  /// later when the server migrates.
  static _SqliteEphemeralTestDatabase create({
    required SqliteDatabaseConfig database,
    required String databaseName,
    required Directory serverDirectory,
  }) {
    final path = EphemeralTestDatabase.sqliteFilePath(
      database.filePath,
      databaseName,
    );
    final absolute = p.isAbsolute(path)
        ? path
        : p.join(serverDirectory.path, path);
    return _SqliteEphemeralTestDatabase(
      name: databaseName,
      filePath: absolute,
    );
  }

  @override
  Future<void> drop() async {
    for (final suffix in const ['', '-wal', '-shm', '-journal']) {
      final file = File('$_filePath$suffix');
      if (file.existsSync()) file.deleteSync();
    }
  }
}
