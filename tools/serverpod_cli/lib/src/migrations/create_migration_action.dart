import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/analytics/migration_metrics.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/generator/dart_formatters.dart';
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
  bool empty = false,
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
  } on GenerateMigrationDatabaseDefinitionException catch (e) {
    return CreateMigrationFailed('$e');
  }

  final hasClientMigrations =
      generationContext.modelDefinitions.hasHostClientDatabaseTables;
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

  if (hasClientMigrations) {
    await GeneratedDartFormatters.resolve(config);
  }

  final results = await Future.wait([
    _createMigration(
      empty: empty,
      force: force,
      config: config,
      precomputedVersion: precomputedVersion,
      generator: serverGenerator,
      context: generationContext,
    ),
    if (hasClientMigrations)
      _createMigration(
        config: config,
        empty: empty,
        force: force,
        precomputedVersion: precomputedVersion,
        generator: clientGenerator!,
        context: generationContext,
      ),
  ]);

  final outcome = hasClientMigrations
      ? CreateMigrationServerClientCreated(
          serverResult: results.first,
          clientResult: results.last,
        )
      : results.first;

  // Hooked here rather than in the callers so the `create-migration` command,
  // the start TUI's Migrate action and the `create_migration` MCP tool are all
  // covered by one call.
  // Awaited, not fire-and-forget: the work is local (metadata write plus two
  // directory scans; the HTTP send is queued, not awaited), and detaching it
  // would let a short-lived process exit before the event is queued at all.
  await cliAnalytics.captureMigrationCreated(
    config: config,
    flags: MigrationCreatedFlags.fromOutcome(outcome),
    isRepairMigration: false,
  );

  return outcome;
}

Future<CreateMigrationOutcome> _createMigration({
  required MigrationGenerator generator,
  required GeneratorConfig config,
  required bool empty,
  required bool force,
  required MigrationGenerationContext context,
  required String precomputedVersion,
}) async {
  MigrationVersionArtifacts? migration;
  try {
    migration = await generator.createMigration(
      empty: empty,
      force: force,
      config: config,
      context: context,
      precomputedVersion: precomputedVersion,
    );
  } on MigrationAbortedException {
    return const CreateMigrationAborted();
  } on Exception catch (e) {
    return CreateMigrationFailed('$e');
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
