// ignore_for_file: implementation_imports

import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_cli/src/create/database_setup.dart';
import 'package:serverpod_cli/src/create/generate_files.dart';
import 'package:serverpod_cli/src/create/ide.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/shared/environment.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';
import 'package:serverpod_cli/src/util/directory.dart';
import 'package:serverpod_cli/src/util/entitlements_modifier.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:skills/skills.dart';
import 'package:skills/src/core/git_runner.dart';
import 'package:skills/src/core/workspace_resolver.dart';
import 'package:skills/src/ide/ide.dart';
import 'package:yaml_edit/yaml_edit.dart';

import 'copier.dart';
import 'template_renderer.dart';

enum ServerpodTemplateType {
  /// Project with a server and a Flutter app.
  fullstack('fullstack'),

  /// Server only project.
  server('server'),

  /// Module project.
  module('module'),
  ;

  final String name;
  const ServerpodTemplateType(this.name);

  static ServerpodTemplateType? tryParse(String text) {
    for (var templateType in ServerpodTemplateType.values) {
      if (templateType.name == text) {
        return templateType;
      }
    }
    return null;
  }
}

extension ServerpodTemplateTypeExtension on ServerpodTemplateType {
  /// Whether the template is for a server or fullstack project
  bool get hasServer =>
      this == ServerpodTemplateType.server ||
      this == ServerpodTemplateType.fullstack;
  bool get isModule => this == ServerpodTemplateType.module;
}

extension TemplateIdeExtension on List<TemplateIde> {
  List<Ide> get toSkillIdes {
    // Antigravity/Codex/VSCode all map to Ide.generic — dedupe so getSkills
    // does not reinstall the same target multiple times.
    return {
      for (final templateIde in this)
        switch (templateIde) {
          TemplateIde.claude => Ide.claude,
          TemplateIde.cursor => Ide.cursor,
          TemplateIde.openCode => Ide.opencode,
          _ => Ide.generic,
        },
    }.toList();
  }
}

/// Project creation result type.
sealed class CreateResult {}

/// Project creation success result type.
final class CreateSuccess extends CreateResult {
  CreateSuccess({
    required this.projectDirectoryPath,
    required this.serverDirectoryPath,
  });

  final String projectDirectoryPath;
  final String serverDirectoryPath;
}

/// Project creation failure result type.
final class CreateFailure extends CreateResult {}

/// Holds error messages to be flushed at a later time.
/// This is typically used to replay logs to the terminal
/// after exiting the tui's alternate screen
/// but before killing the Dart process.
List<String> _errorBuffer = [];

/// Logs a message with error level and adds it to the error buffer.
void _logError(String message) {
  _errorBuffer.add(message);
  log.error(message);
}

/// Log all messages in the error buffer with error level.
void flushPerformCreateErrors() {
  _errorBuffer.forEach(log.error);
  _errorBuffer.clear();
}

