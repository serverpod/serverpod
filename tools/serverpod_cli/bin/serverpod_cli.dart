import 'package:args/args.dart';
import 'package:colorize/colorize.dart';

import 'certificates/generator.dart';
import 'config_info/config_info.dart';
import 'create/create.dart';
import 'generator/generator.dart';
import 'generator/generator_continuous.dart';
// import 'insights/insights.dart';
import 'internal_tools/generate_pubspecs.dart';
import 'shared/environment.dart';

final cmdCreate = 'create';
final cmdGenerate = 'generate';
final cmdGenerateContinuously = 'generate-continuously';
final cmdGenerateCertificates = 'generate-certs';
final cmdShutdown = 'shutdown';
final cmdLogs = 'logs';
final cmdSessionLogs = 'sessionlog';
final cmdCacheInfo = 'cacheinfo';
final cmdServerAddress = 'serveraddress';
final cmdServerIds = 'serverids';
final cmdHealthCheck = 'healthcheck';
final cmdGeneratePubspecs = 'generate-pubspecs';

final runModes = <String>['development', 'staging', 'production'];

void main(List<String> args) async {
  if (!loadEnvironmentVars()) {
    return;
  }

  var parser = ArgParser();

  // "create" command
  var createParser = ArgParser();
  createParser.addFlag('verbose', abbr: 'v', negatable: false, help: 'Output more detailed information');
  createParser.addOption('template', abbr: 't', defaultsTo: 'server', allowed: <String>['server', 'module'], help: 'Template to use when creating a new project, valid options are "server" or "module"');
  parser.addCommand(cmdCreate, createParser);

  // "generate" command
  var generateParser = ArgParser();
  generateParser.addFlag('verbose', abbr: 'v', negatable: false, help: 'Output more detailed information');
  parser.addCommand(cmdGenerate, generateParser);

  // "generate-continuously" command
  var generateContinuouslyParser = ArgParser();
  generateContinuouslyParser.addFlag('verbose', abbr: 'v', negatable: false, help: 'Output more detailed information');
  parser.addCommand(cmdGenerateContinuously, generateContinuouslyParser);

  // "generatecerts" command
  var generateCerts = ArgParser();
  generateCerts.addOption('config', abbr: 'c', defaultsTo: 'development', allowed: runModes, help: 'Specifies config file used to connect to serverpods');
  generateCerts.addFlag('verbose', abbr: 'v', negatable: false, help: 'Output more detailed information');
  parser.addCommand(cmdGenerateCertificates, generateCerts);

  // "shutdown" command
  var shutdownParser = ArgParser();
  shutdownParser.addOption('config', abbr: 'c', defaultsTo: 'development', allowed: runModes, help: 'Specifies config file used to connect to serverpods');
  parser.addCommand(cmdShutdown, shutdownParser);

  // "logs" command
  var logsParser = ArgParser();
  logsParser.addOption('config', abbr: 'c', defaultsTo: 'development', allowed: runModes, help: 'Specifies config file used to connect to serverpods');
  logsParser.addOption('num-entries', abbr: 'n', defaultsTo: '100', help: 'Number of log entries to print');
  parser.addCommand(cmdLogs, logsParser);

  // "sessionlogs" command
  var sessionLogsParser = ArgParser();
  sessionLogsParser.addOption('config', abbr: 'c', defaultsTo: 'development', allowed: runModes, help: 'Specifies config file used to connect to serverpods');
  sessionLogsParser.addOption('num-entries', abbr: 'n', defaultsTo: '100', help: 'Number of log entries to print');
  parser.addCommand(cmdSessionLogs, sessionLogsParser);

  // "cacheinfo" command
  var cacheinfoParser = ArgParser();
  cacheinfoParser.addOption('config', abbr: 'c', defaultsTo: 'development', allowed: runModes, help: 'Specifies config file used to connect to serverpods');
  cacheinfoParser.addFlag('fetch-keys', abbr: 'k', help: 'Fetch all keys stored in the caches of the specificed server');
  parser.addCommand(cmdCacheInfo, cacheinfoParser);

  // "serveraddress" command
  var serverAddressParser = ArgParser();
  serverAddressParser.addOption('config', abbr: 'c', defaultsTo: 'development', allowed: runModes, help: 'Specifies config file used to connect to serverpods');
  serverAddressParser.addOption('id', abbr: 'i', defaultsTo: 'foo', help: 'The id of the server to print the address of');
  parser.addCommand(cmdServerAddress, serverAddressParser);

  // "serverids" command
  var serverIdsParser = ArgParser();
  serverIdsParser.addOption('config', abbr: 'c', defaultsTo: 'development', allowed: runModes, help: 'Specifies config file used to connect to serverpods');
  parser.addCommand(cmdServerIds, serverIdsParser);

  // "healthcheck" command
  var healthCheckParser = ArgParser();
  healthCheckParser.addOption('config', abbr: 'c', defaultsTo: 'development', allowed: runModes, help: 'Specifies config file used to connect to serverpods');
  parser.addCommand(cmdHealthCheck, healthCheckParser);

  // "generate-pubspecs"
  var generatePubspecs = ArgParser();
  generatePubspecs.addOption('version', defaultsTo: 'X');
  generatePubspecs.addOption('mode', defaultsTo: 'development', allowed: ['development', 'production']);
  parser.addCommand(cmdGeneratePubspecs, generatePubspecs);

  var results = parser.parse(args);

  if (results.command != null) {
    if (results.command!.name == cmdCreate) {
      var name = results.arguments.last;
      bool verbose = results.command!['verbose'];
      String template = results.command!['template'];
      if (name == 'server' || name == 'module' || name == 'create') {
        _printUsage(parser);
        return;
      }
      var re = RegExp(r'^[a-z0-9_]+$');
      if (results.arguments.length > 1 && re.hasMatch(name)) {
        performCreate(name, verbose, template);
        return;
      }
    }
    if (results.command!.name == cmdGenerate) {
      performGenerate(results.command!['verbose']);
      return;
    }
    if (results.command!.name == cmdGenerateContinuously) {
      performGenerateContinuously(results.command!['verbose']);
      return;
    }
    if (results.command!.name == cmdGenerateCertificates) {
      await performGenerateCerts(results.command!['config'], results.command!['verbose']);
      return;
    }
    // if (results.command!.name == cmdShutdown) {
    //   var insights = Insights(results.command!['config']);
    //   await insights.shutdown();
    //   insights.close();
    //   return;
    // }
    // if (results.command!.name == cmdHealthCheck) {
    //   var insights = Insights(results.command!['config']);
    //   await insights.healthCheck();
    //   insights.close();
    //   return;
    // }
    // if (results.command!.name == cmdLogs) {
    //   var insights = Insights(results.command!['config']);
    //   await insights.printLogs(int.tryParse(results.command!['num-entries']) ?? 100);
    //   insights.close();
    //   return;
    // }
    // if (results.command!.name == cmdSessionLogs) {
    //   var insights = Insights(results.command!['config']);
    //   await insights.printSessionLogs(int.tryParse(results.command!['num-entries']) ?? 100);
    //   insights.close();
    //   return;
    // }
    // if (results.command!.name == cmdCacheInfo) {
    //   var insights = Insights(results.command!['config']);
    //   await insights.printCachesInfo(results.command!['fetch-keys']);
    //   insights.close();
    //   return;
    // }
    if (results.command!.name == cmdServerAddress) {
      var configInfo = ConfigInfo(results.command!['config'], serverId: int.tryParse(results.command!['id'])!);
      configInfo.printAddress();
      return;
    }
    if (results.command!.name == cmdServerIds) {
      var configInfo = ConfigInfo(results.command!['config']);
      configInfo.printIds();
      return;
    }
    if (results.command!.name == cmdGeneratePubspecs) {
      if (results.command!['version'] == 'X') {
        print('--version is not specified');
        return;
      }
      performGeneratePubspecs(results.command!['version'], results.command!['mode']);
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

  _printCommandUsage(cmdCreate, 'Creates a new Serverpod project, specify project name (must be lowercase with no special characters).', parser.commands[cmdCreate]!);
  _printCommandUsage(cmdGenerate, 'Generate code from yaml files for server and clients', parser.commands[cmdGenerate]!);
  _printCommandUsage(cmdGenerateContinuously, 'Continuously generate code from yaml files for server and clients', parser.commands[cmdGenerate]!);
  _printCommandUsage(cmdGenerateCertificates, 'Generate certificates for servers specified in configuration files. Generated files are saved in the certificates directory', parser.commands[cmdGenerateCertificates]!);
  _printCommandUsage(cmdLogs, 'Print logs from a serverpod or a serverpod cluster', parser.commands[cmdLogs]!);
  _printCommandUsage(cmdSessionLogs, 'Print logs from a serverpod or a serverpod cluster listed by session', parser.commands[cmdSessionLogs]!);
  _printCommandUsage(cmdCacheInfo, 'Print info about what is stored in a server\'s caches', parser.commands[cmdCacheInfo]!, true);
  _printCommandUsage(cmdShutdown, 'Shutdown a server cluster', parser.commands[cmdGenerate]!, true);
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
