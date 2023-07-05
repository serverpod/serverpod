import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:colorize/colorize.dart';
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
import 'package:serverpod_cli/src/serverpod_packages_version_check/serverpod_packages_version_check.dart';
import 'package:serverpod_cli/src/shared/environment.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';
import 'package:serverpod_cli/src/util/print.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';
import 'package:serverpod_cli/src/util/version.dart';

const cmdCreate = 'create';
const cmdGenerate = 'generate';
const cmdGeneratePubspecs = 'generate-pubspecs';
const cmdAnalyzePubspecs = 'analyze-pubspecs';
const cmdVersion = 'version';
const cmdMigrate = 'migrate';
const cmdLanguageServer = 'language-server';

final runModes = <String>['development', 'staging', 'production'];

final Analytics _analytics = Analytics();

void main(List<String> args) async {
  await runZonedGuarded(
    () async {
      try {
        await _main(args);
      } catch (error, stackTrace) {
        // Last resort error handling.
        printInternalError(error, stackTrace);
      }
    },
    (error, stackTrace) {
      printInternalError(error, stackTrace);
    },
  );
}

Future<void> _main(List<String> args) async {
  if (Platform.isWindows) {
    print(
        'WARNING! Windows is not officially supported yet. Things may or may not work as expected.');
    print('');
  }

  // Check that required tools are installed
  if (!await CommandLineTools.existsCommand('dart')) {
    print(
        'Failed to run serverpod. You need to have dart installed and in your \$PATH');
    return;
  }
  if (!await CommandLineTools.existsCommand('flutter')) {
    print(
        'Failed to run serverpod. You need to have flutter installed and in your \$PATH');
    return;
  }

  if (!loadEnvironmentVars()) {
    return;
  }

  // Make sure all necessary downloads are installed
  if (!resourceManager.isTemplatesInstalled) {
    try {
      await resourceManager.installTemplates();
    } catch (e) {
      print('Failed to download templates.');
    }

    if (!resourceManager.isTemplatesInstalled) {
      print(
          'Could not download the required resources for Serverpod. Make sure that you are connected to the internet and that you are using the latest version of Serverpod.');
      return;
    }
  }

  var parser = ArgParser();
  parser.addFlag(
    'development-print',
    defaultsTo: true,
    negatable: true,
    help: 'Prints additional information useful for development.',
  );

  // "version" command
  var versionParser = ArgParser();
  parser.addCommand(cmdVersion, versionParser);

  // "create" command
  var createParser = ArgParser();
  createParser.addFlag('verbose',
      abbr: 'v', negatable: false, help: 'Output more detailed information.');
  createParser.addFlag(
    'force',
    abbr: 'f',
    negatable: false,
    help:
        'Create the project even if there are issues that prevents if from running out of the box.',
  );
  createParser.addOption(
    'template',
    abbr: 't',
    defaultsTo: 'server',
    allowed: <String>['server', 'module'],
    help:
        'Template to use when creating a new project, valid options are "server" or "module".',
  );
  parser.addCommand(cmdCreate, createParser);

  // "generate" command
  var generateParser = ArgParser();
  generateParser.addFlag(
    'verbose',
    abbr: 'v',
    negatable: false,
    help: 'Output more detailed information.',
  );
  generateParser.addFlag(
    'watch',
    abbr: 'w',
    negatable: false,
    help: 'Watch for changes and continuously generate code.',
  );
  parser.addCommand(cmdGenerate, generateParser);

  // "migrate" commanbd
  var migrateParser = ArgParser();
  migrateParser.addFlag(
    'verbose',
    abbr: 'v',
    negatable: false,
    help: 'Output more detailed information.',
  );
  migrateParser.addFlag(
    'force',
    abbr: 'f',
    negatable: false,
    help:
        'Creates the migration even if there are warnings or information that '
        'may be destroyed.',
  );
  migrateParser.addFlag(
    'repair',
    abbr: 'r',
    negatable: false,
    help:
        'Repairs the database by comparing the target state to what is in the '
        'live database instead of comparing to the latest migration.',
  );
  migrateParser.addOption(
    'mode',
    abbr: 'm',
    defaultsTo: 'development',
    allowed: runModes,
    help: 'Use together with --repair to specify which database to repair.',
  );
  migrateParser.addOption(
    'tag',
    abbr: 't',
    help: 'Add a tag to the revision to easier identify it.',
  );
  parser.addCommand(cmdMigrate, migrateParser);

  // "language-server" command
  var languageServerParser = ArgParser();
  languageServerParser.addFlag(
    'stdio',
    defaultsTo: true,
    help: 'Use stdin/stdout channels for communication.',
  );
  parser.addCommand(cmdLanguageServer, languageServerParser);

  // "generate-pubspecs"
  var generatePubspecs = ArgParser();
  generatePubspecs.addOption('version', defaultsTo: 'X');
  generatePubspecs.addOption(
    'mode',
    defaultsTo: 'development',
    allowed: ['development', 'production'],
  );
  parser.addCommand(cmdGeneratePubspecs, generatePubspecs);

  var analyzePubspecs = ArgParser();
  analyzePubspecs.addFlag(
    'check-latest-version',
  );
  parser.addCommand(cmdAnalyzePubspecs, analyzePubspecs);

  ArgResults results;
  try {
    results = parser.parse(args);
    bool devPrint = results['development-print'];

    if (!productionMode && devPrint) {
      print(
        'Development mode. Using templates from: ${resourceManager.templateDirectory.path}',
      );
      print('SERVERPOD_HOME is set to $serverpodHome');

      if (!resourceManager.isTemplatesInstalled) {
        print('WARNING! Could not find templates.');
      }
    }
  } catch (e) {
    _analytics.track(event: 'invalid');
    _printUsage(parser);
    _analytics.cleanUp();
    return;
  }

  if (results.command != null) {
    _analytics.track(event: '${results.command?.name}');

    // Version command.
    if (results.command!.name == cmdVersion) {
      printVersion();
      _analytics.cleanUp();
      return;
    }

    // Create command.
    if (results.command!.name == cmdCreate) {
      var name = results.arguments.last;
      bool verbose = results.command!['verbose'];
      String template = results.command!['template'];
      bool force = results.command!['force'];

      if (name == 'server' || name == 'module' || name == 'create') {
        _printUsage(parser);
        _analytics.cleanUp();
        return;
      }

      await performCreate(name, verbose, template, force);
      _analytics.cleanUp();
      return;
    }

    // Generate command.
    if (results.command!.name == cmdGenerate) {
      // Always do a full generate.
      bool verbose = results.command!['verbose'];
      bool watch = results.command!['watch'];

      // TODO: add a -d option to select the directory
      var config = await GeneratorConfig.load();
      if (config == null) {
        return;
      }

      // Validate cli version is compatible with serverpod packages
      try {
        var warnings = performServerpodPackagesAndCliVersionCheck(
            Version.parse(templateVersion), Directory.current.parent);
        if (warnings.isNotEmpty) {
          printww(
              'WARNING: The version of the CLI may be incompatible with the '
              'Serverpod packages used in your project.');
          warnings.forEach(print);
        }
      } catch (e) {
        print(e);
        exit(1);
      }

      // Copy migrations from modules.
      await copyMigrations(config);

      var endpointsAnalyzer = EndpointsAnalyzer(config);

      await performGenerate(
        verbose: verbose,
        config: config,
        endpointsAnalyzer: endpointsAnalyzer,
      );
      if (watch) {
        print('Initial code generation complete. Listening for changes.');
        performGenerateContinuously(
          verbose: verbose,
          config: config,
          endpointsAnalyzer: endpointsAnalyzer,
        );
      } else {
        print('Done.');
      }
      _analytics.cleanUp();
      return;
    }

    // Migrate command
    if (results.command!.name == cmdMigrate) {
      bool verbose = results.command!['verbose'];
      bool force = results.command!['force'];
      bool repair = results.command!['repair'];
      String mode = results.command!['mode'];
      String? tag = results.command!['tag'];

      if (tag != null) {
        if (!StringValidators.isValidTagName(tag)) {
          printwwln(
            'Invalid tag name. Tag names can only contain lowercase letters, '
            'number, and dashes.',
          );
          _analytics.cleanUp();
          return;
        }
      }

      var projectName = await getProjectName();

      var config = await GeneratorConfig.load();
      if (config == null) {
        exit(1);
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
        print('Done.');
      }

      _analytics.cleanUp();
      return;
    }

    if (results.command!.name == cmdLanguageServer) {
      await runLanguageServer();
      _analytics.cleanUp();
      return;
    }

    // Generate pubspecs command.
    if (results.command!.name == cmdGeneratePubspecs) {
      if (results.command!['version'] == 'X') {
        print('--version is not specified');
        _analytics.cleanUp();
        return;
      }
      performGeneratePubspecs(
          results.command!['version'], results.command!['mode']);
      _analytics.cleanUp();
      return;
    }

    // Analyze pubspecs command.
    if (results.command!.name == cmdAnalyzePubspecs) {
      bool checkLatestVersion = results.command!['check-latest-version'];
      await performAnalyzePubspecs(checkLatestVersion);
      return;
    }
  }

  _analytics.track(event: 'help');
  _printUsage(parser);
  _analytics.cleanUp();
}