/// Creates a project for the provided [context].
/// Returns a future that resolves to [CreateSuccess] if successful.
/// Otherwise, returns a future that resolves to [CreateFailure.
Future<CreateResult> performCreate(
  String name,
  bool force, {
  bool dryRun = false,
  required bool? interactive,
  required TemplateContext context,
  Directory? workingDirectory,

  /// Whether to create default migration for the upgrade path.
  bool createDefaultMigrationForUpgrade = true,

  /// Identifies which command scaffolded the project (`create` or `quickstart`)
  /// for the `cli.project_created` event. Omit to skip the event.
  String? analyticsMethod,
}) async {
  _errorBuffer.clear();
  // Resolve where the project will be created relative to [workingDirectory]
  // (defaulting to the current directory) without ever mutating the
  // process-wide current directory. Mutating it would leak into a subsequent
  // performCreate call within the same process (e.g. the dry-run followed by
  // the real run in the `create .` TUI flow), resolving the second run
  // against the wrong directory. An explicit [workingDirectory] also lets
  // callers such as tests target an isolated temp dir.
  //
  // For an explicit name the project lives in a `name` subdirectory of the
  // working directory. If the name is a dot, we either upgrade the project we
  // are standing in, or create a new one in place: it takes the working
  // directory's name and its parent becomes the project root.
  final cwd = workingDirectory ?? Directory.current;
  var projectRoot = cwd;
  if (name == '.') {
    if (findServerDirectory(cwd) != null) {
      return await _performUpgrade(
        dryRun: dryRun,
        interactive: interactive,
        context: context,
        createDefaultMigration: createDefaultMigrationForUpgrade,
        workingDirectory: cwd,
        reportAnalytics: analyticsMethod != null,
      );
    }

    name = p.basename(cwd.absolute.path);
    projectRoot = cwd.parent;
  }

  // check if project name is valid
  if (!StringValidators.isValidProjectName(name)) {
    _logError(
      'Invalid project name. Project names can only contain letters, numbers, '
      'and underscores.',
    );
    return CreateFailure();
  }

  var serverpodDirs = ServerpodDirectories(
    projectDir: Directory(p.join(projectRoot.path, name)),
    name: name,
  );
  var pubspecFile = File(p.join(serverpodDirs.projectDir.path, 'pubspec.yaml'));
  if (pubspecFile.existsSync()) {
    _logError('Project $name already exists.');
    return CreateFailure();
  }

  if (dryRun) {
    return CreateSuccess(
      projectDirectoryPath: p.basename(serverpodDirs.projectDir.path),
      serverDirectoryPath: serverpodDirs.serverDir.path,
    );
  }

  final template = context.template;
  if (template == ServerpodTemplateType.module) {
    log.info(
      'Creating Serverpod module "$name".',
      type: TextLogType.init,
    );
  } else {
    log.info(
      'Creating Serverpod project "$name".',
      type: TextLogType.init,
    );
  }

  bool success = await log.progress(
    'Creating project directories.',
    () async {
      _createProjectDirectories(template, serverpodDirs, context);
      return true;
    },
    newParagraph: true,
  );

  final writtenPaths = <String>{};

  if (template.hasServer) {
    success &= await log.progress(
      'Writing project files.',
      () async {
        writtenPaths.addAll(
          _copyServerTemplates(
            serverpodDirs,
            name: name,
            context: context,
            customServerpodPath: productionMode ? null : serverpodHome,
          ),
        );
        return true;
      },
    );
  } else if (template.isModule) {
    success &= await log.progress('Writing project files.', () async {
      writtenPaths.addAll(
        _copyModuleTemplates(
          serverpodDirs,
          name: name,
          customServerpodPath: productionMode ? null : serverpodHome,
        ),
      );
      return true;
    });
  }

  if (template.hasServer) {
    success &= await log.progress(
      'Writing additional project files.',
      () async {
        writtenPaths.addAll([
          ...await _copyServerUpgrade(
            serverpodDirs,
            name: name,
            isUpgrade: false,
            context: context,
            customServerpodPath: productionMode ? null : serverpodHome,
          ),
          if (context.flutterApp)
            ...await _copyFlutterUpgrade(
              serverpodDirs,
              name: name,
              context: context,
              customServerpodPath: productionMode ? null : serverpodHome,
            ),
        ]);
        await _copyClientUpgrade(
          serverpodDirs,
          context: context,
          customServerpodPath: productionMode ? null : serverpodHome,
        );
        return true;
      },
    );
  }

  success &= await _renderTemplates(writtenPaths, context);

  success &= await log.progress('Getting workspace dependencies.', () {
    return CommandLineTools.pubGet(serverpodDirs.projectDir);
  });

  if (context.flutterApp && template.hasServer) {
    success &= await log.progress(
      'Creating Flutter app platform files.',
      () {
        return CommandLineTools.flutterCreate(serverpodDirs.flutterDir);
      },
    );
    await log.progress('Updating Flutter app MacOS entitlements.', () {
      return EntitlementsModifier.addNetworkToEntitlements(
        serverpodDirs.flutterDir,
      );
    });
  }

  success &= await _runGenerate(
    serverpodDirs.serverDir,
    CommandLineExperimentalFeatures.instance.features,
    interactive: interactive,
  );

  if ((template.hasServer || template.isModule) && context.database) {
    success &= await log.progress('Creating default database migration.', () {
      return DatabaseSetup.createDefaultMigration(
        serverpodDirs.serverDir,
        name,
        interactive: interactive,
      );
    });
  }

  // Skills/MCP setup is best-effort for create success: a missing IDE tree
  // should not fail scaffolding after generate already succeeded. Tests and
  // `_ensureAgentSkillsInstalled` still guarantee `.agents/skills` when possible.
  await _configureAgentSkillsAndMcp(
    serverpodDirs: serverpodDirs,
    context: context,
  );

  if (success || force) {
    log.info(
      'Serverpod project created.',
      newParagraph: true,
      type: TextLogType.success,
    );

    var projectDirPath = p.basename(serverpodDirs.projectDir.path);

    if (template.hasServer) logStartInstructions(projectDirPath);

    if (analyticsMethod != null) {
      await cliAnalytics.captureProjectCreated(
        serverDir: serverpodDirs.serverDir.path,
        method: analyticsMethod,
        template: template,
        context: context,
        force: force,
      );
    }

    return CreateSuccess(
      projectDirectoryPath: projectDirPath,
      serverDirectoryPath: serverpodDirs.serverDir.path,
    );
  }

  return CreateFailure();
}

