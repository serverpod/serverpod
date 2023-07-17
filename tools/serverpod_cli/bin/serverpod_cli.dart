import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/analyzer.dart';

import 'package:serverpod_cli/src/analytics/analytics.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/database/copy_migrations.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/generator/generator_continuous.dart';
import 'package:serverpod_cli/src/generator/generator.dart';
import 'package:serverpod_cli/src/internal_tools/analyze_pubspecs.dart';
import 'package:serverpod_cli/src/internal_tools/generate_pubspecs.dart';
import 'package:serverpod_cli/src/language_server/language_server.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/serverpod_packages_version_check/serverpod_packages_version_check.dart';
import 'package:serverpod_cli/src/shared/environment.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';

abstract class CMD {
  static const analyzePubspecs = 'analyze-pubspecs';
  static const create = 'create';
  static const generate = 'generate';
  static const generatePubspecs = 'generate-pubspecs';
  static const languageServer = 'language-server';
  static const migrate = 'migrate';
  static const version = 'version';
}

final runModes = <String>['development', 'staging', 'production'];

final Analytics _analytics = Analytics();

void main(List<String> args) async {
  // TODO: Add flaggs for setting log level.
  // For now, use old behavior and log everything.
  initializeLogger(LogLevel.debug);

  await runZonedGuarded(
    () async {
      try {
        await _main(args);
      } on ExitException catch (e) {
        _analytics.cleanUp();
        exit(e.exitCode);
      } catch (error, stackTrace) {
        // Last resort error handling.
        printInternalError(error, stackTrace);
        exit(ExitCodeType.general.exitCode);
      }
    },
    (error, stackTrace) {
      printInternalError(error, stackTrace);
      exit(ExitCodeType.general.exitCode);
    },
  );
}

Future<void> _main(List<String> args) async {
  if (Platform.isWindows) {
    log.warning(
        'Windows is not officially supported yet. Things may or may not work '
        'as expected.');
  }

  // Check that required tools are installed
  if (!await CommandLineTools.existsCommand('dart')) {
    log.error(
        'Failed to run serverpod. You need to have dart installed and in your \$PATH');
    throw ExitException();
  }
  if (!await CommandLineTools.existsCommand('flutter')) {
    log.error(
        'Failed to run serverpod. You need to have flutter installed and in your \$PATH');
    throw ExitException();
  }

  if (!loadEnvironmentVars()) {
    throw ExitException();
  }

  // Make sure all necessary downloads are installed
  if (!resourceManager.isTemplatesInstalled) {
    try {
      await resourceManager.installTemplates();
    } catch (e) {
      log.error('Failed to download templates.');
      throw ExitException();
    }

    if (!resourceManager.isTemplatesInstalled) {
      log.error(
          'Could not download the required resources for Serverpod. Make sure that you are connected to the internet and that you are using the latest version of Serverpod.');
      throw ExitException();
    }
  }

  var runner = buildCommandRunner();
  await runner.run(args);
  _analytics.cleanUp();
}

ServerpodCommandRunner buildCommandRunner() {
  var runner =
      ServerpodCommandRunner.createCommandRunner(_analytics, productionMode);

  runner.addCommand(VersionCommand());
  runner.addCommand(CreateCommand());
  runner.addCommand(GenerateCommand());
  runner.addCommand(MigrateCommand());
  runner.addCommand(LanguageServerCommand());
  runner.addCommand(GeneratePubspecsCommand());
  runner.addCommand(AnalyzePubspecsCommand());

  return runner;
}

class VersionCommand extends Command {
  @override
  final name = CMD.version;
  @override
  final description = 'Prints the active version of the Serverpod CLI.';

  @override
  void run() {
    log.info('Serverpod version: $templateVersion');
  }
}

class CreateCommand extends Command {
  @override
  final name = CMD.create;
  @override
  final description =
      'Creates a new Serverpod project, specify project name (must be lowercase with no special characters).';

  CreateCommand() {
    argParser.addFlag('verbose',
        abbr: 'v', negatable: false, help: 'Output more detailed information.');
    argParser.addFlag(
      'force',
      abbr: 'f',
      negatable: false,
      help:
          'Create the project even if there are issues that prevents if from running out of the box.',
    );
    argParser.addOption(
      'template',
      abbr: 't',
      defaultsTo: 'server',
      allowed: <String>['server', 'module'],
      help:
          'Template to use when creating a new project, valid options are "server" or "module".',
    );
  }

  @override
  Future run() async {
    var name = argResults!.arguments.last;
    bool verbose = argResults!['verbose'];
    String template = argResults!['template'];
    bool force = argResults!['force'];

    if (name == 'server' || name == 'module' || name == 'create') {
      // TODO: Use built in usage printer
      // _printUsage(parser);
      return;
    }

    await performCreate(name, verbose, template, force);
  }
}

class GenerateCommand extends Command {
  @override
  final name = CMD.generate;
  @override
  final description = 'Generate code from yaml files for server and clients.';

