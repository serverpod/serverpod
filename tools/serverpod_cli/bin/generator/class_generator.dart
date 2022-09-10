import 'dart:io';
import 'package:path/path.dart' as p;
import '../util/internal_error.dart';
import 'class_generator_dart.dart';
import 'code_analysis_collector.dart';
import 'config.dart';
import 'pgsql_generator.dart';
import 'protocol_definition.dart';

void performGenerateClasses({
  required bool verbose,
  required List<ProtocolFileDefinition> classDefinitions,
  required CodeAnalysisCollector collector,
}) {
  // Generate server side code
  if (verbose) print('Generating server side code.');
  var serverGenerator = ClassGeneratorDart(
    verbose: verbose,
    outputDirectoryPath: config.generatedServerProtocolPath,
    serverCode: true,
    classDefinitions: classDefinitions,
  );
  serverGenerator.generate(collector: collector);

  // Generate client side code
  if (verbose) print('Generating Dart client side code.');
  var clientGenerator = ClassGeneratorDart(
    verbose: verbose,
    outputDirectoryPath: config.generatedClientProtocolPath,
    serverCode: false,
    classDefinitions: classDefinitions,
  );
  clientGenerator.generate(collector: collector);
}

abstract class ClassGenerator {
  final String outputDirectoryPath;
  final bool verbose;
  final bool serverCode;
  final List<ProtocolFileDefinition> classDefinitions;

  ClassGenerator({
    required this.verbose,
    required this.classDefinitions,
    required this.outputDirectoryPath,
    required this.serverCode,
  });

  String get outputExtension;

  void generate({required CodeAnalysisCollector collector}) {
    for (var classDefinition in classDefinitions) {
      var outputFile = File(p.join(
        outputDirectoryPath,
        '${classDefinition.fileName}$outputExtension',
      ));

      try {
        var out = generateFile(classDefinition);

        outputFile.createSync();
        outputFile.writeAsStringSync(out);

        collector.addGeneratedFile(outputFile);
      } catch (e, stackTrace) {
        print('Failed to generate ${outputFile.path}');
        printInternalError(e, stackTrace);
      }
    }

    // Generate factory class
    var outFile = File(p.join(outputDirectoryPath, 'protocol$outputExtension'));
    var out = generateFactory(classDefinitions);
    outFile.createSync();
    outFile.writeAsStringSync(out);
    collector.addGeneratedFile(outFile);

    if (serverCode) {
      // Generate SQL statements
      var pgsqlGenerator = PgsqlGenerator(
        classInfos: classDefinitions,
        outPath: 'generated/tables.pgsql',
      );
      pgsqlGenerator.generate();
    }
  }

  String generateFile(ProtocolFileDefinition classDefinition);

  String generateFactory(List<ProtocolFileDefinition> classNames);
}
