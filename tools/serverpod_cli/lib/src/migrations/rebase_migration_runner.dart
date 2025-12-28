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
    this.ontoBranch,
    this.check = false,
    this.force = false,
  });

  /// onto
  final String? onto;

  /// ontoBranch
  final String? ontoBranch;

  /// check
  final bool check;

  /// force
  final bool force;

  /// Default branch
  static const defaultBranch = 'main';

  /// Execute the runner
  Future<bool> run(GeneratorConfig config) async {
    final migrationRegistry = await _getMigrationRegistry(config);
    final baseMigrationId = await getBaseMigrationId(migrationRegistry);

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
  Future<String> getBaseMigrationId(MigrationRegistry migrationRegistry) async {
    // Get registry file and ensure it exists
    final registryFile = migrationRegistry.registryFile;
    if (!registryFile.existsSync()) {
      log.error('Migration registry file does not exist.');
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    // Onto is specified
    if (onto != null) {
      // Validate migration to rebase onto
      validateMigration(onto!, migrationRegistry);

      // Onto is a valid migration ID
      return onto!;
    }

    // If ontoBranch is specified, return the last migration ID from ontoBranch
    if (ontoBranch != null) {
      final lastMigrationId = getLastMigrationIdFromBranch(
        migrationRegistry,
        ontoBranch!,
      );

      // Validate last migration ID from branch
      validateMigration(lastMigrationId, migrationRegistry);

      return lastMigrationId;
    }

    // If no onto or ontoBranch is specified, return the last migration ID from the default branch
    return getLastMigrationIdFromBranch(migrationRegistry, defaultBranch);
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

    final migrationRegistry = generator.migrationRegistry;
    return migrationRegistry;
  }

  /// Get the last migration ID from [ontoBranch]
  String getLastMigrationIdFromBranch(
    MigrationRegistry migrationRegistry,
    String ontoBranch,
  ) {
    return 'm1';
  }
}