Future<void> _configureAgentSkillsAndMcp({
  required ServerpodDirectories serverpodDirs,
  required TemplateContext context,
}) async {
  if (context.ides.isEmpty) return;

  await _configureProjectMcpServers(serverpodDirs, context.ides);

  await log.progress('Installing agent skills', () async {
    try {
      if (context.template != ServerpodTemplateType.module &&
          context.ides.contains(TemplateIde.claude)) {
        await _createFileAndWrite(
          p.join(serverpodDirs.projectDir.path, 'CLAUDE.md'),
          '@AGENTS.md\n',
        );
      }

      final workspace = await const WorkspaceResolver().resolve(
        serverpodDirs.projectDir.path,
      );

      // Discard skills CLI chatter instead of piping through IsolatedLogWriter.
      // Piping via StreamController+IOSink nested under log.progress has hung
      // create on Ubuntu CI (bootstrap ide_test) while Windows stayed fine.
      final discard = IOSink(_DiscardingByteSink());

      try {
        final success = await getSkills(
          ides: context.ides.toSkillIdes,
          workspace: workspace,
          // Create must stay offline-friendly: only install skills shipped with
          // resolved packages (e.g. package:serverpod). Cloning GitHub registries
          // during scaffold is slow, flaky on CI, and can be done later via
          // `skills get`.
          gitRunner: GitRunner(isAvailableOverride: () async => false),
          stdout: discard,
          stderr: discard,
        );

        if (!success) {
          _logError('Failed to install agent skills from package dependencies');
        }
      } finally {
        await discard.close();
      }

      await _ensureAgentSkillsInstalled(serverpodDirs.projectDir.path);
    } catch (e) {
      _logError('Failed to install agent skills: $e');
      try {
        await _ensureAgentSkillsInstalled(serverpodDirs.projectDir.path);
      } catch (_) {
        // Best-effort fallback only.
      }
      return false;
    }
    return true;
  });
}

/// Promotes/copies skills into `.agents/skills` (and other IDE trees if empty).
///
/// `package:skills` writes generic IDE skills to `.agent/skills`. Antigravity
/// MCP config already lives under `.agents/plugins`, so we copy (never rename
/// — EXDEV breaks rename across mounts) into `.agents/skills`, then remove
/// `.agent`. If package install produced nothing, seed from the local
/// `package:serverpod` skills tree when [serverpodHome] is available.
Future<void> _ensureAgentSkillsInstalled(String projectRoot) async {
  final ideSkillsDirs = [
    Directory(p.join(projectRoot, '.agents', 'skills')),
    Directory(p.join(projectRoot, '.claude', 'skills')),
    Directory(p.join(projectRoot, '.cursor', 'skills')),
    Directory(p.join(projectRoot, '.opencode', 'skills')),
  ];

  final localSources = [
    Directory(p.join(projectRoot, '.agent', 'skills')),
    ...ideSkillsDirs,
  ];

  Directory? populatedSource;
  for (final source in localSources) {
    if (await _directoryHasEntries(source)) {
      populatedSource = source;
      break;
    }
  }

  if (populatedSource == null && !productionMode) {
    final shipped = Directory(
      p.join(serverpodHome, 'packages', 'serverpod', 'skills'),
    );
    if (await _directoryHasEntries(shipped)) {
      populatedSource = shipped;
    }
  }

  if (populatedSource != null) {
    for (final target in ideSkillsDirs) {
      if (await _directoryHasEntries(target)) continue;
      await _copyDirectoryContents(populatedSource, target);
    }
  }

  final agentDir = Directory(p.join(projectRoot, '.agent'));
  if (await agentDir.exists()) {
    await agentDir.delete(recursive: true);
  }
}

Future<bool> _directoryHasEntries(Directory directory) async {
  if (!await directory.exists()) return false;
  await for (final _ in directory.list(followLinks: false)) {
    return true;
  }
  return false;
}

/// Recursively copies [source] into [destination] (created if needed).
Future<void> _copyDirectoryContents(
  Directory source,
  Directory destination,
) async {
  await destination.create(recursive: true);
  await for (final entity in source.list(followLinks: false)) {
    final newPath = p.join(destination.path, p.basename(entity.path));
    final type = await entity.stat().then((s) => s.type);
    if (type == FileSystemEntityType.file) {
      await File(entity.path).copy(newPath);
    } else if (type == FileSystemEntityType.directory) {
      await _copyDirectoryContents(Directory(entity.path), Directory(newPath));
    }
  }
}

/// Byte consumer that drops all writes (for silencing embedded skills CLI I/O).
class _DiscardingByteSink implements StreamConsumer<List<int>> {
  @override
  Future<void> addStream(Stream<List<int>> stream) async {
    await stream.drain<void>();
  }

  @override
  Future<void> close() async {}
}

/// Writes the MCP config files for [ides] under [dirs], showing progress.
Future<void> _configureProjectMcpServers(
  ServerpodDirectories dirs,
  List<TemplateIde> ides,
) async {
  if (ides.isEmpty) return;
  await log.progress('Configuring Serverpod MCP server', () async {
    await _configureMcpServer(
      dirs.projectDir.path,
      ides,
      serverDirRelative: p.relative(
        dirs.serverDir.path,
        from: dirs.projectDir.path,
      ),
    );
    return true;
  });
}

