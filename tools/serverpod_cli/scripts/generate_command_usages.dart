import 'dart:io';

import 'package:args/command_runner.dart' show Command;
import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/analyze_pubspecs.dart';
import 'package:serverpod_cli/src/commands/cloud.dart';
import 'package:serverpod_cli/src/commands/create.dart';
import 'package:serverpod_cli/src/commands/create_migration.dart';
import 'package:serverpod_cli/src/commands/create_repair_migration.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/generate_pubspecs.dart';
import 'package:serverpod_cli/src/commands/language_server.dart';
import 'package:serverpod_cli/src/commands/mcp.dart';
import 'package:serverpod_cli/src/commands/migrate.dart';
import 'package:serverpod_cli/src/commands/quickstart.dart';
import 'package:serverpod_cli/src/commands/run.dart';
import 'package:serverpod_cli/src/commands/start.dart';
import 'package:serverpod_cli/src/commands/upgrade.dart';
import 'package:serverpod_cli/src/commands/version.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';

/// Generates the framework CLI command reference for the docs site.
///
/// Pass the target docs directory (the `cli` reference folder in
/// `serverpod_docs`) as the only argument. The script writes the auto-generated
/// usage blocks to `_generated/` and the per-command pages to `commands/`,
/// leaving the hand-maintained `_<command>.md` intros untouched.
void main(final List<String> args) {
  if (args.length != 1) {
    throw StateError(
      'Expected the path to the docs directory as the only '
      'argument.',
    );
  }
  final docsPath = args.first;

  final generatedPath = path.join(docsPath, '_generated');
  final commandsPath = path.join(docsPath, 'commands');

  Directory(generatedPath).createSync(recursive: true);
  Directory(commandsPath).createSync(recursive: true);

  // Keep this command list in sync with `buildCommandRunner` in
  // `bin/serverpod_cli.dart`. Hidden commands are filtered out below.
  final version = Version.parse(templateVersion);
  final cli =
      ServerpodCommandRunner.createCommandRunner(
        CompoundAnalytics([]),
        true,
        version,
        onBeforeRunCommand: (_) async {},
      )..addCommands([
        AnalyzePubspecsCommand(),
        CloudCommand(),
        CreateCommand(),
        QuickstartCommand(),
        GenerateCommand(),
        GeneratePubspecsCommand(),
        LanguageServerCommand(),
        McpCommand(),
        CreateMigrationCommand(),
        CreateRepairMigrationCommand(),
        MigrateCommand(),
        RunCommand(),
        StartCommand(),
        UpgradeCommand(),
        VersionCommand(version),
      ]);

  final generator = _CommandDocumentationGenerator(cli);

  final globalOptionsDoc = generator.generateGlobalOptionsPage();
  File(
    path.join(generatedPath, 'global_options.md'),
  ).writeAsStringSync(globalOptionsDoc.toString());

  final commandsDocs = generator.generateMarkdown();

  for (final MapEntry(key: fileName, value: content) in commandsDocs.entries) {
    final commandName = fileName.split('.').first;
    _generateDocPage(
      generatedPath,
      commandsPath,
      commandName,
      commandName,
      fileName,
      content,
    );
  }

  final currentCommands = commandsDocs.keys
      .map((final file) => file.split('.').first)
      .toSet();
  _deleteRemovedCommandsFolders(currentCommands, commandsPath);
  _deleteRemovedCommandsFiles(currentCommands, generatedPath);

  // Building the framework command runner leaves a non-daemon entry on the
  // event loop (unlike the Cloud CLI), so the VM never exits on its own once
  // main returns. All docs are written synchronously above, so terminate
  // explicitly instead of hanging until the CI step times out.
  exit(0);
}

void _generateDocPage(
  final String generatedPath,
  final String docBasePath,
  final String docDirName,
  final String docLabel,
  final String docFileName,
  final String docContent,
) {
  File(path.join(generatedPath, docFileName)).writeAsStringSync(docContent);

  final docPath = path.join(docBasePath, docDirName);
  Directory(docPath).createSync(recursive: true);

  final relativeGeneratedPath = path.relative(generatedPath, from: docPath);

  File(path.join(docPath, '${docFileName}x')).writeAsStringSync(
    buildCommandMdxFileContent(docFileName, relativeGeneratedPath),
  );

  // Create an empty bespoke intro file if it does not exist. These are filled
  // in manually and preserved across regenerations.
  final bespokeFile = File(path.join(docPath, '_$docFileName'));
  if (!bespokeFile.existsSync()) {
    bespokeFile.writeAsStringSync('');
  }

  File(
    path.join(docPath, '_category_.json'),
  ).writeAsStringSync('{"label": "$docLabel"}');
}

