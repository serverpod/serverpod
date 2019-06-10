import 'package:args/args.dart';
import 'package:colorize/colorize.dart';

import 'database_util/build_schema.dart';
import 'generator/generator.dart';
import 'insights/insights.dart';

final cmdGenerate = 'generate';
final cmdBuildSchema = 'buildschema';
final cmdShutdown = 'shutdown';
final cmdLogs = 'logs';

void main(List<String> args) async {
  ArgParser parser = ArgParser();

  // "generate" command
  ArgParser generateParser = ArgParser();
  generateParser.addFlag('verbose', abbr: 'v', negatable: false, help: 'Output more detailed information');
  parser.addCommand(cmdGenerate, generateParser);

  // "buildschema" command
  ArgParser buildschemaParser = ArgParser();
  buildschemaParser.addFlag('verbose', abbr: 'v', negatable: false, help: 'Output more detailed information');
  parser.addCommand(cmdBuildSchema, buildschemaParser);

  // "shutdown" command
  ArgParser shutdownParser = ArgParser();
  shutdownParser.addOption('config', abbr: 'c', defaultsTo: 'development', allowed: ['development', 'production'], help: 'Specifies config file used to connect to serverpods');
  parser.addCommand(cmdShutdown, shutdownParser);

  // "logs" command
  ArgParser logsParser = ArgParser();
  logsParser.addOption('config', abbr: 'c', defaultsTo: 'development', allowed: ['development', 'production'], help: 'Specifies config file used to connect to serverpods');
  logsParser.addOption('num-entries', abbr: 'n', defaultsTo: '100', help: 'Number of log entries to print');
  parser.addCommand(cmdLogs, logsParser);

  var results = parser.parse(args);

  if (results.command != null) {
    if (results.command.name == cmdGenerate) {
      performGenerate(results.command['verbose']);
      return;
    }
    if (results.command.name == cmdBuildSchema) {
      await performBuildSchema(results.command['verbose']);
      return;
    }
    if (results.command.name == cmdShutdown) {
      var insights = Insights(results.command['config']);
      await insights.shutdown();
      insights.close();
      return;
    }
    if (results.command.name == cmdLogs) {
      var insights = Insights(results.command['config']);
      await insights.printLogs(int.tryParse(results.command['num-entries']) ?? 100);
      insights.close();
      return;
    }
  }

  _printUsage(parser);
}

void _printUsage(ArgParser parser) {
  print(Colorize('SERVERPOD HELP')..bold());
  print('');
  print('Serverpod is a utility for generating serverpod bindings, testing and deploying serverpods.\n');
  print('${Colorize('Usage:')..bold()} serverpod <command> [arguments]\n');
  print('');
  print('${Colorize('COMMANDS')..bold()}');
  print('');

  _printCommandUsage(cmdGenerate, 'Generate code from yaml files for server and clients', parser.commands[cmdGenerate]);
  _printCommandUsage(cmdLogs, 'Print logs from a serverpod or a serverpod cluster', parser.commands[cmdLogs]);
  _printCommandUsage(cmdShutdown, 'Shutdown a server cluster', parser.commands[cmdGenerate], true);
}

void _printCommandUsage(String name, String descr, ArgParser parser, [bool last=false]) {
  print('${Colorize('$name:')..bold()} $descr');
  print('');
  print(parser.usage);
  print('');

  if (!last) {
    print('');
  }
}
