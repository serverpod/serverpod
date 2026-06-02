import 'dart:collection';

import '../migration_artifacts.dart';

/// A [MigrationArtifactStore] backed by a fixed list that is used to apply
/// [MigrationVersionSql] instances at runtime.
class RuntimeListMigrationArtifactStore
    implements MigrationArtifactStoreReader {
  /// Creates a store from the given [migrations] (same [moduleName] for all).
  RuntimeListMigrationArtifactStore(
    List<MigrationVersionSql> migrations, {
    required this.moduleName,
  }) : _byVersion = _buildVersionMap(migrations),
       _migrations = SplayTreeSet<MigrationVersionSql>(_compareMigrations) {
    _migrations.addAll(migrations);
    assert(
      migrations.isEmpty || migrations.every((m) => m.moduleName == moduleName),
      'All migrations must be from the "$moduleName" module',
    );
  }

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

  static Map<String, MigrationVersionSql> _buildVersionMap(
    List<MigrationVersionSql> migrations,
  ) {
    final byVersion = <String, MigrationVersionSql>{};
    for (final migration in migrations) {
      if (byVersion.containsKey(migration.version)) {
        throw ArgumentError('Duplicate migration versions are not allowed.');
      }
      byVersion[migration.version] = migration;
    }
    return byVersion;
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
