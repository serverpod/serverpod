import 'dart:collection';

import '../migration_artifacts.dart';

/// A [MigrationArtifactStore] backed by a fixed list that is used to apply
/// [MigrationVersionSql] instances at runtime.
class RuntimeListMigrationArtifactStore
    implements MigrationArtifactStoreReader {
  /// Creates a store from the given [migrations] (same [moduleName] for all).
  factory RuntimeListMigrationArtifactStore(
    List<MigrationVersionSql> migrations, {
    required String moduleName,
  }) {
    final data = _buildMigrationData(migrations, moduleName);
    return RuntimeListMigrationArtifactStore._(
      moduleName,
      data.migrations,
      data.byVersion,
    );
  }

  RuntimeListMigrationArtifactStore._(
    this.moduleName,
    this._migrations,
    this._byVersion,
  );

  /// The module for all [migrations] (and placeholder definitions).
  final String moduleName;

  /// Migrations stored in ascending version order.
  final SplayTreeSet<MigrationVersionSql> _migrations;

  /// A map of migrations by version.
  final Map<String, MigrationVersionSql> _byVersion;

  static int _compareMigrations(
    MigrationVersionSql a,
    MigrationVersionSql b,
  ) {
    return a.version.compareTo(b.version);
  }

  static ({
    Map<String, MigrationVersionSql> byVersion,
    SplayTreeSet<MigrationVersionSql> migrations,
  })
  _buildMigrationData(
    List<MigrationVersionSql> migrations,
    String moduleName,
  ) {
    final byVersion = <String, MigrationVersionSql>{};
    final orderedMigrations = SplayTreeSet<MigrationVersionSql>(
      _compareMigrations,
    );
    for (final migration in migrations) {
      if (migration.moduleName != moduleName) {
        throw ArgumentError(
          'All migrations must be from the "$moduleName" module',
        );
      }
      if (byVersion.containsKey(migration.version)) {
        throw ArgumentError(
          'Duplicate migration version: ${migration.version}',
        );
      }
      byVersion[migration.version] = migration;
      orderedMigrations.add(migration);
    }
    return (byVersion: byVersion, migrations: orderedMigrations);
  }

  @override
  Future<List<String>> listVersions() async {
    return _migrations.map((m) => m.version).toList();
  }

  @override
  Future<MigrationVersionSql?> readVersionSql(
    String version,
  ) async {
    return _byVersion[version];
  }

  @override
  Future<RepairMigration?> readRepairMigration() async {
    throw UnsupportedError(
      'This artifact store does not support repair migrations.',
    );
  }

  @override
  Future<String?> loadDefinitionModuleName(String version) async {
    return _byVersion[version]?.moduleName;
  }
}
