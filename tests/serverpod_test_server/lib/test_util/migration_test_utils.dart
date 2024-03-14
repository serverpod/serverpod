import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/migrations/migration_registry.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod/protocol.dart' as serverProtocol;

abstract class MigrationTestUtils {
  static Future<void> createInitialState({
    required List<Map<String, String>> migrationProtocols,
    String tag = 'test',
  }) async {
    for (var protocols in migrationProtocols) {
      var exitCode =
          await createMigrationFromProtocols(protocols: protocols, tag: tag);

      assert(
        exitCode == 0,
        'Failed to create migration.',
      );
    }

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

    var exitCode = await _runProcess(
      'serverpod',
      arguments: [
        'create-migration',
        '--tag',
        tag,
        if (force) '--force',
        '--verbose',
        '--no-analytics',
      ],
    );

    // Ensures that another migration is never created with the same millisecond.
    await Future.delayed(Duration(milliseconds: 2));

    return exitCode;
  }

  static String readMigrationRegistryFile() {
    var migrationRegistryFile = File(path.join(
      _migrationsProjectDirectory().path,
      'migration_registry.txt',
    ));

    return migrationRegistryFile.readAsStringSync();
  }

  static MigrationRegistry loadMigrationRegistry() {
    return MigrationRegistry.load(
      _migrationsProjectDirectory(),
    );
  }

  static Future<void> migrationTestCleanup({
    String? resetSql,
    required Client serviceClient,
  }) async {
    removeAllTaggedMigrations();
    removeRepairMigration();
    _removeMigrationTestProtocolFolder();
    _recreateMigrationRegistryFile();
    if (resetSql != null) {
      await _resetDatabase(resetSql: resetSql, serviceClient: serviceClient);
    }
    await _setDatabaseMigrationToLatestInRegistry(serviceClient: serviceClient);
  }

  static void _recreateMigrationRegistryFile() {
    var migrationRegistry =
        MigrationRegistry.load(_migrationsProjectDirectory());
    migrationRegistry.write();
  }

  static void removeRepairMigration() {
    var repairMigrationDirectory = _repairMigrationDirectory();
    if (repairMigrationDirectory.existsSync()) {
      repairMigrationDirectory.deleteSync(recursive: true);
    }
  }

  static void removeAllTaggedMigrations() {
    for (var model in _migrationsProjectDirectory().listSync()) {
      if (model is Directory) {
        if (path.basename(model.path).contains('-')) {
          model.deleteSync(recursive: true);
        }
      }
    }
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
        '--logging',
        'verbose',
      ],
    );
  }

  static Future<int> runApplyRepairMigration() async {
    return await _runProcess(
      'dart',
      arguments: [
        'run',
        'bin/main.dart',
        '--apply-repair-migration',
        '--role',
        'maintenance',
        '--mode',
        'production',
        '--logging',
        'verbose',
      ],
    );
  }

  static Future<int> runApplyBothRepairMigrationAndMigrations() async {
    return await _runProcess(
      'dart',
      arguments: [
        'run',
        'bin/main.dart',
        '--apply-repair-migration',
        '--apply-migrations',
        '--role',
        'maintenance',
        '--mode',
        'production',
        '--logging',
        'verbose',
      ],
    );
  }

  static Future<int> runCreateRepairMigration({
    String tag = 'test',
    bool force = false,
    String? targetVersion,
  }) async {
    return await _runProcess(
      'serverpod',
      arguments: [
        'create-repair-migration',
        '--tag',
        tag,
        '--mode',
        'production',
        if (targetVersion != null) ...['--version', targetVersion],
        if (force) '--force',
        '--verbose',
        '--no-analytics',
      ],
    );
  }

  static File? tryLoadRepairMigrationFile() {
    var repairMigrationDirectory = _repairMigrationDirectory();
    if (!repairMigrationDirectory.existsSync()) {
      return null;
    }

    var repairMigrationFiles = repairMigrationDirectory.listSync();
    if (repairMigrationFiles.isEmpty) {
      return null;
    }

    return repairMigrationFiles.first as File;
  }

  static Directory _migrationProtocolTestDirectory() => Directory(path.join(
        Directory.current.path,
        'lib',
        'src',
        'protocol',
        'migration_test_protocol_files',
      ));

  static Directory _repairMigrationDirectory() => Directory(path.join(
        Directory.current.path,
        'repair-migration',
      ));

  static Directory _migrationsProjectDirectory() => Directory(path.join(
        Directory.current.path,
        'migrations',
      ));

  static void _removeMigrationTestProtocolFolder() {
    var protocolDirectory = _migrationProtocolTestDirectory();
    if (protocolDirectory.existsSync()) {
      protocolDirectory.deleteSync(recursive: true);
    }
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
    var migrationRegistry = loadMigrationRegistry();

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
