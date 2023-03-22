import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import '../analyzer/yaml/file_analyzer.dart';
import 'class_generator.dart';
import 'code_cleaner.dart';
import 'config.dart';
import '../analyzer/dart/protocol_analyzer.dart';
import 'protocol_generator.dart';
import 'code_analysis_collector.dart';

Future<void> performGenerate({
  required bool verbose,
  bool dartFormat = true,
  String? changedFile,
  required GeneratorConfig config,
  required ProtocolDartFileAnalyzer analyzer,
}) async {
  String generator(spec) => generateCode(spec, dartFormat);

  print('Running serverpod generate.');

  var collector = CodeAnalysisCollector();

  if (verbose) {
    print('Analyzing protocol yaml files.');
  }
  var classDefinitions = ProtocolYamlFileAnalyzer.analyzeFiles(
    verbose: verbose,
    collector: collector,
    config: config,
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
  var protocolDefinition = await analyzer.analyze(
    verbose: verbose,
    collector: collector,
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
    config: config,
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
    config: config,
  );

  if (verbose) {
    print('Cleaning up old files.');
  }
  performRemoveOldFiles(
    verbose: verbose,
    collector: collector,
    generatedServerProtocolPath: config.generatedServerProtocolPath,
    generatedClientProtocolPath: config.generatedClientProtocolPath,
  );
}

typedef CodeGenerator = String Function(Spec spec);

String generateCode(Spec spec, bool dartFormat) {
  String code = '''/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

${spec.accept(DartEmitter.scoped(useNullSafetySyntax: true))}
''';
  try {
    return dartFormat ? DartFormatter().format(code) : code;
  } on FormatterException catch (e) {
    print(e);
  }
  return code;
}
