import 'package:serverpod/serverpod.dart';

const _queryCreateMigrations =
    'CREATE TABLE IF NOT EXISTS "serverpod_migrations" (\n'
    '    "module" text,\n'
    '    "version" text,\n'
    '    "priority" integer,\n'
    '    CONSTRAINT serverdpod_migrations_idx UNIQUE("module")\n'
    ');\n';

const _queryGetMigrations =
    'SELECT * from "serverpod_migrations ORDER BY "priority", "module";';

/// The migration manager handles migrations of the database.
class MigrationManager {
  /// Initializing the [MigrationManager] by loading the current version
  /// from the database and available migrations.
  Future<void> initialize(Session session) async {
    // Create migrations table if missing
    await session.db.query(_queryCreateMigrations);

    // Get installed versions
    var versions = <MigrationVersion>[];
    var result = await session.db.query(_queryGetMigrations);
    for (var row in result) {
      assert(row.length == 3);
      versions.add(
        MigrationVersion(
          module: row[0],
          version: row[1],
          priority: row[2],
        ),
      );
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
  });

  /// The name of the module associated with the migration.
  final String module;

  /// The name of the version. Should correspond to the name of the
  /// migration directory.
  final String version;

  /// The priority of the migration. Migrations with lower priority will be
  /// applied first.
  final int priority;
}

/// Represents a migration from one version of the database to
/// the next.
class Migration {
  /// Creates a new migration description.
  Migration({
    required this.version,
    required this.sqlDefinition,
    required this.sqlMigration,
  });

  /// The name of the version. Should correspond to the name of the
  /// migration directory.
  final String version;

  /// The SQL to run to migrate to the next version.
  final String sqlMigration;

  /// The SQL to run to create the database from scratch.
  final String sqlDefinition;
}
