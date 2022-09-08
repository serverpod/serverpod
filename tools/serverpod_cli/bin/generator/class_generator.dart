import 'dart:io';
import 'package:path/path.dart' as p;
import 'class_generator_dart.dart';
import 'config.dart';
import 'pgsql_generator.dart';
import 'protocol_definition.dart';

void performGenerateClasses(bool verbose) {
  // Generate server side code
  if (verbose) print('Generating server side code.');
  var serverGenerator = ClassGeneratorDart(config.protocolSourcePath,
      config.generatedServerProtocolPath, verbose, true);
  serverGenerator.generate();

  // Generate client side code
  if (verbose) print('Generating Dart client side code.');
  var clientGenerator = ClassGeneratorDart(config.protocolSourcePath,
      config.generatedClientProtocolPath, verbose, false);
  clientGenerator.generate();
}

abstract class ClassGenerator {
  final String outputPath;
  final String inputPath;
  final bool verbose;
  final bool serverCode;
  final classInfos = <ClassDefinition>{};

  ClassGenerator(
    this.inputPath,
    this.outputPath,
    this.verbose,
    this.serverCode,
  );

  String get outputExtension;

  void generate() {
    // Generate files for each yaml file
    var dir = Directory(inputPath);
    var list = dir.listSync();
    list.sort((a, b) => a.path.compareTo(b.path));
    for (var entity in list) {
      if (entity is File && entity.path.endsWith('.yaml')) {
        if (verbose) print('  - processing file: ${entity.path}');

        try {
          var outFileName = _transformFileNameWithoutPath(entity.path);
          var outFile = File(p.join(outputPath, outFileName));

          // Read file
          var yamlStr = entity.readAsStringSync();

          // Generate the code
          var out = generateFile(yamlStr, outFileName, classInfos);

          // Save generated file
          outFile.createSync();
          outFile.writeAsStringSync(out ?? '');
        } catch (e, stackTrace) {
          print('Failed to generate ${entity.path}');
          print('$e');
          if (verbose) print('$stackTrace');
        }
      }
    }

    // Generate factory class
    var outFile = File(p.join(outputPath, 'protocol$outputExtension'));
    var out = generateFactory(classInfos);
    outFile.createSync();
    outFile.writeAsStringSync(out ?? '');

    if (serverCode) {
      // Generate SQL statements
      var pgsqlGenerator = PgsqlGenerator(
          classInfos: classInfos, outPath: 'generated/tables.pgsql');
      pgsqlGenerator.generate();
    }
  }

  String? generateFile(
      String input, String outputFileName, Set<ClassDefinition> classNames);

  String? generateFactory(Set<ClassDefinition> classNames);

  String _transformFileNameWithoutPath(String path) {
    var pathComponents = path.split(Platform.pathSeparator);
    var fileName = pathComponents.last;
    fileName = fileName.substring(0, fileName.length - 5) + outputExtension;
    return fileName;
  }
}
