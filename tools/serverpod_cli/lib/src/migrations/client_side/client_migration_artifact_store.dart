import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_database/serverpod_database.dart';
// ignore: implementation_imports
import 'package:serverpod_database/src/definition/definition_normalizer.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'client_migration_dart_emitter.dart';

/// File-system [MigrationArtifactStore] for the Dart client package: JSON and
/// generated [migration.dart] files under [lib/migrations/].
class ClientMigrationArtifactStore implements MigrationArtifactStoreWriter {
  ClientMigrationArtifactStore({required this.clientPackageRoot})
    : _projectDirectory = clientPackageRoot;

  static const _dartEmitter = ClientMigrationDartEmitter();

  final Directory _projectDirectory;

  /// The client package root (contains pubspec and `lib/migrations/` directory).
  final Directory clientPackageRoot;

  Directory get _migrationsBase =>
      MigrationConstants.clientMigrationsBaseDirectory(_projectDirectory);

  @override
  Future<List<String>> listVersions() async {
    if (!await _migrationsBase.exists()) {
      return [];
    }
    return await _migrationsBase
          .list()
          .where((entity) => entity is Directory)
          .cast<Directory>()
          .map((dir) => path.basename(dir.path))
          .toList()
      ..sort();
  }

  @override
  Future<MigrationVersionDefinition?> readVersionDefinition(
    String version,
  ) async {
    var versionDir = MigrationConstants.clientMigrationVersionDirectory(
      _projectDirectory,
      version,
    );
    if (!await versionDir.exists()) {
      return null;
    }

    var definition = await _readRequiredProtocolFile<DatabaseDefinition>(
      _definitionJsonPath(version),
    );
    var migration = await _readRequiredProtocolFile<DatabaseMigration>(
      _migrationJsonPath(version),
    );
    return MigrationVersionDefinition(
      version: version,
      definition: normalizeDefinitionToV2(definition),
      projectDefinition: normalizeDefinitionToV2(
        await _readRequiredProtocolFile<DatabaseDefinition>(
          _definitionProjectJsonPath(version),
        ),
      ),
      migration: definition.schemaVersion < 2
          ? normalizeMigrationToV2(migration, definition)
          : migration,
    );
  }

  @override
  Future<void> writeVersion(MigrationVersionArtifacts artifacts) async {
    var versionDir = MigrationConstants.clientMigrationVersionDirectory(
      _projectDirectory,
      artifacts.version,
    );
    if (await versionDir.exists()) {
      throw MigrationVersionAlreadyExistsException(
        directoryPath: versionDir.path,
      );
    }
    await versionDir.create(recursive: true);
    await _writeFile(
      _definitionProjectJsonPath(artifacts.version),
      _encode(artifacts.projectDefinition),
    );
    await _writeFile(
      _definitionJsonPath(artifacts.version),
      _encode(artifacts.definition),
    );
    await _writeFile(
      _migrationJsonPath(artifacts.version),
      _encode(artifacts.migration),
    );
    final migrationFile = File(
      path.join(versionDir.path, 'migration.dart'),
    );
    await migrationFile.writeAsString(
      _dartEmitter.emitMigrationPart(
        moduleName: artifacts.projectDefinition.moduleName,
        version: artifacts.version,
        migrationSql: artifacts.migrationSql,
        definitionSql: artifacts.definitionSql,
      ),
    );
  }

  @override
  Future<void> writeVersionRegistry(List<String> versions) async {
    var registryFile = path.join(
      _migrationsBase.path,
      'migration_registry.dart',
    );
    await _migrationsBase.create(recursive: true);
    await File(registryFile).writeAsString(_dartEmitter.emitRegistry(versions));
  }

  @override
  Future<void> writeRepairMigration(RepairMigration repairMigration) {
    throw UnsupportedError('Repair migrations are not used on the client');
  }

  File _definitionJsonPath(String v) => File(
    path.join(
      MigrationConstants.clientMigrationVersionDirectory(
        _projectDirectory,
        v,
      ).path,
      'definition.json',
    ),
  );

  File _definitionProjectJsonPath(String v) => File(
    path.join(
      MigrationConstants.clientMigrationVersionDirectory(
        _projectDirectory,
        v,
      ).path,
      'definition_project.json',
    ),
  );

  File _migrationJsonPath(String v) => File(
    path.join(
      MigrationConstants.clientMigrationVersionDirectory(
        _projectDirectory,
        v,
      ).path,
      'migration.json',
    ),
  );
}

Future<T> _readRequiredProtocolFile<T>(File file) async {
  return Protocol().decode<T>(await _readRequiredFile(file));
}

Future<String> _readRequiredFile(File file) async {
  if (!await file.exists()) {
    throw Exception('Required migration artifact is missing: ${file.path}');
  }
  return file.readAsString();
}

String _encode<T>(T value) {
  return SerializationManager.encode(value, formatted: true);
}

Future<void> _writeFile(File file, String contents) async {
  await file.create(recursive: true);
  await file.writeAsString(contents);
}
