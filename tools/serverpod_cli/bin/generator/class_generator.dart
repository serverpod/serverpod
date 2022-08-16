import 'dart:io';
import 'package:path/path.dart' as p;
import 'class_generator_dart.dart';
import 'config.dart';
import 'pgsql_generator.dart';

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
  final classInfos = <ClassInfo>{};

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
      String input, String outputFileName, Set<ClassInfo> classNames);

  String? generateFactory(Set<ClassInfo> classNames);

  String _transformFileNameWithoutPath(String path) {
    var pathComponents = path.split(Platform.pathSeparator);
    var fileName = pathComponents.last;
    fileName = fileName.substring(0, fileName.length - 5) + outputExtension;
    return fileName;
  }
}

class IndexDefinition {
  final String name;
  late final List<String> fields;
  late final String type;
  late final bool unique;

  IndexDefinition(this.name, Map doc) {
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
