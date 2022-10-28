import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import 'class_analyzer.dart';
import 'class_generator.dart';
import 'code_cleaner.dart';
import 'config.dart';
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

  String generator(spec) => generateCode(spec, dartFormat);

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
    codeGenerator: generator,
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
    codeGenerator: generator,
  );

  if (verbose) {
    print('Cleaning up old files.');
  }
  performRemoveOldFiles(
    verbose: verbose,
    collector: collector,
  );
}

typedef CodeGenerator = String Function(Spec spec);

String generateCode(Spec spec, bool dartFormat) {
  String code = '''/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

${spec.accept(DartEmitter.scoped(useNullSafetySyntax: true))}
''';
  try {
    return dartFormat ? DartFormatter().format(code) : code;
  } on FormatterException catch (e) {
    print(e);
  }
  return code;
}
