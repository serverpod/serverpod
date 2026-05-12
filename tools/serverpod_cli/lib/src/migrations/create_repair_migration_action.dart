import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Outcome of a [createRepairMigrationAction] call.
sealed class RepairMigrationOutcome {
  const RepairMigrationOutcome();
}

/// A repair migration was written to disk.
class RepairMigrationCreated extends RepairMigrationOutcome {
  const RepairMigrationCreated({
    required this.versionName,
    required this.filePath,
  });

  /// The repair migration's version name (timestamp + optional tag).
  final String versionName;

  /// Absolute path to the generated `.sql` file.
  final String filePath;
}

/// No schema drift was detected between the target migration version and the
/// live database. `force` will create an empty repair migration anyway.
class RepairMigrationNoChanges extends RepairMigrationOutcome {
  const RepairMigrationNoChanges();
}

/// Warnings were present and `force` was false. `force` will create the
/// migration despite the warnings (data may be destroyed).
class RepairMigrationAborted extends RepairMigrationOutcome {
  const RepairMigrationAborted();
}

/// The repair migration could not be created.
class RepairMigrationFailed extends RepairMigrationOutcome {
  const RepairMigrationFailed(this.message);

  /// User-facing description of the failure.
  final String message;
}

/// Shared implementation behind the `serverpod create-repair-migration`
/// command, the TUI's "Repair Migration" button, and the
/// `create_repair_migration` MCP tool.
///
/// Connects to the running server (in [runMode]) to fetch the live database
/// schema, diffs it against the target migration version, and writes a repair
/// migration if drift is found.
Future<RepairMigrationOutcome> createRepairMigrationAction({
  required GeneratorConfig config,
  String? tag,
  bool force = false,
  String runMode = 'development',
  String? targetMigrationVersion,
}) async {
  if (!config.isFeatureEnabled(ServerpodFeature.database)) {
    return const RepairMigrationFailed(
      'The database feature is not enabled in this project. '
      'Repair migrations cannot be created.',
    );
  }

  final serverDirectory = Directory(
    path.joinAll(config.serverPackageDirectoryPathParts),
  );

  final projectName = await getProjectName(serverDirectory);
  if (projectName == null) {
    return const RepairMigrationFailed(
      'Unable to determine project name from the server package.',
    );
  }

  final generator = MigrationGenerator(
    directory: serverDirectory,
    projectName: projectName,
  );

  File? repairMigration;
  try {
    repairMigration = await generator.repairMigration(
      tag: tag,
      force: force,
      runMode: runMode,
      dialect: config.databaseDialect,
      targetMigrationVersion: targetMigrationVersion,
    );
  } on MigrationAbortedException {
    return const RepairMigrationAborted();
  } on MigrationRepairTargetNotFoundException catch (e) {
    if (e.versionsFound.isEmpty) {
      return const RepairMigrationFailed(
        'Unable to find any migration versions.',
      );
    }
    return RepairMigrationFailed(
      'Unable to find the specified target migration "${e.targetName}". '
      'Available versions: ${e.versionsFound}.',
    );
  } on MigrationVersionLoadException catch (e) {
    return RepairMigrationFailed(
      'Unable to determine latest database definition due to a corrupted '
      'migration. Migration version: "${e.versionName}" for module '
      '"${e.moduleName}".\n${e.exception}',
    );
  } on MigrationLiveDatabaseDefinitionException catch (e) {
    return RepairMigrationFailed(
      'Unable to fetch live database schema from server. Make sure the '
      'server is running and is connected to the database.\n${e.exception}',
    );
  } on MigrationRepairWriteException catch (e) {
    return RepairMigrationFailed(
      'Unable to write repair migration.\n${e.exception}',
    );
  }

  if (repairMigration == null) {
    return const RepairMigrationNoChanges();
  }

  final versionName = path.basenameWithoutExtension(repairMigration.path);
  return RepairMigrationCreated(
    versionName: versionName,
    filePath: repairMigration.path,
  );
}
