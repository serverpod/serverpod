import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/commands/create_migration.dart';
import 'package:serverpod_cli/src/migrations/migration_registry.dart';
import 'package:serverpod_cli/src/migrations/migration_registry_file.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// {@template rebase_migration_impl}
/// Rebase migration implementation
/// {@endtemplate}
class RebaseMigrationRunner {
  /// {@macro rebase_migration_impl}
  RebaseMigrationRunner({
    this.onto,
    this.check = false,
    bool force = false,
    String tag = '',
    CreateMigrationRunner? createMigrationRunner,
  }) : createMigrationRunner =
           createMigrationRunner ??
           CreateMigrationRunner(
             force: force,
             tag: tag,
           );

  /// Create migration runner
  final CreateMigrationRunner createMigrationRunner;

  /// onto
  final String? onto;

  /// check
  final bool check;

  /// Default branch
  static const defaultBranch = 'main';

  /// Execute the runner
  Future<bool> run(GeneratorConfig config) async {
    final migrationGenerator = await _getMigrationGenerator(config);
    final migrationRegistry = migrationGenerator.migrationRegistry;
    final baseMigrationId = getBaseMigrationId(migrationRegistry);
    ensureBaseMigration(migrationRegistry, baseMigrationId);

    return check
        ? checkMigration(migrationRegistry, baseMigrationId)
        : rebaseMigration(
            generator: migrationGenerator,
            baseMigrationId: baseMigrationId,
            config: config,
          );
  }

  /// Rebase the migration
  Future<bool> rebaseMigration({
    required MigrationGenerator generator,
    required String baseMigrationId,
    required GeneratorConfig config,
  }) async {
    // Get all migrations before and since base migration
    var registryFile = generator.migrationRegistry.migrationRegistryFile;

    // Split the history into two lists around the base migration
    final List<List<String>> versionPartitions;
    // If there is a merge conflict, extract the migrations
    if (registryFile.hasMergeConflict) {
      // Up to base migration will be the common and incoming migrations
      // Local migrations will be the migrations after the base migration
      final (:common, :local, :incoming) = registryFile.extractMigrations();
      versionPartitions = [
        [...common, ...incoming],
        local,
      ];
    }
    // Split at base migration, since the history should be linear
    else {
      versionPartitions = registryFile.migrations
          .splitBetween((m1, m2) => m1 == baseMigrationId)
          .toList();
    }

    // If there are no migrations since base migration, exit with error
    if (versionPartitions.length < 2) {
      log.error('No migrations since base migration: $baseMigrationId');
      throw ExitException(ExitException.codeError);
    }

    // If there are more than two version partitions, i.e. multiple instances of base migration
    // exit with error
    if (versionPartitions.length > 2) {
      log.error('Multiple instances of base migration: $baseMigrationId');
      throw ExitException(ExitException.codeError);
    }

    final [toBase, since] = versionPartitions;

    // Backup migrations
    final backupDirectory = backupMigrations(
      generator,
      baseMigrationId,
      since,
    );
    final backupRegistryFile = registryFile.content;

    // Update the migration registry file with the migrations up to the base migration
    await generator.migrationRegistry.migrationRegistryFile.update(toBase);

    String? newMigration;
    // Create new migration
    try {
      newMigration = await createMigrationRunner.createMigration(
        generator: generator,
        config: config,
      );
    } on Exception catch (e) {
      // Rollback the migrations by copying from backup directory to migration directory
      moveMigrations(
        migrations: since,
        source: backupDirectory,
        destination: generator.migrationRegistry.moduleMigrationDirectory,
      );
      backupDirectory.deleteSync(recursive: true);
      // Rollback the migration registry file
      registryFile.file.writeAsStringSync(backupRegistryFile);
      log
        ..error('Rebase failed. Changes reverted.')
        ..debug(e.toString());
      throw ExitException(ExitException.codeError);
    }

    final migrationCreated = newMigration != null;
    // If a new migration was created, change the backup folder name to include the new migration name
    if (migrationCreated) {
      final renamedBackupDir = backupDirectory.renameSync(
        path.join(
          backupDirectory.parent.path,
          '.deleted_by_rebase_migration_onto_${baseMigrationId}_with_$newMigration',
        ),
      );

      log
        ..debug('Previous migrations backed up to: ${renamedBackupDir.path}')
        ..debug('Rebased unto: $baseMigrationId with migration: $newMigration')
        ..info('✅ Rebase complete');
    }
    return migrationCreated;
  }

  /// Backup the migrations [sinceBaseMigration] given the [baseMigrationId] and
  /// the [migrationGenerator]
  ///
  /// Returns the backup directory
  Directory backupMigrations(
    MigrationGenerator migrationGenerator,
    String baseMigrationId,
    List<String> sinceBaseMigration,
  ) {
    // Get backup directory
    final backupDirectory = createBackupDirectory(
      migrationGenerator,
      baseMigrationId,
    );
    final source =
        migrationGenerator.migrationRegistry.moduleMigrationDirectory;

    // Move all migration folders since base migration to backup directory
    moveMigrations(
      migrations: sinceBaseMigration,
      source: source,
      destination: backupDirectory,
    );

    return backupDirectory;
  }

