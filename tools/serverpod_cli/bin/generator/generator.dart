import 'class_analyzer.dart';
import 'class_generator.dart';
import 'config.dart';
import 'dart_format.dart';
import 'protocol_analyzer.dart';
import 'protocol_generator.dart';
import 'serverpod_error_collector.dart';

Future<void> performGenerate(bool verbose, bool dartFormat) async {
  if (!config.load()) return;

  var errorCollector = ServerpodErrorCollector();

  print('Analyzing protocol yaml files.');
  var classDefinitions = performAnalyzeClasses(
    verbose: verbose,
    errorCollector: errorCollector,
  );

  errorCollector.printErrors();

  print('Generating classes.');
  performGenerateClasses(
    verbose: verbose,
    classDefinitions: classDefinitions,
  );

  print('Analyzing server code.');
  errorCollector = ServerpodErrorCollector();
  var protocolDefinition = await performAnalyzeServerCode(
    verbose: verbose,
    errorCollector: errorCollector,
    requestNewAnalyzer: true,
  );

  errorCollector.printErrors();

  print('Generating protocol.');
  await performGenerateProtocol(
    verbose: verbose,
    protocolDefinition: protocolDefinition,
  );

  if (dartFormat) {
    print('Dart format.');
    performDartFormat(verbose);
  }

  print('Done.');
}