Future<void> _configureMcpServer(
  String projectDirPath,
  List<TemplateIde> ides, {
  required String serverDirRelative,
}) {
  return Future.forEach(
    ides,
    (ide) async {
      await _createFileAndWrite(
        p.join(projectDirPath, ide.filePath),
        ide.effectiveConfig(serverDirRelative: serverDirRelative),
      );
      for (final entry in ide.additionalFiles.entries) {
        await _createFileAndWrite(
          p.join(projectDirPath, entry.key),
          ide.render(entry.value, serverDirRelative: serverDirRelative),
        );
      }
    },
  );
}

Future<void> _createFileAndWrite(String path, String content) async {
  final file = File(path);
  try {
    await file.create(recursive: true);
    await file.writeAsString(content);
  } on FileSystemException catch (e) {
    _logError('Failed to write $path: ${e.osError?.message ?? e.message}');
  }
}

/// Upgrades a server project.
/// Returns a future that resolves to [CreateSuccess] if successful.
/// Otherwise, returns a future that resolves to [CreateFailure.
Future<CreateResult> _performUpgrade({
  bool dryRun = false,
  required bool? interactive,
  required TemplateContext context,
  required bool createDefaultMigration,
  Directory? workingDirectory,
  bool reportAnalytics = false,
}) async {
  if (!context.template.hasServer) {
    _logError('The upgrade command can only be used with server templates.');
    return CreateFailure();
  }

  var serverDir = findServerDirectory(workingDirectory ?? Directory.current);
  if (serverDir == null) {
    _logError('Could not find a Serverpod project in the current directory.');
    return CreateFailure();
  }

  var name = await getProjectName(serverDir);
  if (name == null) {
    _logError('Could not find a project name in the pubspec.yaml file.');
    return CreateFailure();
  }

  var serverpodDir = ServerpodDirectories(
    name: name,
    projectDir: serverDir.parent,
  );

  if (dryRun) {
    return CreateSuccess(
      projectDirectoryPath: name,
      serverDirectoryPath: serverpodDir.serverDir.path,
    );
  }

  final hasFlutterProject = await serverpodDir.flutterDir.exists();

  final writtenPaths = <String>{};
  var success = true;

  success &= await log.progress(
    'Upgrading project.',
    () async {
      writtenPaths.addAll([
        ...await _copyServerUpgrade(
          serverpodDir,
          name: name,
          isUpgrade: true,
          context: context,
          customServerpodPath: productionMode ? null : serverpodHome,
        ),
        if (hasFlutterProject)
          ...await _copyFlutterUpgrade(
            serverpodDir,
            name: name,
            context: context,
            customServerpodPath: productionMode ? null : serverpodHome,
          ),
      ]);
      await _copyClientUpgrade(
        serverpodDir,
        context: context,
        customServerpodPath: productionMode ? null : serverpodHome,
      );
      return true;
    },
  );

  success &= await _renderTemplates(writtenPaths, context);

  success &= await log.progress('Getting workspace dependencies.', () {
    return CommandLineTools.pubGet(serverpodDir.projectDir);
  });

  success &= await _runGenerate(
    serverpodDir.serverDir,
    CommandLineExperimentalFeatures.instance.features,
    interactive: interactive,
  );

  if (createDefaultMigration && context.database) {
    success &= await log.progress('Creating default database migration.', () {
      return DatabaseSetup.createDefaultMigration(
        serverpodDir.serverDir,
        name,
        interactive: interactive,
      );
    });
  }

  await _configureAgentSkillsAndMcp(
    serverpodDirs: serverpodDir,
    context: context,
  );

  await _configureProjectMcpServers(serverpodDir, context.ides);

  if (success) {
    log.info(
      'Serverpod project upgraded.',
      newParagraph: true,
      type: TextLogType.success,
    );

    logStartInstructions(name);

    if (reportAnalytics) {
      await cliAnalytics.captureProjectUpgraded(
        serverDir: serverpodDir.serverDir.path,
        template: context.template,
        context: context,
        createdDefaultMigration: createDefaultMigration && context.database,
      );
    }

    return CreateSuccess(
      projectDirectoryPath: name,
      serverDirectoryPath: serverpodDir.serverDir.path,
    );
  }

  return CreateFailure();
}

/// Renders Mustache directives in the file paths the copiers just wrote.
Future<bool> _renderTemplates(
  Iterable<String> paths,
  TemplateContext context,
) async {
  return await log.progress('Applying template options', () async {
    await const TemplateRenderer().renderPaths(paths, context);
    return true;
  });
}

void logStartInstructions(String relativeProjectPath) {
  log.info(
    'All setup. You are ready to rock! 🥳',
    type: TextLogType.header,
  );
  log.info(
    'If you are using VSCode or Cursor, just hit F5 to start the project.',
    type: TextLogType.header,
  );
  log.info(
    'Start your Serverpod by running:',
    type: TextLogType.header,
  );

  if (Platform.isWindows) {
    log.info(
      'cd .\\$relativeProjectPath\\',
      type: TextLogType.command,
      newParagraph: true,
    );
  } else {
    log.info(
      'cd $relativeProjectPath',
      type: TextLogType.command,
      newParagraph: true,
    );
  }

  log.info(
    'serverpod start',
    type: TextLogType.command,
    newParagraph: true,
  );

  log.info(' ');
}

