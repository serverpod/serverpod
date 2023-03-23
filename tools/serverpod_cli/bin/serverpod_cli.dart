import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:colorize/colorize.dart';
import 'package:serverpod_cli/analyzer.dart';

import 'package:serverpod_cli/src/analytics/analytics.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/generator/generator.dart';
import 'package:serverpod_cli/src/generator/generator_continuous.dart';
import 'package:serverpod_cli/src/internal_tools/generate_pubspecs.dart';
import 'package:serverpod_cli/src/shared/environment.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';
import 'package:serverpod_cli/src/util/version.dart';

const cmdCreate = 'create';
const cmdGenerate = 'generate';
// const cmdRun = 'run';
const cmdGeneratePubspecs = 'generate-pubspecs';
const cmdVersion = 'version';

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
  if (!productionMode) {
    print(
      'Development mode. Using templates from: ${resourceManager.templateDirectory.path}',
    );
    print('SERVERPOD_HOME is set to $serverpodHome');
    if (!resourceManager.isTemplatesInstalled) {
      print('WARNING! Could not find templates.');
    }
  }

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

  // "version" command
  var versionParser = ArgParser();
  parser.addCommand(cmdVersion, versionParser);

  // "create" command
  var createParser = ArgParser();
  createParser.addFlag('verbose',
      abbr: 'v', negatable: false, help: 'Output more detailed information');
  createParser.addFlag(
    'force',
    abbr: 'f',
    negatable: false,
    help:
        'Create the project even if there are issues that prevents if from running out of the box',
  );
  createParser.addOption(
    'template',
    abbr: 't',
    defaultsTo: 'server',
    allowed: <String>['server', 'module'],
    help:
        'Template to use when creating a new project, valid options are "server" or "module"',
  );
  parser.addCommand(cmdCreate, createParser);

  // "generate" command
  var generateParser = ArgParser();
  generateParser.addFlag(
    'verbose',
    abbr: 'v',
    negatable: false,
    help: 'Output more detailed information',
  );
  generateParser.addFlag(
    'watch',
    abbr: 'w',
    negatable: false,
    help: 'Watch for changes and continuously generate code.',
  );
  parser.addCommand(cmdGenerate, generateParser);

  // "run" command
  // var runParser = ArgParser();
  // runParser.addFlag(
  //   'verbose',
  //   abbr: 'v',
  //   negatable: false,
  //   help: 'Output more detailed information',
  // );
  // // TODO: Fix Docker management
  // parser.addCommand(cmdRun, runParser);

  // "generate-pubspecs"
  var generatePubspecs = ArgParser();
  generatePubspecs.addOption('version', defaultsTo: 'X');
  generatePubspecs.addOption('mode',
      defaultsTo: 'development', allowed: ['development', 'production']);
  parser.addCommand(cmdGeneratePubspecs, generatePubspecs);

  ArgResults results;
  try {
    results = parser.parse(args);
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

      var re = RegExp(r'^[a-z0-9_]+$');
      if (results.arguments.length > 1 && re.hasMatch(name)) {
        await performCreate(name, verbose, template, force);
        _analytics.cleanUp();
        return;
      }
    }

    // Generate command.
    if (results.command!.name == cmdGenerate) {
      // Always do a full generate.
      var verbose = results.command!['verbose'];
      var watch = results.command!['watch'];

      //TODO: set path for load from option
      var config = GeneratorConfig.load();
      if (config == null) {
        return;
      }

      var analyzer = ProtocolAnalyzer(config);

      await performGenerate(
        verbose: verbose,
        config: config,
        analyzer: analyzer,
      );
      if (watch) {
        print('Initial code generation complete. Listening for changes.');
        performGenerateContinuously(
          verbose: verbose,
          config: config,
          analyzer: analyzer,
        );
      } else {
        print('Done.');
      }
      _analytics.cleanUp();
      return;
    }

    // Run command.
    // TODO: Fix in future version.
    // if (results.command!.name == cmdRun) {
    //   if (Platform.isWindows) {
    //     printwwln(
    //         'Sorry, `serverpod run` is not yet supported on Windows. You can still start your server by running:');
    //     stdout.writeln('  \$ docker compose up --build --detach');
    //     stdout.writeln('  \$ dart .\\bin\\main.dart');
    //     printww('');
    //   } else {
    //     // TODO: Fix Docker management
    //     performRun(
    //       results.command!['verbose'],
    //     );
    //   }
    //   _analytics.cleanUp();
    //   return;
    // }

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
  // _printCommandUsage(
  //   cmdRun,
  //   'Run server in development mode. Code is generated continuously and server is hot reloaded when source files are edited.',
  //   parser.commands[cmdGenerate]!,
  // );
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
