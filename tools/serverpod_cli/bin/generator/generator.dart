import 'class_analyzer.dart';
import 'class_generator.dart';
import 'config.dart';
import 'dart_format.dart';
import 'protocol_generator.dart';
import 'serverpod_error_collector.dart';

Future<void> performGenerate(bool verbose, bool dartFormat) async {
  if (!config.load()) return;

  var errorCollector = ServerpodErrorCollector();

  print('Loading protocol yaml files.');
  var classDefinitions = performAnalyzeClasses(
    verbose: verbose,
    errorCollector: errorCollector,
  );

  if (errorCollector.errors.isNotEmpty) {
    print(
        'Found ${errorCollector.errors.length} error${errorCollector.errors.length == 1 ? '' : 's'}');
    print('');
    for (var error in errorCollector.errors) {
      print(error);
      print('');
    }
  }

  print('Generating classes.');
  performGenerateClasses(
    verbose: verbose,
    classDefinitions: classDefinitions,
  );

  print('Generating protocol.');
  await performGenerateProtocol(verbose);

  if (dartFormat) {
    print('Dart format.');
    performDartFormat(verbose);
  }

  print('Done.');
}