class ServerpodDirectories {
  final Directory projectDir;
  final Directory serverDir;
  final Directory clientDir;
  final Directory flutterDir;
  final Directory githubDir;
  final Directory vscodeDir;

  ServerpodDirectories({required this.projectDir, required String name})
    : serverDir = Directory(p.join(projectDir.path, '${name}_server')),
      clientDir = Directory(p.join(projectDir.path, '${name}_client')),
      flutterDir = Directory(p.join(projectDir.path, '${name}_flutter')),
      githubDir = Directory(p.join(projectDir.path, '.github')),
      vscodeDir = Directory(p.join(projectDir.path, '.vscode'));
}

void _createProjectDirectories(
  ServerpodTemplateType template,
  ServerpodDirectories serverpodDirs,
  TemplateContext context,
) {
  _createDirectory(serverpodDirs.projectDir);
  _createDirectory(serverpodDirs.serverDir);
  _createDirectory(serverpodDirs.clientDir);

  if (template.hasServer) {
    if (context.flutterApp) _createDirectory(serverpodDirs.flutterDir);
    _createDirectory(serverpodDirs.githubDir);
    _createDirectory(serverpodDirs.vscodeDir);
  }
}

void _createDirectory(Directory dir) {
  log.debug(
    'Creating directory: ${dir.path}',
    type: TextLogType.bullet,
  );
  dir.createSync();
}

Future<void> _copyClientUpgrade(
  ServerpodDirectories serverpodDirs, {
  required TemplateContext context,
  String? customServerpodPath,
}) async {
  if (context.auth) {
    log.debug('Adding auth dependencies to client pubspec', newParagraph: true);
    _addDependenciesToPubspec(
      pubspecFile: File(p.join(serverpodDirs.clientDir.path, 'pubspec.yaml')),
      additions: [
        (
          name: 'serverpod_auth_idp_client',
          source: DependencySource.version(
            VersionConstraint.parse(templateVersion),
          ),
          type: DependencyType.normal,
        ),
      ],
    );
  }

  if (customServerpodPath != null && context.auth) {
    log.debug('Adding auth path overrides to root pubspec', newParagraph: true);
    _addDependenciesToPubspec(
      pubspecFile: File(p.join(serverpodDirs.projectDir.path, 'pubspec.yaml')),
      additions: [
        (
          name: 'serverpod_auth_core_client',
          source: DependencySourcePath(
            '$customServerpodPath/modules/serverpod_auth/serverpod_auth_core/serverpod_auth_core_client',
          ),
          type: DependencyType.override,
        ),
        (
          name: 'serverpod_auth_idp_client',
          source: DependencySourcePath(
            '$customServerpodPath/modules/serverpod_auth/serverpod_auth_idp/serverpod_auth_idp_client',
          ),
          type: DependencyType.override,
        ),
      ],
    );
  }
}

Future<List<String>> _copyFlutterUpgrade(
  ServerpodDirectories serverpodDirs, {
  required String name,
  required TemplateContext context,
  String? customServerpodPath,
}) async {
  log.debug('Copying Flutter upgrade files.', newParagraph: true);
  var copier = Copier(
    srcDir: Directory(
      p.join(
        resourceManager.templateDirectory.path,
        'projectname_flutter_upgrade',
      ),
    ),
    dstDir: serverpodDirs.flutterDir,
    replacements: [
      Replacement(
        slotName: 'projectname',
        replacement: name,
      ),
    ],
    fileNameReplacements: const [],
    ignoreFileNames: const [],
  );
  final writtenPaths = [...copier.copyFiles()];

  if (context.auth) {
    log.debug(
      'Adding auth dependencies to Flutter pubspec',
      newParagraph: true,
    );
    _addDependenciesToPubspec(
      pubspecFile: File(p.join(serverpodDirs.flutterDir.path, 'pubspec.yaml')),
      additions: [
        (
          name: 'serverpod_auth_idp_flutter',
          source: DependencySource.version(
            VersionConstraint.parse(templateVersion),
          ),
          type: DependencyType.normal,
        ),
        (
          name: 'flutter_secure_storage',
          source: DependencySource.version(
            VersionConstraint.parse('^10.0.0'),
          ),
          type: DependencyType.override,
        ),
      ],
    );
  }

  if (customServerpodPath != null && context.auth) {
    log.debug('Adding auth path overrides to root pubspec', newParagraph: true);
    _addDependenciesToPubspec(
      pubspecFile: File(p.join(serverpodDirs.projectDir.path, 'pubspec.yaml')),
      additions: [
        (
          name: 'serverpod_auth_idp_flutter',
          source: DependencySourcePath(
            '$customServerpodPath/modules/serverpod_auth/serverpod_auth_idp/serverpod_auth_idp_flutter',
          ),
          type: DependencyType.override,
        ),
        (
          name: 'serverpod_auth_core_flutter',
          source: DependencySourcePath(
            '$customServerpodPath/modules/serverpod_auth/serverpod_auth_core/serverpod_auth_core_flutter',
          ),
          type: DependencyType.override,
        ),
      ],
    );
  }
  return writtenPaths;
}

