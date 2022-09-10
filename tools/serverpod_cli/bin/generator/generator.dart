import 'class_analyzer.dart';
import 'class_generator.dart';
import 'config.dart';
import 'dart_format.dart';
import 'protocol_analyzer.dart';
import 'protocol_generator.dart';
import 'code_analysis_collector.dart';

Future<void> performGenerate(bool verbose, bool dartFormat) async {
  if (!config.load()) return;

  var analysisCollector = CodeAnalysisCollector();

  print('Analyzing protocol yaml files.');
  var classDefinitions = performAnalyzeClasses(
    verbose: verbose,
    collector: analysisCollector,
  );

  analysisCollector.printErrors();
  analysisCollector.clearErrors();

  print('Generating classes.');
  performGenerateClasses(
    verbose: verbose,
    classDefinitions: classDefinitions,
  );

  print('Analyzing server code.');
  var protocolDefinition = await performAnalyzeServerCode(
    verbose: verbose,
    collector: analysisCollector,
    requestNewAnalyzer: true,
  );

  analysisCollector.printErrors();
  analysisCollector.clearErrors();

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
