import 'package:args/args.dart';
import 'package:colorize/colorize.dart';

import 'database_util/build_schema.dart';
import 'certificates/generator.dart';
import 'config_info/config_info.dart';
import 'generator/generator.dart';
import 'insights/insights.dart';

final cmdGenerate = 'generate';
final cmdGenerateCertificates = 'generatecerts';
final cmdBuildSchema = 'buildschema';
final cmdShutdown = 'shutdown';
final cmdLogs = 'logs';
final cmdSessionLogs = 'sessionlog';
final cmdCacheInfo = 'cacheinfo';
final cmdServerAddress = 'serveraddress';

void main(List<String> args) async {
  ArgParser parser = ArgParser();

  // "generate" command
  ArgParser generateParser = ArgParser();
  generateParser.addFlag('verbose', abbr: 'v', negatable: false, help: 'Output more detailed information');
  parser.addCommand(cmdGenerate, generateParser);

  // "generatecerts" command
  ArgParser generateCerts = ArgParser();
  generateCerts.addOption('config', abbr: 'c', defaultsTo: 'development', allowed: ['development', 'production'], help: 'Specifies config file used to connect to serverpods');
  generateCerts.addFlag('verbose', abbr: 'v', negatable: false, help: 'Output more detailed information');
  parser.addCommand(cmdGenerateCertificates, generateCerts);

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

  // "sessionlogs" command
  ArgParser sessionLogsParser = ArgParser();
  sessionLogsParser.addOption('config', abbr: 'c', defaultsTo: 'development', allowed: ['development', 'production'], help: 'Specifies config file used to connect to serverpods');
  sessionLogsParser.addOption('num-entries', abbr: 'n', defaultsTo: '100', help: 'Number of log entries to print');
  parser.addCommand(cmdSessionLogs, sessionLogsParser);

  // "cacheinfo" command
  ArgParser cacheinfoParser = ArgParser();
  cacheinfoParser.addOption('config', abbr: 'c', defaultsTo: 'development', allowed: ['development', 'production'], help: 'Specifies config file used to connect to serverpods');
  cacheinfoParser.addFlag('fetch-keys', abbr: 'k', help: 'Fetch all keys stored in the caches of the specificed server');
  parser.addCommand(cmdCacheInfo, cacheinfoParser);

  // "serveraddress" command
  ArgParser serverAddressParser = ArgParser();
  serverAddressParser.addOption('config', abbr: 'c', defaultsTo: 'development', allowed: ['development', 'production'], help: 'Specifies config file used to connect to serverpods');
  serverAddressParser.addOption('id', abbr: 'i', defaultsTo: 'foo', help: 'The id of the server to print the address of');
  parser.addCommand(cmdServerAddress, serverAddressParser);

  var results = parser.parse(args);

  if (results.command != null) {
    if (results.command.name == cmdGenerate) {
      performGenerate(results.command['verbose']);
      return;
    }
    if (results.command.name == cmdGenerateCertificates) {
      await performGenerateCerts(results.command['config'], results.command['verbose']);
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
    if (results.command.name == cmdSessionLogs) {
      var insights = Insights(results.command['config']);
      await insights.printSessionLogs(int.tryParse(results.command['num-entries']) ?? 100);
      insights.close();
      return;
    }
    if (results.command.name == cmdCacheInfo) {
      var insights = Insights(results.command['config']);
      await insights.printCachesInfo(results.command['fetch-keys']);
      insights.close();
      return;
    }
    if (results.command.name == cmdServerAddress) {
      var configInfo = ConfigInfo(results.command['config'], int.tryParse(results.command['id']));
      configInfo.printAddress();
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
  _printCommandUsage(cmdGenerateCertificates, 'Generate certificates for servers specified in configuration files. Generated files are saved in the certificates directory', parser.commands[cmdGenerateCertificates]);
  _printCommandUsage(cmdLogs, 'Print logs from a serverpod or a serverpod cluster', parser.commands[cmdLogs]);
  _printCommandUsage(cmdSessionLogs, 'Print logs from a serverpod or a serverpod cluster listed by session', parser.commands[cmdSessionLogs]);
  _printCommandUsage(cmdCacheInfo, 'Print info about what is stored in a server\'s caches', parser.commands[cmdCacheInfo], true);
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
