import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Thrown by [createRepairMigrationAction] for pre-flight failures (feature
/// flag, project name lookup). Migration-time failures propagate as their
/// typed exception (see [createRepairMigrationAction]'s docs).
class RepairMigrationException implements Exception {
  const RepairMigrationException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Shared implementation behind the `serverpod create-repair-migration`
/// command, the TUI's "Repair Migration" button, and the
/// `create_repair_migration` MCP tool.
///
/// Connects to the running server (in [runMode]) to fetch the live database
/// schema, diffs it against the target migration version, and writes a repair
/// migration if drift is found.
///
/// Returns the generated `.sql` file, or `null` when no schema drift is
/// detected (override with [force]).
///
/// Throws:
/// - [MigrationAbortedException] when warnings are present and [force] is
///   false (callers typically handle this with a surface-specific message).
/// - [RepairMigrationException] for pre-flight failures.
/// - [MigrationRepairTargetNotFoundException], [MigrationVersionLoadException],
///   [MigrationLiveDatabaseDefinitionException], [MigrationRepairWriteException]
///   for typed generator failures. Each `toString()`s into a user-facing
///   message, so callers can display them with `'$e'`.
Future<File?> createRepairMigrationAction({
  required GeneratorConfig config,
  required String runMode,
  String? tag,
  bool force = false,
  String? targetMigrationVersion,
}) async {
  if (!config.isFeatureEnabled(ServerpodFeature.database)) {
    throw const RepairMigrationException(
      'The database feature is not enabled in this project. '
      'Repair migrations cannot be created.',
    );
  }

  final serverDirectory = Directory(
    path.joinAll(config.serverPackageDirectoryPathParts),
  );

  final projectName = await getProjectName(serverDirectory);
  if (projectName == null) {
    throw const RepairMigrationException(
      'Unable to determine project name from the server package.',
    );
  }

  return MigrationGenerator(
    directory: serverDirectory,
    projectName: projectName,
  ).repairMigration(
    tag: tag,
    force: force,
    runMode: runMode,
    dialect: config.databaseDialect,
    targetMigrationVersion: targetMigrationVersion,
  );
}