void _printUsage(ArgParser parser) {
  print('${Colorize('Usage:')..bold()} serverpod <command> [arguments]\n');
  print('');
  print('${Colorize('COMMANDS')..bold()}');
  print('');
  _printCommandUsage(
    cmdVersion,
    'Prints the active version of the Serverpod CLI.',
  );
  _printCommandUsage(
    cmdCreate,
    'Creates a new Serverpod project, specify project name (must be lowercase with no special characters).',
    parser.commands[cmdCreate]!,
  );
  _printCommandUsage(
    cmdGenerate,
    'Generate code from yaml files for server and clients.',
    parser.commands[cmdGenerate]!,
  );
  _printCommandUsage(
    cmdMigrate,
    'Creates a migration from the last migration to the current state of the database.',
    parser.commands[cmdMigrate]!,
  );
  _printCommandUsage(
    cmdLanguageServer,
    'Launches a serverpod language server communicating with JSON-RPC-2 intended to be used with a client integrated in an IDE.',
    parser.commands[cmdLanguageServer]!,
  );
}

void _printCommandUsage(String name, String descr,
    [ArgParser? parser, bool last = false]) {
  print('${Colorize('$name:')..bold()} $descr');
  if (parser != null) {
    print('');
    print(parser.usage);
    print('');
  }

  if (!last) {
    print('');
  }
}
