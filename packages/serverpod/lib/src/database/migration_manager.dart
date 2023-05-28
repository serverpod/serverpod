import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;

import '../../protocol.dart';
import '../../serverpod.dart';
import '../generated/protocol.dart' as internal;
import 'analyze.dart';
import 'extensions.dart';

final SerializationManager _serializationManager = internal.Protocol();

const _queryCreateMigrations =
    'CREATE TABLE IF NOT EXISTS "serverpod_migrations" (\n'
    '    "module" text,\n'
    '    "version" text,\n'
    '    "priority" integer,\n'
    '    "timestamp" timestamp without time zone, \n'
    '    CONSTRAINT serverdpod_migrations_idx UNIQUE("module")\n'
    ');\n';

const _queryGetMigrations =
    'SELECT * from "serverpod_migrations" ORDER BY "priority", "module";';

/// The migration manager handles migrations of the database.
class MigrationManager {
  /// List of installed migration versions. Available after [initialize] has
  /// been called.
  final List<MigrationVersion> installedVersions = [];

  /// List of available migration versions as loaded from the migrations
  /// directory. Available after [initialize] has been called.
  final Map<String, List<String>> availableVersions = {};

  /// Initializing the [MigrationManager] by loading the current version
  /// from the database and available migrations.
  Future<void> initialize(Session session) async {
    await session.db.query(_queryCreateMigrations);

    // Get installed versions
    final versions = <MigrationVersion>[];
    final result = await session.db.query(_queryGetMigrations);
    for (final row in result) {
      assert(row.length == 4, 'Invalid ros count');

      final module = row[0] as String;
      final version = row[1] as String;
      final priority = row[2] as int;
      final timestamp = row[3] as DateTime;

      versions.add(
        MigrationVersion(
          module: module,
          version: version,
          priority: priority,
          timestamp: timestamp,
        ),
      );
    }
    installedVersions.addAll(versions);

    // Get available migrations
    final migrationDirectory = Directory(
      path.join(Directory.current.path, 'migrations'),
    );
    final migrationModules = await _listAvailableModules(
      directory: migrationDirectory,
    );

    for (final module in migrationModules) {
      availableVersions[module] = await _listMigrationVersions(
        directory: migrationDirectory,
        module: module,
      );
    }
  }

  /// Returns true if the database structure is up to date. If not, it will
  /// print a warning to stderr.
  Future<bool> verifyDatabaseIntegrity(Session session) async {
    final warnings = <String>[];

    final liveDatabase = await DatabaseAnalyzer.analyze(session.db);
    final targetDatabase =
        session.serverpod.serializationManager.getTargetDatabaseDefinition();

    for (final table in targetDatabase.tables) {
      final liveTable = liveDatabase.findTableNamed(table.name);
      if (liveTable == null) {
        warnings.add('Table "${table.name}" is missing.');
        continue;
      }
      if (!liveTable.like(table)) {
        warnings.add('Table "${table.name}" is not like the target database.');
        continue;
      }
    }
    if (warnings.isNotEmpty) {
      stderr.writeln(
        'WARNING: The database does not match the target database:',
      );
      for (final warning in warnings) {
        stderr.writeln(' - $warning');
      }
    }

    return warnings.isEmpty;
  }

  /// Lists all available modules in the migrations directory.
  List<String> get availableModules => availableVersions.keys.toList();

  /// Returns the latest version of the given module from aviailable migrations.
  String getLatestVersion(String module) {
    final versions = availableVersions[module];
    if (versions == null || versions.isEmpty) {
      throw Exception('No migrations found for module $module.');
    }
    return versions.last;
  }

  /// Returns true if the latest version of a module is installed.
  bool isLatestInstalled(String module) {
    final latest = getLatestVersion(module);
    final installed = installedVersions.firstWhereOrNull(
      (element) => element.module == module,
    );
    if (installed == null) {
      return false;
    }
    return latest == installed.version;
  }

  /// Returns true if any version of the given module is installed.
  bool isAnyInstalled(String module) {
    return getInstalledVersion(module) != null;
  }

  /// Returns the installed version of the given module, or null if no version
  /// is installed.
  String? getInstalledVersion(String module) {
    final installed = installedVersions.firstWhereOrNull(
      (element) => element.module == module,
    );
    if (installed == null) {
      return null;
    }
    return installed.version;
  }

  /// Lists all versions newer than the given version for the given module.
  List<String> getVersionsNewerThan(String module, String version) {
    final versions = availableVersions[module];
    if (versions == null || versions.isEmpty) {
      return [];
    }
    final index = versions.indexOf(version);
    if (index == -1) {
      throw Exception('Version $version not found for module $module.');
    }
    return versions.sublist(index + 1);
  }