Future<List<String>> _copyServerUpgrade(
  ServerpodDirectories serverpodDirs, {
  required String name,
  required bool isUpgrade,
  required TemplateContext context,
  String? customServerpodPath,
}) async {
  var awsName = name.replaceAll('_', '-');
  var randomAwsId = math.Random.secure().nextInt(10000000).toString();

  var dbPassword = generateRandomString();
  var dbTestPassword = generateRandomString();
  var redisTestPassword = generateRandomString();

  log.debug('Copying server upgrade files.', newParagraph: true);
  var copier = Copier(
    srcDir: Directory(
      p.join(
        resourceManager.templateDirectory.path,
        'projectname_server_upgrade',
      ),
    ),
    dstDir: serverpodDirs.serverDir,
    replacements: [
      Replacement(
        slotName: 'projectname',
        replacement: name,
      ),
      Replacement(
        slotName: 'awsname',
        replacement: awsName,
      ),
      Replacement(
        slotName: 'randomawsid',
        replacement: randomAwsId,
      ),
      Replacement(
        slotName: 'SERVICE_SECRET_DEVELOPMENT',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'SERVICE_SECRET_TEST',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'SERVICE_SECRET_STAGING',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'SERVICE_SECRET_PRODUCTION',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'DB_PASSWORD',
        replacement: dbPassword,
      ),
      Replacement(
        slotName: 'DB_TEST_PASSWORD',
        replacement: dbTestPassword,
      ),
      Replacement(
        slotName: 'DB_PRODUCTION_PASSWORD',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'DB_STAGING_PASSWORD',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'REDIS_PASSWORD',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'REDIS_TEST_PASSWORD',
        replacement: redisTestPassword,
      ),
      Replacement(
        slotName: 'SERVER_SIDE_SESSION_KEY_HASH_PEPPER_DEVELOPMENT',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'SERVER_SIDE_SESSION_KEY_HASH_PEPPER_TEST',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'SERVER_SIDE_SESSION_KEY_HASH_PEPPER_STAGING',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'SERVER_SIDE_SESSION_KEY_HASH_PEPPER_PRODUCTION',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'EMAIL_SECRET_HASH_PEPPER_DEVELOPMENT',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'JWT_HMAC_SHA512_PRIVATE_KEY_DEVELOPMENT',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'JWT_REFRESH_TOKEN_HASH_PEPPER_DEVELOPMENT',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'EMAIL_SECRET_HASH_PEPPER_TEST',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'JWT_HMAC_SHA512_PRIVATE_KEY_TEST',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'JWT_REFRESH_TOKEN_HASH_PEPPER_TEST',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'EMAIL_SECRET_HASH_PEPPER_STAGING',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'JWT_HMAC_SHA512_PRIVATE_KEY_STAGING',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'JWT_REFRESH_TOKEN_HASH_PEPPER_STAGING',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'EMAIL_SECRET_HASH_PEPPER_PRODUCTION',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'JWT_HMAC_SHA512_PRIVATE_KEY_PRODUCTION',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'JWT_REFRESH_TOKEN_HASH_PEPPER_PRODUCTION',
        replacement: generateRandomString(),
      ),
    ],
    fileNameReplacements: const [],
  );
  final writtenPaths = [...copier.copyFiles()];

  log.debug('Copying .github files', newParagraph: true);
  copier = Copier(
    srcDir: Directory(p.join(resourceManager.templateDirectory.path, 'github')),
    dstDir: serverpodDirs.githubDir,
    replacements: [
      Replacement(
        slotName: 'projectname',
        replacement: name,
      ),
      Replacement(
        slotName: 'awsname',
        replacement: awsName,
      ),
      Replacement(
        slotName: 'randomawsid',
        replacement: randomAwsId,
      ),
      Replacement(
        slotName: 'DB_TEST_PASSWORD',
        replacement: dbTestPassword,
      ),
      Replacement(
        slotName: 'REDIS_TEST_PASSWORD',
        replacement: redisTestPassword,
      ),
      const Replacement(
        slotName: 'CLI_VERSION',
        replacement: templateVersion,
      ),
    ],
    fileNameReplacements: [],
  );
  writtenPaths.addAll(copier.copyFiles());

  if (!isUpgrade) {
    log.debug('Copying .vscode files', newParagraph: true);
    copier = Copier(
      srcDir: Directory(
        p.join(resourceManager.templateDirectory.path, 'vscode'),
      ),
      dstDir: serverpodDirs.vscodeDir,
      replacements: [
        Replacement(
          slotName: 'projectname',
          replacement: name,
        ),
        Replacement(
          slotName: 'DB_PASSWORD',
          replacement: dbPassword,
        ),
      ],
      fileNameReplacements: [],
    );
    writtenPaths.addAll(copier.copyFiles());
  }

  if (context.auth) {
    log.debug(
      'Adding auth dependencies to server pubspec',
      newParagraph: true,
    );
    _addDependenciesToPubspec(
      pubspecFile: File(p.join(serverpodDirs.serverDir.path, 'pubspec.yaml')),
      additions: [
        (
          name: 'serverpod_auth_idp_server',
          source: DependencySource.version(
            VersionConstraint.parse(templateVersion),
          ),
          type: DependencyType.normal,
        ),
      ],
    );

    if (customServerpodPath != null) {
      log.debug(
        'Adding auth path overrides to root pubspec',
        newParagraph: true,
      );
      _addDependenciesToPubspec(
        pubspecFile: File(
          p.join(serverpodDirs.projectDir.path, 'pubspec.yaml'),
        ),
        additions: [
          (
            name: 'serverpod_auth_idp_server',
            source: DependencySourcePath(
              '$customServerpodPath/modules/serverpod_auth/serverpod_auth_idp/serverpod_auth_idp_server',
            ),
            type: DependencyType.override,
          ),
          (
            name: 'serverpod_auth_core_server',
            source: DependencySourcePath(
              '$customServerpodPath/modules/serverpod_auth/serverpod_auth_core/serverpod_auth_core_server',
            ),
            type: DependencyType.override,
          ),
        ],
      );
    }
  }
  return writtenPaths;
}

