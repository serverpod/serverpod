import 'dart:io';

import 'class_generator_dart.dart';
import 'config.dart';
import 'pgsql_generator.dart';

void performGenerateClasses(bool verbose) {
  // Generate server side code
  if (verbose) print('Generating server side code.');
  ClassGeneratorDart serverGenerator = ClassGeneratorDart(config.protocolSourcePath,
      config.generatedServerProtocolPath, verbose, true);
  serverGenerator.generate();

  // Generate client side code
  if (verbose) print('Generating Dart client side code.');
  ClassGeneratorDart clientGenerator = ClassGeneratorDart(config.protocolSourcePath,
      config.generatedClientProtocolPath, verbose, false);
  clientGenerator.generate();
}

abstract class ClassGenerator {
  final String outputPath;
  final String inputPath;
  final bool verbose;
  final Set<ClassInfo> classInfos = <ClassInfo>{};

  ClassGenerator(
    this.inputPath,
    this.outputPath,
    this.verbose,
  );

  String get outputExtension;

  void generate() {
    // Generate files for each yaml file
    Directory dir = Directory(inputPath);
    List<FileSystemEntity> list = dir.listSync();
    list.sort((FileSystemEntity a, FileSystemEntity b) => a.path.compareTo(b.path));
    for (FileSystemEntity entity in list) {
      if (entity is File && entity.path.endsWith('.yaml')) {
        if (verbose) print('  - processing file: ${entity.path}');

        try {
          String outFileName = _transformFileNameWithoutPath(entity.path);
          File outFile = File('$outputPath/$outFileName');

          // Read file
          String yamlStr = entity.readAsStringSync();

          // Generate the code
          String? out = generateFile(yamlStr, outFileName, classInfos);

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
    File outFile = File(outputPath + '/protocol$outputExtension');
    String? out = generateFactory(classInfos);
    outFile.createSync();
    outFile.writeAsStringSync(out ?? '');

    // Generate SQL statements
    PgsqlGenerator pgsqlGenerator = PgsqlGenerator(
        classInfos: classInfos, outPath: 'generated/tables.pgsql');
    pgsqlGenerator.generate();
  }

  String? generateFile(
      String input, String outputFileName, Set<ClassInfo> classNames);

  String? generateFactory(Set<ClassInfo> classNames);

  String _transformFileNameWithoutPath(String path) {
    List<String> pathComponents = path.split(Platform.pathSeparator);
    String fileName = pathComponents[pathComponents.length - 1];
    fileName = fileName.substring(0, fileName.length - 5) + outputExtension;
    return fileName;
  }
}

class IndexDefinition {
  final String name;
  late final List<String> fields;
  late final String type;
  late final bool unique;

  IndexDefinition(this.name, Map<String, dynamic> doc) {
    String fieldsStr = doc['fields'];
    fields = fieldsStr.split(',').map((String str) => str.trim()).toList();
    type = doc['type'] ?? 'btree';
    unique = (doc['unique'] ?? 'false') != 'false';
  }
}

class ClassInfo {
  final String className;
  final String fileName;
  final String? tableName;
  final List<FieldDefinition> fields;
  final List<IndexDefinition>? indexes;

  ClassInfo({
    required this.className,
    required this.fileName,
    required this.fields,
    this.tableName,
    this.indexes,
  });
}
