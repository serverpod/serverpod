import '../migration_artifacts.dart';

/// A [MigrationArtifactStore] backed by a fixed list that is used to apply
/// [MigrationVersionSql] instances at runtime.
class RuntimeListMigrationArtifactStore
    implements MigrationArtifactStoreReader {
  /// Creates a store from the given [migrations] (same [moduleName] for all).
  RuntimeListMigrationArtifactStore(
    this.migrations, {
    required this.moduleName,
  }) : _byVersion = {for (final m in migrations) m.version: m},
       assert(
         migrations.isEmpty ||
             migrations.every((m) => m.moduleName == moduleName),
         'All migrations must be from the "$moduleName" module',
       );

  /// Migrations in ascending version order.
  final List<MigrationVersionSql> migrations;

  /// The module for all [migrations] (and placeholder definitions).
  final String moduleName;

  /// A map of migrations by version.
  final Map<String, MigrationVersionSql> _byVersion;

  @override
  Future<List<String>> listVersions() async {
    return migrations.map((m) => m.version).toList();
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
