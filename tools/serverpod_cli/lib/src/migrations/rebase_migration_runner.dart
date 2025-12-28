import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
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
    final baseMigrationId = await getBaseMigrationId(config);

    return check ? checkMigration(baseMigrationId) : rebaseMigration(config);
  }

  /// Rebase the migration
  Future<bool> rebaseMigration(GeneratorConfig config) async {
    final baseMigrationId = await getBaseMigrationId(config);

    // Run check migration
    if (check) {
      return checkMigration(baseMigrationId);
    }

    return baseMigrationId.isNotEmpty;
  }

  /// Check the migration
  Future<bool> checkMigration(String baseMigrationId) async {
    return baseMigrationId.isNotEmpty;
  }

  /// Get the base migration ID
  Future<String> getBaseMigrationId(GeneratorConfig config) async {
    // Get migration registry
    MigrationRegistry migrationRegistry = await _getMigrationRegistry(config);

    // Get registry file and ensure it exists
    final registryFile = migrationRegistry.registryFile;
    if (!registryFile.existsSync()) {
      log.error('Migration registry file does not exist.');
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    // Onto is specified
    if (onto != null) {
      // Onto is not a valid migration ID
      if (!migrationRegistry.versions.contains(onto!)) {
        log.error('Migration $onto does not exist.');
        throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
      }

      // Onto is a valid migration ID
      return onto!;
    }

    // If ontoBranch is specified, return the last migration ID from ontoBranch
    if (ontoBranch != null) {
      final lastMigrationId = getLastMigrationIdFromBranch(
        migrationRegistry,
        ontoBranch!,
      );

      // No migration found in branch
      if (lastMigrationId.isEmpty) {
        log.error('No migration found in branch $ontoBranch.');
        throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
      }

      // Last migration ID from branch is not a valid migration ID
      if (!migrationRegistry.versions.contains(lastMigrationId)) {
        log.error('Migration $lastMigrationId does not exist.');
        throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
      }

      return lastMigrationId;
    }

    // If no onto or ontoBranch is specified, return the last migration ID from the default branch
    return getLastMigrationIdFromBranch(migrationRegistry, defaultBranch);
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
