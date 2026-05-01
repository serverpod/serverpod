import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'context.dart';

/// Outcome of a [createMigrationAction] call.
sealed class CreateMigrationOutcome {
  const CreateMigrationOutcome();
}

/// A migration was written to disk.
class CreateMigrationCreated extends CreateMigrationOutcome {
  const CreateMigrationCreated({
    required this.versionName,
    required this.migrationDirectory,
  });

  /// The name (timestamp + optional tag) of the new migration version.
  final String versionName;

  /// Absolute path to the new migration's directory.
  final String migrationDirectory;
}

/// Result of a [createMigrationAction] call.
class CreateMigrationServerClientCreated extends CreateMigrationOutcome {
  const CreateMigrationServerClientCreated({
    required this.serverResult,
    required this.clientResult,
  });

  final CreateMigrationOutcome serverResult;
  final CreateMigrationOutcome clientResult;
}

/// No schema changes were detected; nothing was written.
class CreateMigrationNoChanges extends CreateMigrationOutcome {
  const CreateMigrationNoChanges();
}

/// The migration was aborted due to warnings and [force] was false.
class CreateMigrationAborted extends CreateMigrationOutcome {
  const CreateMigrationAborted();
}

/// The migration could not be created.
class CreateMigrationFailed extends CreateMigrationOutcome {
  const CreateMigrationFailed(this.message);

  /// User-facing description of the failure.
  final String message;
}

extension MigrationOutcomeExtension on CreateMigrationOutcome {
  bool get success => switch (this) {
    CreateMigrationNoChanges() => true,
    CreateMigrationCreated() => true,
    CreateMigrationServerClientCreated(
      :final serverResult,
      :final clientResult,
    ) =>
      serverResult.success && clientResult.success,
    _ => false,
  };
}

/// Shared implementation behind the `serverpod create-migration` command, the
/// TUI's "Create Migration" button, and the `create_migration` MCP tool.
///
/// Returns a [CreateMigrationOutcome] describing what happened. The caller is
/// responsible for logging and formatting the result.
Future<CreateMigrationOutcome> createMigrationAction({
  required GeneratorConfig config,
  String? tag,
  bool force = false,
}) async {
  if (!config.isFeatureEnabled(ServerpodFeature.database)) {
    return const CreateMigrationFailed(
      'The database feature is not enabled in this project. '
      'Migrations cannot be created.',
    );
  }

  final serverDirectory = Directory(
    path.joinAll(config.serverPackageDirectoryPathParts),
  );

  final projectName = await getProjectName(serverDirectory);
  if (projectName == null) {
    return const CreateMigrationFailed(
      'Unable to determine project name from the server package.',
    );
  }

  MigrationGenerationContext generationContext;
  try {
    generationContext = await MigrationGenerationContext.load(config);
  } on GenerateMigrationDatabaseDefinitionException {
    return const CreateMigrationFailed(
      'Unable to generate database definition for project.',
    );
  }

  final hasClientMigrations = generationContext.hasClientDatabaseTables;
  final serverGenerator = MigrationGenerator(
    directory: serverDirectory,
    projectName: projectName,
  );
  final clientDirectory = hasClientMigrations
      ? Directory(path.joinAll(config.clientPackagePathParts))
      : null;

  final clientGenerator = clientDirectory != null
      ? MigrationGenerator(
          directory: clientDirectory,
          projectName: projectName,
          serverCode: false,
        )
      : null;

  final precomputedVersion = MigrationGenerator.createVersionName(tag);

  final results = await Future.wait([
    _createMigration(
      force: force,
      config: config,
      precomputedVersion: precomputedVersion,
      generator: serverGenerator,
      context: generationContext,
    ),
    if (hasClientMigrations)
      _createMigration(
        config: config,
        force: force,
        precomputedVersion: precomputedVersion,
        generator: clientGenerator!,
        context: generationContext,
      ),
  ]);

  if (!hasClientMigrations) {
    return results.first;
  }

  return CreateMigrationServerClientCreated(
    serverResult: results.first,
    clientResult: results.last,
  );
}

Future<CreateMigrationOutcome> _createMigration({
  required MigrationGenerator generator,
  required GeneratorConfig config,
  required bool force,
  required MigrationGenerationContext context,
  required String precomputedVersion,
}) async {
  MigrationVersionArtifacts? migration;
  try {
    migration = await generator.createMigration(
      force: force,
      config: config,
      context: context,
      precomputedVersion: precomputedVersion,
    );
  } on MigrationVersionLoadException catch (e) {
    return CreateMigrationFailed(
      'Unable to determine latest database definition due to a corrupted '
      'migration. Please re-create or remove the migration version and try '
      'again. Migration version: "${e.versionName}".\n${e.exception}',
    );
  } on GenerateMigrationDatabaseDefinitionException {
    return const CreateMigrationFailed(
      'Unable to generate database definition for project.',
    );
  } on MigrationVersionAlreadyExistsException catch (e) {
    return CreateMigrationFailed(
      'Unable to create migration. A directory with the same name already '
      'exists: "${e.directoryPath}".',
    );
  } on MigrationAbortedException {
    return const CreateMigrationAborted();
  }

  if (migration == null) {
    return const CreateMigrationNoChanges();
  }

  return CreateMigrationCreated(
    versionName: migration.version,
    migrationDirectory: generator.serverCode
        ? MigrationConstants.migrationVersionDirectory(
            generator.directory,
            migration.version,
          ).path
        : MigrationConstants.clientMigrationVersionDirectory(
            generator.directory,
            migration.version,
          ).path,
  );
}
