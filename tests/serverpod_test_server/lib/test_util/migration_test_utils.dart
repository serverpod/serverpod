import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/migrations/migration_registry.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod/protocol.dart' as serverProtocol;
import 'package:uuid/uuid.dart';

abstract class MigrationTestUtils {
  static Future<void> createInitialState({
    required Map<String, String> protocols,
    String tag = 'test',
  }) async {
    assert(
      await createMigrationFromProtocols(protocols: protocols, tag: tag) == 0,
      'Failed to create migration.',
    );
    assert(
      await runApplyMigrations() == 0,
      'Failed to create migration.',
    );
  }

  static Future<int> createMigrationFromProtocols({
    required Map<String, String> protocols,
    String tag = 'test',
    bool force = false,
  }) async {
    _removeMigrationTestProtocolFolder();
    _migrationProtocolTestDirectory().createSync(recursive: true);

    protocols.forEach((fileName, contents) {
      var protocolFile = File(path.join(
        _migrationProtocolTestDirectory().path,
        '$fileName.yaml',
      ));

      protocolFile.writeAsStringSync(contents);
    });

    var suffixedTag = '$tag-${Uuid().v4()}';
    return await _runProcess(
      'serverpod',
      arguments: [
        'create-migration',
        '--tag',
        suffixedTag,
        if (force) '--force',
      ],
    );
  }

  static Future<MigrationRegistry> loadMigrationRegistry() async {
    return await MigrationRegistry.load(
      _migrationsProjectDirectory(),
    );
  }

  static Future<void> migrationTestCleanup({
    String? resetSql,
    required Client serviceClient,
  }) async {
    removeAllTaggedMigrations();
    _removeMigrationTestProtocolFolder();
    if (resetSql != null) {
      await _resetDatabase(resetSql: resetSql, serviceClient: serviceClient);
    }
    await _removeTaggedMigrationsFromRegistry();
    await _setDatabaseMigrationToLatestInRegistry(serviceClient: serviceClient);
  }

  static void removeAllTaggedMigrations() {
    for (var entity in _migrationsProjectDirectory().listSync()) {
      if (entity is Directory) {
        if (path.basename(entity.path).contains('-')) {
          entity.deleteSync(recursive: true);
        }
      }
    }
  }

  static Future<bool> removeLastMigrationFromRegistry() async {
    var migrationRegistry = await loadMigrationRegistry();
    var lastEntry = migrationRegistry.removeLast();
    if (lastEntry == null) {
      return false;
    }

    await migrationRegistry.write();
    return true;
  }

  static Future<int> runApplyMigrations() async {
    return await _runProcess(
      'dart',
      arguments: [
        'run',
        'bin/main.dart',
        '--apply-migrations',
        '--role',
        'maintenance',
        '--mode',
        'production',
      ],
    );
  }

  static Directory _migrationProtocolTestDirectory() => Directory(path.join(
        Directory.current.path,
        'lib',
        'src',
        'protocol',
        'migration_test_protocol_files',
      ));

  static Directory _migrationsProjectDirectory() => Directory(path.join(
        Directory.current.path,
        'generated',
        'migration',
        'migrations',
        'serverpod_test',
      ));

  static void _removeMigrationTestProtocolFolder() {
    var protocolDirectory = _migrationProtocolTestDirectory();
    if (protocolDirectory.existsSync()) {
      protocolDirectory.deleteSync(recursive: true);
    }
  }

  static Future<void> _removeTaggedMigrationsFromRegistry() async {
    var migrationRegistry = await loadMigrationRegistry();

    var lastMigration = migrationRegistry.getLatest();
    while (lastMigration != null && lastMigration.contains('-')) {
      migrationRegistry.removeLast();
      lastMigration = migrationRegistry.getLatest();
    }

    await migrationRegistry.write();
  }

  static Future<void> _resetDatabase({
    required Client serviceClient,
    required String resetSql,
  }) async {
    await serviceClient.insights.executeSql(resetSql);
  }

  static Future<void> _setDatabaseMigrationToLatestInRegistry({
    required Client serviceClient,
  }) async {
    var migrationRegistry = await loadMigrationRegistry();

    var latestMigration = migrationRegistry.getLatest();

    await serviceClient.insights.executeSql('''
INSERT INTO "${serverProtocol.DatabaseMigrationVersion.t.tableName}"
    ("module", "version", "timestamp")
    VALUES ('serverpod_test', '$latestMigration', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '$latestMigration';
''');
  }

  static Future<int> _runProcess(
    String command, {
    List<String>? arguments,
    Directory? workingDirectory,
  }) async {
    var process = await Process.start(
      command,
      arguments ?? [],
      workingDirectory: workingDirectory?.path ?? Directory.current.path,
    );

    process.stderr.transform(utf8.decoder).listen(print);
    process.stdout.transform(utf8.decoder).listen(print);

    return await process.exitCode;
  }
}