  /// Migrates all modules to the latest version.
  Future<void> migrateToLatest(Session session) async {
    for (final module in availableModules) {
      if (!isLatestInstalled(module)) {
        await migrateToLatestModule(session, module);
      }
    }
  }

  /// Migration a single module to the latest version.
  Future<void> migrateToLatestModule(Session session, String module) async {
    if (isLatestInstalled(module)) {
      return;
    }
    if (isAnyInstalled(module)) {
      // Apply all migrations up to this point
      final version = getInstalledVersion(module);
      final newerVersions = getVersionsNewerThan(module, version!);
      for (final newerVersion in newerVersions) {
        final migration = await Migration.load(module, newerVersion);
        try {
          await session.db.execute(migration.sqlMigration);
        } catch (e) {
          stderr
            ..writeln('Failed to apply migration $newerVersion on $module')
            ..writeln('$e');
        }
      }
    } else {
      // Apply definition from last migration
      final latest = getLatestVersion(module);
      final migration = await Migration.load(module, latest);

      try {
        await session.db.execute(migration.sqlDefinition);
      } catch (e) {
        stderr
          ..writeln('Failed to apply definition $latest on $module')
          ..writeln('$e');
      }
    }
  }

  Future<List<String>> _listAvailableModules({
    required Directory directory,
  }) async {
    try {
      final modules = <String>[];
      final entities = directory.listSync();
      for (final entity in entities) {
        if (entity is Directory) {
          modules.add(path.basename(entity.path));
        }
      }
      modules.sort();
      return modules;
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> _listMigrationVersions({
    required Directory directory,
    required String module,
  }) async {
    try {
      final versionDir = Directory(path.join(directory.path, module));

      final versions = <String>[];
      final entities = versionDir.listSync();
      for (final entity in entities) {
        if (entity is Directory) {
          versions.add(path.basename(entity.path));
        }
      }
      versions.sort();
      return versions;
    } catch (e) {
      return [];
    }
  }
}

/// A migration to a version of the database that has been applied.
class MigrationVersion {
  /// Creates a new version.
  MigrationVersion({
    required this.module,
    required this.version,
    required this.priority,
    required this.timestamp,
  });

  /// The name of the module associated with the migration.
  final String module;

  /// The name of the version. Should correspond to the name of the
  /// migration directory.
  final String version;

  /// The priority of the migration. Migrations with lower priority will be
  /// applied first.
  final int priority;

  /// The timestamp of when the migration was applied.
  final DateTime timestamp;

  @override
  String toString() {
    return '$module:$version';
  }
}

/// Represents a migration from one version of the database to
/// the next.
class Migration {
  /// Creates a new migration description.
  Migration({
    required this.version,
    required this.sqlDefinition,
    required this.sqlMigration,
    required this.definition,
    required this.migration,
  });

  /// Loads the specified migration version from the migrations directory.
  static Future<Migration> load(String module, String version) async {
    final migrationDirectory = Directory(
      path.join(Directory.current.path, 'migrations', module, version),
    );

    // Load definition and migration SQL
    final definitionSqlFile = File(
      path.join(migrationDirectory.path, 'definition.sql'),
    );
    final sqlDefinition = await definitionSqlFile.readAsString();

    final migrationSqlFile = File(
      path.join(migrationDirectory.path, 'migration.sql'),
    );
    final sqlMigration = await migrationSqlFile.readAsString();

    // Load definition file
    final definitionJsonFile = File(
      path.join(migrationDirectory.path, 'definition.json'),
    );
    final definitionJson = await definitionJsonFile.readAsString();
    final definition = _serializationManager.decodeWithType(
      definitionJson,
    ) as DatabaseDefinition?;

    // Load migration file
    final migrationJsonFile = File(
      path.join(migrationDirectory.path, 'migration.json'),
    );
    final migrationJson = await migrationJsonFile.readAsString();
    final migration = _serializationManager.decodeWithType(
      migrationJson,
    ) as DatabaseMigration?;

    return Migration(
      version: version,
      sqlDefinition: sqlDefinition,
      sqlMigration: sqlMigration,
      definition: definition!,
      migration: migration!,
    );
  }

  /// The name of the version. Should correspond to the name of the
  /// migration directory.
  final String version;

  /// The SQL to run to migrate to the next version.
  final String sqlMigration;

  /// The SQL to run to create the database from scratch.
  final String sqlDefinition;

  /// The definition of the database.
  final DatabaseDefinition definition;

  /// The migration to apply to the database to get to this version from the
  /// previous version.
  final DatabaseMigration migration;
}