  GenerateCommand() {
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      defaultsTo: false,
      negatable: false,
      help: 'Output more detailed information.',
    );
    argParser.addFlag(
      'watch',
      abbr: 'w',
      defaultsTo: false,
      negatable: false,
      help: 'Watch for changes and continuously generate code.',
    );
  }

  @override
  Future run() async {
    // Always do a full generate.
    bool verbose = argResults!['verbose'];
    bool watch = argResults!['watch'];

    // TODO: add a -d option to select the directory
    var config = await GeneratorConfig.load();
    if (config == null) {
      throw ExitException(ExitCodeType.commandInvokedCannotExecute);
    }

    // Validate cli version is compatible with serverpod packages
    var warnings = performServerpodPackagesAndCliVersionCheck(
        Version.parse(templateVersion), Directory.current.parent);
    if (warnings.isNotEmpty) {
      log.warning(
        'The version of the CLI may be incompatible with the Serverpod '
        'packages used in your project.',
      );
      for (var warning in warnings) {
        log.sourceSpanException(warning, newParagraph: true);
      }
    }

    // Copy migrations from modules.
    await copyMigrations(config);

    var endpointsAnalyzer = EndpointsAnalyzer(config);

    bool hasErrors = await performGenerate(
      verbose: verbose,
      config: config,
      endpointsAnalyzer: endpointsAnalyzer,
    );
    if (watch) {
      log.info('Initial code generation complete. Listening for changes.');
      hasErrors = await performGenerateContinuously(
        verbose: verbose,
        config: config,
        endpointsAnalyzer: endpointsAnalyzer,
      );
    } else {
      log.info('Done.',
          style: const TextLogStyle(type: AbstractStyleType.success));
    }

    if (hasErrors) {
      throw ExitException();
    }
  }
}

class MigrateCommand extends Command {
  @override
  final name = CMD.migrate;

  @override
  final description =
      'Creates a migration from the last migration to the current state of the database.';

  MigrateCommand() {
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      defaultsTo: false,
      help: 'Output more detailed information.',
    );
    argParser.addFlag(
      'force',
      abbr: 'f',
      negatable: false,
      defaultsTo: false,
      help:
          'Creates the migration even if there are warnings or information that '
          'may be destroyed.',
    );
    argParser.addFlag(
      'repair',
      abbr: 'r',
      negatable: false,
      defaultsTo: false,
      help:
          'Repairs the database by comparing the target state to what is in the '
          'live database instead of comparing to the latest migration.',
    );
    argParser.addOption(
      'mode',
      abbr: 'm',
      defaultsTo: 'development',
      allowed: runModes,
      help: 'Use together with --repair to specify which database to repair.',
    );
    argParser.addOption(
      'tag',
      abbr: 't',
      help: 'Add a tag to the revision to easier identify it.',
    );
  }

  @override
  void run() async {
    bool verbose = argResults!['verbose'];
    bool force = argResults!['force'];
    bool repair = argResults!['repair'];
    String mode = argResults!['mode'];
    String? tag = argResults!['tag'];

    if (tag != null) {
      if (!StringValidators.isValidTagName(tag)) {
        log.error(
          'Invalid tag name. Tag names can only contain lowercase letters, '
          'number, and dashes.',
        );
        throw ExitException(ExitCodeType.commandInvokedCannotExecute);
      }
    }

    var projectName = await getProjectName();

    var config = await GeneratorConfig.load();
    if (config == null) {
      throw ExitException();
    }

    int priority;
    var packageType = config.type;
    switch (packageType) {
      case PackageType.internal:
        priority = 0;
        break;
      case PackageType.module:
        priority = 1;
        break;
      case PackageType.server:
        priority = 2;
        break;
    }

    var generator = MigrationGenerator(
      directory: Directory.current,
      projectName: projectName,
    );

    if (repair) {
      await generator.repairMigration(
        tag: tag,
        force: force,
        runMode: mode,
        verbose: verbose,
      );
    } else {
      await generator.createMigration(
        tag: tag,
        verbose: verbose,
        force: force,
        priority: priority,
      );
      log.info('Done.',
          style: const TextLogStyle(type: AbstractStyleType.success));
    }
  }
}

class LanguageServerCommand extends Command {
  @override
  final name = CMD.languageServer;

  @override
  final description =
      'Launches a serverpod language server communicating with JSON-RPC-2 intended to be used with a client integrated in an IDE.';

  LanguageServerCommand() {
    argParser.addFlag(
      'stdio',
      defaultsTo: true,
      help: 'Use stdin/stdout channels for communication.',
    );
  }

  @override
  Future run() async {
    await runLanguageServer();
  }
}

class GeneratePubspecsCommand extends Command {
  @override
  final name = CMD.generatePubspecs;

  @override
  final description = '';

  GeneratePubspecsCommand() {
    argParser.addOption('version', defaultsTo: 'X');
    argParser.addOption(
      'mode',
      defaultsTo: 'development',
      allowed: ['development', 'production'],
    );
  }

  @override
  void run() {
    if (argResults!['version'] == 'X') {
      log.error('--version is not specified');
      throw ExitException(ExitCodeType.commandInvokedCannotExecute);
    }
    performGeneratePubspecs(argResults!['version'], argResults!['mode']);
  }
}

class AnalyzePubspecsCommand extends Command {
  @override
  final name = CMD.analyzePubspecs;

  @override
  final description = '';

  AnalyzePubspecsCommand() {
    argParser.addFlag(
      'check-latest-version',
      defaultsTo: false,
    );
  }

  @override
  Future run() async {
    bool checkLatestVersion = argResults!['check-latest-version'];
    if (!await pubspecDependenciesMatch(checkLatestVersion)) {
      throw ExitException();
    }
  }
}
