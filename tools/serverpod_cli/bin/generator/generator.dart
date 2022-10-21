import 'package:code_builder/code_builder.dart';

import 'class_analyzer.dart';
import 'class_generator.dart';
import 'code_cleaner.dart';
import 'config.dart';
import 'dart_format.dart';
import 'protocol_analyzer.dart';
import 'protocol_generator.dart';
import 'code_analysis_collector.dart';

Future<void> performGenerate({
  required bool verbose,
  bool dartFormat = true,
  bool requestNewAnalyzer = true,
  String? changedFile,
}) async {
  if (!config.load()) return;

  print('Running serverpod generate.');

  var collector = CodeAnalysisCollector();

  if (verbose) {
    print('Analyzing protocol yaml files.');
  }
  var classDefinitions = performAnalyzeClasses(
    verbose: verbose,
    collector: collector,
  );

  collector.printErrors();
  collector.clearErrors();

  var changedFiles =
      Set<String>.from(collector.generatedFiles.map((e) => e.path));
  if (changedFile != null) {
    changedFiles.add(changedFile);
  }

  if (verbose) {
    print('Analyzing server code.');
  }
  var protocolDefinition = await performAnalyzeServerCode(
    verbose: verbose,
    collector: collector,
    requestNewAnalyzer: requestNewAnalyzer,
    changedFiles: changedFiles,
  );

  if (verbose) {
    print('Generating classes.');
  }
  performGenerateClasses(
    verbose: verbose,
    classDefinitions: classDefinitions,
    collector: collector,
    protocolDefinition: protocolDefinition,
  );

  collector.printErrors();
  collector.clearErrors();

  if (verbose) {
    print('Generating protocol.');
  }
  await performGenerateProtocol(
    verbose: verbose,
    protocolDefinition: protocolDefinition,
    collector: collector,
  );

  if (verbose) {
    print('Cleaning up old files.');
  }
  performRemoveOldFiles(
    verbose: verbose,
    collector: collector,
  );

  if (dartFormat) {
    if (verbose) {
      print('Dart format.');
    }
    performDartFormat(verbose);
  }
}

String generateCode(Spec spec) {
  return '''/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

${spec.accept(DartEmitter.scoped(useNullSafetySyntax: true))}
''';
}