  /// Move the migrations [migrations] from [source] to [destination]
  void moveMigrations({
    required List<String> migrations,
    required Directory source,
    required Directory destination,
  }) {
    for (final migration in migrations) {
      final migrationDir = Directory(path.join(source.path, migration));
      final destinationMigrationDir = Directory(
        path.join(destination.path, migration),
      );
      // Ensure backup directory does not exist
      if (destinationMigrationDir.existsSync()) {
        log.error(
          'Backup directory already exists: ${destinationMigrationDir.path}',
        );
        throw ExitException(ExitException.codeError);
      }

      migrationDir.renameSync(path.join(destination.path, migration));
    }
  }

  /// Check the migrations to ensure there is only one migration after the base migration
  /// If there is more than one migration, exit with error
  ///
  Future<bool> checkMigration(
    MigrationRegistry migrationRegistry,
    String baseMigrationId,
  ) async {
    // Get all migrations after base migration
    final baseMigrationIndex = migrationRegistry.versions.indexOf(
      baseMigrationId,
    );
    final migrationsAfterBaseMigration = migrationRegistry.versions.sublist(
      baseMigrationIndex + 1,
    );

    /// If there is more than one migration, exit with error
    if (migrationsAfterBaseMigration.length > 1) {
      log.error('There is more than one migration after the base migration.');
      throw ExitException(ExitException.codeError);
    }

    /// If there is no migration, exit with error
    if (migrationsAfterBaseMigration.isEmpty) {
      log.error('There is no migration after the base migration.');
      throw ExitException(ExitException.codeError);
    }

    ///  Check that migration timestamp is after the base migration timestamp
    final baseMigrationTimestamp = getMigrationTimestamp(baseMigrationId);
    final migrationTimestamp = getMigrationTimestamp(
      migrationsAfterBaseMigration.first,
    );
    if (migrationTimestamp <= baseMigrationTimestamp) {
      log.error(
        'Migration timestamp is not after the base migration timestamp.',
      );
      throw ExitException(ExitException.codeError);
    }

    log.info('There is only one migration after the base migration.');
    return true;
  }

  /// Ensure that the [baseMigrationId] exists in the [migrationRegistry]
  ///
  /// Throws [ExitException] if the [baseMigrationId] does not exist.
  @visibleForTesting
  void ensureBaseMigration(
    MigrationRegistry migrationRegistry,
    String baseMigrationId,
  ) {
    if (!migrationRegistry.versions.contains(baseMigrationId)) {
      log.error('Base migration $baseMigrationId does not exist.');
      throw ExitException(ExitException.codeError);
    }
  }

  /// Get the migration timestamp from a migration ID
  @visibleForTesting
  int getMigrationTimestamp(String migrationId) {
    final timestampString = migrationId.split('-').firstOrNull;
    if (timestampString == null) {
      log.error('Malformed migration ID: $migrationId');
      throw ExitException(ExitException.codeError);
    }

    final timestamp = int.tryParse(timestampString);
    if (timestamp == null) {
      log.error('Malformed migration ID: $migrationId');
      throw ExitException(ExitException.codeError);
    }

    return timestamp;
  }

  /// Get the base migration ID
  String getBaseMigrationId(MigrationRegistry migrationRegistry) {
    // Onto is specified
    if (onto != null) {
      // Validate migration to rebase onto
      validateMigration(onto!, migrationRegistry);

      // Onto is a valid migration ID
      return onto!;
    }

    final registryFile = migrationRegistry.registryFile;
    if (!registryFile.existsSync()) {
      log.error('Migration registry file does not exist.');
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    return getLastIncomingMigration(migrationRegistry.migrationRegistryFile);
  }

  /// Validate the [migration] using the [migrationRegistry]
  @visibleForTesting
  void validateMigration(
    String migration,
    MigrationRegistry migrationRegistry,
  ) {
    // migration is not a valid migration ID
    if (!migrationRegistry.versions.contains(migration)) {
      log.error('Migration $migration does not exist.');
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }
  }

  /// Get the migration registry for the project
  Future<MigrationGenerator> _getMigrationGenerator(
    GeneratorConfig config,
  ) async {
    // Get server directory
    var serverDirectory = Directory(
      path.joinAll(config.serverPackageDirectoryPathParts),
    );

    // Get project name
    var projectName = await getProjectName(serverDirectory);
    if (projectName == null) {
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    return MigrationGenerator(
      directory: serverDirectory,
      projectName: projectName,
    );
  }

  /// Retrieve the last incoming migration in a [registryFile].
  ///
  /// Throws [ExitException] if the [registryFile] has no conflicts.
  String getLastIncomingMigration(MigrationRegistryFile registryFile) {
    if (!registryFile.hasMergeConflict) {
      log.error(
        'Migration registry file has no conflicts. '
        'Please ensure --onto is provided if you want to rebase onto a specific migration.',
      );
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    // Get the incoming migration in the conflict marker
    final migrations = registryFile.extractMigrations();
    final lastIncoming = migrations.incoming.lastOrNull;

    if (lastIncoming == null) {
      log.error(
        'Migration registry file has no incoming migrations in the conflict. '
        'Please ensure --onto is provided if you want to rebase onto a specific migration.',
      );
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    return lastIncoming;
  }

  /// Create backup directory
  Directory createBackupDirectory(
    MigrationGenerator migrationGenerator,
    String baseMigrationId,
  ) {
    final modulePath = migrationGenerator.directory.path;
    return Directory(
      path.join(
        modulePath,
        getBackupDirPath(baseMigrationId),
      ),
    )..createSync(recursive: true);
  }

  /// Get the backup directory path given the [baseMigrationId]
  String getBackupDirPath(String baseMigrationId) =>
      '.dart_tool/migrations/.for_deletion_by_rebase_migration_onto_$baseMigrationId';
}
