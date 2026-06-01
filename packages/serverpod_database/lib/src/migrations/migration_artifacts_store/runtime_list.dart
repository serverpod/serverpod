import 'dart:collection';

import 'package:collection/collection.dart';

import '../migration_artifacts.dart';

/// A [MigrationArtifactStore] backed by a fixed list that is used to apply
/// [MigrationVersionSql] instances at runtime.
class RuntimeListMigrationArtifactStore
    implements MigrationArtifactStoreReader {
  /// Creates a store from the given [migrations] (same [moduleName] for all).
  RuntimeListMigrationArtifactStore(
    List<MigrationVersionSql> migrations, {
    required this.moduleName,
  }) : _migrations = SplayTreeSet<MigrationVersionSql>(_compareMigrations) {
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

  static int _compareMigrations(
    MigrationVersionSql a,
    MigrationVersionSql b,
  ) {
    return a.version.compareTo(b.version);
  }

  @override
  Future<List<String>> listVersions() async {
    return _migrations.map((m) => m.version).toList();
  }

  @override
  Future<MigrationVersionSql?> readVersionSql(
    String version,
  ) async {
    return _migrations.firstWhereOrNull((m) => m.version == version);
  }

  @override
  Future<RepairMigration?> readRepairMigration() async {
    throw UnsupportedError(
      'This artifact store does not support repair migrations.',
    );
  }

  @override
  Future<String?> loadDefinitionModuleName(String version) async {
    return _migrations
        .firstWhereOrNull((m) => m.version == version)
        ?.moduleName;
  }
}