void _enableWorkspaceInRootPubspec({
  required File rootPubspecFile,
  required List<String> workspaceMembers,
}) {
  var contents = rootPubspecFile.readAsStringSync();
  final editor = YamlEditor(contents);
  editor.update(['workspace'], workspaceMembers);
  rootPubspecFile.writeAsStringSync(editor.toString());
}

void _addDependenciesToPubspec({
  required File pubspecFile,
  required List<DependencyUpdate> additions,
}) {
  if (!pubspecFile.existsSync()) {
    log.debug('Pubspec file not found: ${pubspecFile.path}');
    return;
  }

  var contents = pubspecFile.readAsStringSync();
  contents = addDependencyToPubspec(contents, additions: additions);
  pubspecFile.writeAsStringSync(contents);
}

List<String> _copyServerTemplates(
  ServerpodDirectories serverpodDirs, {
  required String name,
  required TemplateContext context,
  String? customServerpodPath,
}) {
  final writtenPaths = <String>[];
  log.debug('Copying root workspace pubspec');
  var rootCopier = Copier(
    srcDir: Directory(
      p.join(resourceManager.templateDirectory.path, 'projectname'),
    ),
    dstDir: serverpodDirs.projectDir,
    replacements: [
      // Replace 'name: projectname' with 'name: _' BEFORE general projectname replacement
      const Replacement(
        slotName: 'name: projectname',
        replacement: 'name: _',
      ),
      Replacement(
        slotName: 'projectname',
        replacement: name,
      ),
      if (customServerpodPath != null)
        Replacement(
          slotName: 'path: ../../../packages/',
          replacement: 'path: $customServerpodPath/packages/',
        ),
    ],
    fileNameReplacements: [
      const Replacement(
        slotName: 'gitignore',
        replacement: '.gitignore',
      ),
    ],
    ignoreFileNames: const [],
  );
  writtenPaths.addAll(rootCopier.copyFiles());

  log.debug('Copying server files');
  var copier = Copier(
    srcDir: Directory(
      p.join(resourceManager.templateDirectory.path, 'projectname_server'),
    ),
    dstDir: serverpodDirs.serverDir,
    replacements: [
      Replacement(
        slotName: 'projectname',
        replacement: name,
      ),
      Replacement(
        slotName: 'flutter_app_display_name',
        replacement: formatFlutterAppDisplayName(name),
      ),
      if (customServerpodPath != null)
        Replacement(
          slotName: 'path: ../../../packages/',
          replacement: 'path: $customServerpodPath/packages/',
        ),
    ],
    fileNameReplacements: [
      Replacement(
        slotName: 'projectname',
        replacement: name,
      ),
      const Replacement(
        slotName: 'gitignore',
        replacement: '.gitignore',
      ),
    ],
  );
  writtenPaths.addAll(copier.copyFiles());

  log.debug('Copying client files', newParagraph: true);
  copier = Copier(
    srcDir: Directory(
      p.join(resourceManager.templateDirectory.path, 'projectname_client'),
    ),
    dstDir: serverpodDirs.clientDir,
    replacements: [
      Replacement(
        slotName: 'projectname',
        replacement: name,
      ),
      if (customServerpodPath != null)
        Replacement(
          slotName: 'path: ../../../packages/',
          replacement: 'path: $customServerpodPath/packages/',
        ),
    ],
    fileNameReplacements: [
      Replacement(
        slotName: 'projectname',
        replacement: name,
      ),
      const Replacement(
        slotName: 'gitignore',
        replacement: '.gitignore',
      ),
    ],
  );
  writtenPaths.addAll(copier.copyFiles());

  if (context.flutterApp) {
    log.debug('Copying Flutter files', newParagraph: true);
    copier = Copier(
      srcDir: Directory(
        p.join(resourceManager.templateDirectory.path, 'projectname_flutter'),
      ),
      dstDir: serverpodDirs.flutterDir,
      replacements: [
        Replacement(
          slotName: 'projectname',
          replacement: name,
        ),
        if (customServerpodPath != null)
          Replacement(
            slotName: 'path: ../../../packages/',
            replacement: 'path: $customServerpodPath/packages/',
          ),
      ],
      fileNameReplacements: [
        Replacement(
          slotName: 'projectname',
          replacement: name,
        ),
        const Replacement(
          slotName: 'gitignore',
          replacement: '.gitignore',
        ),
      ],
      ignoreFileNames: [
        'ios',
        'android',
        'web',
        'macos',
        'build',
      ],
    );
    writtenPaths.addAll(copier.copyFiles());
  }

  log.debug('Enabling workspace configuration', newParagraph: true);
  _enableWorkspaceInRootPubspec(
    rootPubspecFile: File(
      p.join(serverpodDirs.projectDir.path, 'pubspec.yaml'),
    ),
    workspaceMembers: [
      '${name}_client',
      '${name}_server',
      if (context.flutterApp) '${name}_flutter',
    ],
  );
  return writtenPaths;
}

