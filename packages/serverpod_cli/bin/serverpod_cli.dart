import 'package:args/args.dart';

import 'database_util/build_schema.dart';
import 'generator/generator.dart';

final cmdGenerate = 'generate';
final cmdBuildSchema = 'buildschema';

void main(List<String> args) async {
  ArgParser parser = ArgParser();

  // "generate" command
  ArgParser generateParser = ArgParser();
  generateParser.addFlag('verbose', abbr: 'v', negatable: false, help: 'Output more information');
  parser.addCommand(cmdGenerate, generateParser);

  // "buildschema" command
  ArgParser buildschemaParser = ArgParser();
  buildschemaParser.addFlag('verbose', abbr: 'v', negatable: false, help: 'Output more information');
  parser.addCommand(cmdBuildSchema, buildschemaParser);

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
  }

  _printUsage(parser);
}

void _printUsage(ArgParser parser) {
  print('Serverpod is a utility for generating serverpod bindings, testing and deploying serverpods.\n');
  print('Usage: serverpod <command> [arguments]\n');
  print('Available commands:\n');

  print('$cmdGenerate: Generate code from yaml files for server and clients');
  print(parser.commands[cmdGenerate].usage);

  print('$cmdBuildSchema: Automatically build database protocol from database');
  print(parser.commands[cmdBuildSchema].usage);
}
