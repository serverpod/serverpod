import 'class_analyzer.dart';
import 'class_generator.dart';
import 'config.dart';
import 'dart_format.dart';
import 'protocol_generator.dart';
import 'serverpod_error_collector.dart';

Future<void> performGenerate(bool verbose, bool format) async {
  if (!config.load()) return;

  var errorCollector = ServerpodErrorCollector();

  print('Loading protocol yaml files');
  var classDefinitions = performAnalyzeClasses(
    verbose: verbose,
    errorCollector: errorCollector,
  );

  print('ERRORS:');
  for (var error in errorCollector.errors) {
    print(error);
  }
  print('END\n\n');

  print('Generating classes');
  performGenerateClasses(verbose);

  print('Generating protocol');
  await performGenerateProtocol(verbose);

  if (format) {
    print('Dart format');
    performDartFormat(verbose);
  }

  print('Done.');
}
