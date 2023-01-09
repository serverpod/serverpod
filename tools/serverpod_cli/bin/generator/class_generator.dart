import 'dart:io';
import 'package:code_builder/code_builder.dart';
import 'package:path/path.dart' as p;

import '../util/internal_error.dart';
import 'class_generator_dart.dart';
import 'code_analysis_collector.dart';
import 'config.dart';
import 'generator.dart';
import 'pgsql_generator.dart';
import 'protocol_definition.dart';

void performGenerateClasses({
  required bool verbose,
  required List<ProtocolFileDefinition> classDefinitions,
  required CodeAnalysisCollector collector,
  required ProtocolDefinition protocolDefinition,
  required CodeGenerator codeGenerator,
}) {
  // Generate server side code
  if (verbose) print('Generating server side code.');
  var serverGenerator = ClassGeneratorDart(
    verbose: verbose,
    outputDirectoryPath: config.generatedServerProtocolPath,
    serverCode: true,
    classDefinitions: classDefinitions,
    protocolDefinition: protocolDefinition,
  );
  serverGenerator.generate(collector: collector, codeGenerator: codeGenerator);

  // Generate client side code
  if (verbose) print('Generating Dart client side code.');
  var clientGenerator = ClassGeneratorDart(
    verbose: verbose,
    outputDirectoryPath: config.generatedClientProtocolPath,
    serverCode: false,
    classDefinitions: classDefinitions,
    protocolDefinition: protocolDefinition,
  );
  clientGenerator.generate(collector: collector, codeGenerator: codeGenerator);
}

abstract class ClassGenerator {
  final String outputDirectoryPath;
  final bool verbose;
  final bool serverCode;
  final List<ProtocolFileDefinition> classDefinitions;
  final ProtocolDefinition protocolDefinition;

  ClassGenerator({
    required this.verbose,
    required this.classDefinitions,
    required this.outputDirectoryPath,
    required this.serverCode,
    required this.protocolDefinition,
  });

  String get outputExtension;

  void generate({
    required CodeAnalysisCollector collector,
    required CodeGenerator codeGenerator,
  }) {
    for (var classDefinition in classDefinitions) {
      var outputFile = File(p.joinAll([
        outputDirectoryPath,
        ...?classDefinition.subDir?.split('/'),
        '${classDefinition.fileName}$outputExtension'
      ]));

      try {
        var out = generateFile(classDefinition);

        outputFile.createSync(recursive: true);
        outputFile.writeAsStringSync(codeGenerator(out));

        collector.addGeneratedFile(outputFile);
      } catch (e, stackTrace) {
        print('Failed to generate ${outputFile.path}');
        printInternalError(e, stackTrace);
      }
    }

    // Generate factory class
    var outFile = File(p.join(outputDirectoryPath, 'protocol$outputExtension'));
    var out = generateFactory(classDefinitions, protocolDefinition);
    outFile.createSync(recursive: true);
    outFile.writeAsStringSync(codeGenerator(out));
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

  Library generateFile(ProtocolFileDefinition classDefinition);

  Library generateFactory(List<ProtocolFileDefinition> classNames,
      ProtocolDefinition protocolDefinition);
}