List<String> _copyModuleTemplates(
  ServerpodDirectories serverpodDirs, {
  required String name,
  String? customServerpodPath,
}) {
  final writtenPaths = <String>[];
  log.debug('Copying root workspace pubspec');
  var rootCopier = Copier(
    srcDir: Directory(
      p.join(resourceManager.templateDirectory.path, 'modulename'),
    ),
    dstDir: serverpodDirs.projectDir,
    replacements: [
      // Replace 'name: modulename' with 'name: _' BEFORE general modulename replacement
      const Replacement(
        slotName: 'name: modulename',
        replacement: 'name: _',
      ),
      Replacement(
        slotName: 'modulename',
        replacement: name,
      ),
      if (customServerpodPath != null)
        Replacement(
          slotName: 'path: ../../../packages/',
          replacement: 'path: $customServerpodPath/packages/',
        ),
    ],
    fileNameReplacements: [
      const Replacement(
        slotName: 'gitignore',
        replacement: '.gitignore',
      ),
    ],
    ignoreFileNames: const [],
  );
  writtenPaths.addAll(rootCopier.copyFiles());

  log.debug('Copying server files', newParagraph: true);
  var copier = Copier(
    srcDir: Directory(
      p.join(resourceManager.templateDirectory.path, 'modulename_server'),
    ),
    dstDir: serverpodDirs.serverDir,
    replacements: [
      Replacement(
        slotName: 'modulename',
        replacement: name,
      ),
      if (customServerpodPath != null)
        Replacement(
          slotName: 'path: ../../../packages/',
          replacement: 'path: $customServerpodPath/packages/',
        ),
    ],
    fileNameReplacements: [
      Replacement(
        slotName: 'modulename',
        replacement: name,
      ),
      const Replacement(
        slotName: 'gitignore',
        replacement: '.gitignore',
      ),
    ],
  );
  writtenPaths.addAll(copier.copyFiles());

  log.debug('Copying client files', newParagraph: true);
  copier = Copier(
    srcDir: Directory(
      p.join(resourceManager.templateDirectory.path, 'modulename_client'),
    ),
    dstDir: serverpodDirs.clientDir,
    replacements: [
      Replacement(
        slotName: 'modulename',
        replacement: name,
      ),
      if (customServerpodPath != null)
        Replacement(
          slotName: 'path: ../../../packages/',
          replacement: 'path: $customServerpodPath/packages/',
        ),
    ],
    fileNameReplacements: [
      Replacement(
        slotName: 'modulename',
        replacement: name,
      ),
      const Replacement(
        slotName: 'gitignore',
        replacement: '.gitignore',
      ),
    ],
  );
  writtenPaths.addAll(copier.copyFiles());

  log.debug('Enabling workspace configuration', newParagraph: true);
  _enableWorkspaceInRootPubspec(
    rootPubspecFile: File(
      p.join(serverpodDirs.projectDir.path, 'pubspec.yaml'),
    ),
    workspaceMembers: [
      '${name}_client',
      '${name}_server',
    ],
  );
  return writtenPaths;
}

Future<bool> _runGenerate(
  Directory serverDir,
  List<ExperimentalFeature> experimentalFeatures, {
  required bool? interactive,
}) {
  final serverDirPath = serverDir.path;
  return log.progress('Running serverpod generator', () async {
    CommandLineExperimentalFeatures.initialize(experimentalFeatures);
    return await GenerateFiles.generateFiles(
      Directory(serverDirPath),
      interactive: interactive,
    );
  });
}
