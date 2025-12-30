import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/migrations/migration_registry.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// {@template rebase_migration_impl}
/// Rebase migration implementation
/// {@endtemplate}
class RebaseMigrationRunner {
  /// {@macro rebase_migration_impl}
  const RebaseMigrationRunner({
    this.onto,
    this.check = false,
    this.force = false,
  });

  /// onto
  final String? onto;

  /// check
  final bool check;

  /// force
  final bool force;

  /// Default branch
  static const defaultBranch = 'main';

  /// Execute the runner
  Future<bool> run(GeneratorConfig config) async {
    final migrationRegistry = await _getMigrationRegistry(config);
    final baseMigrationId = getBaseMigrationId(migrationRegistry);
    ensureBaseMigration(migrationRegistry, baseMigrationId);

    return check
        ? checkMigration(migrationRegistry, baseMigrationId)
        : rebaseMigration(migrationRegistry, baseMigrationId);
  }

  /// Rebase the migration
  Future<bool> rebaseMigration(
    MigrationRegistry migrationRegistry,
    String baseMigrationId,
  ) async {
    return true;
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

    // Move all migration folders since base migration to backup directory
    for (final migration in sinceBaseMigration) {
      final migrationDir = Directory(
        path.join(
          migrationGenerator.migrationRegistry.moduleMigrationDirectory.path,
          migration,
        ),
      );
      final backupMigrationDir = Directory(
        path.join(backupDirectory.path, migration),
      );
      // Ensure back up directory is empty
      if (backupMigrationDir.existsSync() &&
          backupMigrationDir.listSync().isNotEmpty) {
        log.error('Backup directory is not empty: ${backupMigrationDir.path}');
        throw ExitException(ExitException.codeError);
      }

      migrationDir.renameSync(path.join(backupDirectory.path, migration));
    }

    return backupDirectory;
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

    return getIncomingMigration(registryFile);
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
  Future<MigrationRegistry> _getMigrationRegistry(
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

    final generator = MigrationGenerator(
      directory: serverDirectory,
      projectName: projectName,
    );

    return generator.migrationRegistry;
  }

  /// Check if the migration [file] has conflicts
  bool hasConflicts(File file) {
    const conflictMarker = '<<<<<<<';
    final content = file.readAsStringSync();
    return content.contains(conflictMarker);
  }

  /// Retrieve the incoming migration in a [registryFile]
  String getIncomingMigration(File registryFile) {
    // Check if the registry file has conflicts
    if (!hasConflicts(registryFile)) {
      log.error(
        'Migration registry file has no conflicts. '
        'Please ensure --onto is provided if you want to rebase onto a specific migration.',
      );
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    // Get the incoming migration in the conflict marker
    final content = registryFile.readAsStringSync();
    final incomingMigration = content.split('=======').last;
    return incomingMigration.split('>>>>>>>').first.trim();
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