String buildCommandMdxFileContent(
  final String fileName,
  final String relativeGeneratedPath,
) {
  final commandName = fileName.split('.').first;
  final importName = _toImportIdentifier(commandName);
  final generatedImportPath = path.join(relativeGeneratedPath, fileName);

  // The title is forced empty so the heading from the maintained intro is used.
  return '''
---
title: ""
---
import MaintainedCommandIntro from './_$fileName';
import $importName from '$generatedImportPath';

<MaintainedCommandIntro/>

<$importName/>
''';
}

/// Turns a command name into a valid PascalCase JS import identifier, e.g.
/// `create-migration` -> `CreateMigration`.
String _toImportIdentifier(final String commandName) {
  return commandName
      .split('-')
      .map(
        (final part) =>
            part.isEmpty ? part : part[0].toUpperCase() + part.substring(1),
      )
      .join();
}

void _deleteRemovedCommandsFiles(
  final Set<String> currentCommands,
  final String generatedCommandsPath,
) {
  for (final entity in Directory(generatedCommandsPath).listSync()) {
    if (entity is File &&
        entity.path.endsWith('.md') &&
        !entity.path.endsWith('global_options.md')) {
      final fileName = path.basename(entity.path);
      if (!currentCommands.contains(fileName.split('.').first)) {
        entity.deleteSync();
      }
    }
  }
}

void _deleteRemovedCommandsFolders(
  final Set<String> currentCommands,
  final String commandsPath,
) {
  for (final entity in Directory(commandsPath).listSync()) {
    if (entity is Directory) {
      final folderName = path.basename(entity.path);
      if (!currentCommands.contains(folderName)) {
        entity.deleteSync(recursive: true);
      }
    }
  }
}

class _CommandDocumentationGenerator {
  final BetterCommandRunner commandRunner;

  _CommandDocumentationGenerator(this.commandRunner);

  Map<String, String> generateMarkdown() {
    final commands = commandRunner.commands.values;

    final files = <String, String>{};

    for (final command in commands) {
      if (_excludeCommand(command)) continue;

      final markdown = _generateCommandPage(command);

      files['${command.name}.md'] = markdown.toString();
    }

    return files;
  }

  StringBuffer generateGlobalOptionsPage() {
    final StringBuffer markdown = StringBuffer();
    markdown.writeln('## Usage\n');

    if (commandRunner.argParser.options.isNotEmpty) {
      markdown.writeln('```console');
      markdown.writeln(commandRunner.usage);
      markdown.writeln('```\n');
    }

    return markdown;
  }

  StringBuffer _generateCommandPage(final Command command) {
    final StringBuffer markdown = StringBuffer();

    final hasOptions = command.argParser.options.isNotEmpty;
    final subcommands = command.subcommands.entries
        .where((final e) => !_excludeCommand(e.value))
        .toList();

    // Commands that forward raw arguments (e.g. `cloud`) expose no options or
    // subcommands, so there is nothing to document beyond the maintained intro.
    if (!hasOptions && subcommands.isEmpty) {
      return markdown;
    }

    markdown.writeln('## Usage\n');

    if (hasOptions) {
      markdown.writeln('```console');
      markdown.writeln(_stripGlobalOptions(command.usage));
      markdown.writeln('```\n');
    }

    if (subcommands.isNotEmpty) {
      final numberOfSubcommands = subcommands.length;
      markdown.writeln('### Sub commands\n');
      for (final (i, subcommand) in subcommands.indexed) {
        markdown.writeln('#### `${subcommand.key}`\n');
        markdown.writeln('```console');
        markdown.writeln(_stripGlobalOptions(subcommand.value.usage));
        markdown.writeln('```');
        if (i < numberOfSubcommands - 1) {
          markdown.writeln();
        }
      }
    }
    return markdown;
  }

  /// Removes the shared "Global options:" block from a command's usage. Those
  /// options are documented on the dedicated global options page, so command
  /// pages keep only their own options plus the pointer line.
  String _stripGlobalOptions(final String usage) {
    final index = usage.indexOf('\nGlobal options:');
    if (index == -1) return usage.trimRight();
    return usage.substring(0, index).trimRight();
  }

  bool _excludeCommand(final Command command) {
    return command.hidden || command.name == 'help';
  }
}
