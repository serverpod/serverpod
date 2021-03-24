import 'dart:io';

import 'class_generator_dart.dart';
import 'config.dart';

void performGenerateClasses(bool verbose) {
  // Generate server side code
  print('Generating server side code.');
  var serverGenerator = ClassGeneratorDart(config.sourceProtocol, config.generatedServerProtocol, verbose, true);
  serverGenerator.generate();

  // Generate client side code
  print('Generating Dart client side code.');
  var clientGenerator = ClassGeneratorDart(config.sourceProtocol, config.generatedClientDart, verbose, false);
  clientGenerator.generate();

  print('Done.');
}

abstract class ClassGenerator {
  final String outputPath;
  final String inputPath;
  final bool verbose;

  ClassGenerator(this.inputPath, this.outputPath, this.verbose,);

  String get outputExtension;

  void generate() {
    var classInfos = Set<ClassInfo>();

    // Generate files for each yaml file
    var dir = Directory(inputPath);
    var list = dir.listSync();
    for (var entity in list) {
      if (entity is File && entity.path.endsWith('.yaml')) {
        if (verbose)
          print('  - processing file: ${entity.path}');

        try {
          var outFileName = _transformFileNameWithoutPath(entity.path);
          var outFile = File('$outputPath/$outFileName');

          // Read file
          String yamlStr = entity.readAsStringSync();

          // Generate the code
          var out = generateFile(yamlStr, outFileName, classInfos);

          // Save generated file
          outFile.createSync();
          outFile.writeAsStringSync(out);
        }
        catch(e, stackTrace) {
          print('Failed to generate ${entity.path}');
          print('$e');
          if (verbose)
            print('$stackTrace');
        }
      }
    }

    // Generate factory class
    var outFile = File(outputPath + '/protocol$outputExtension');
    var out = generateFactory(classInfos);
    outFile.createSync();
    outFile.writeAsStringSync(out);
  }

  String generateFile(String input, String outputFileName, Set<ClassInfo> classNames);

  String generateFactory(Set<ClassInfo> classNames);

  String generateEndpoints(String input);

  String _transformFileNameWithoutPath(String path) {
    var pathComponents = path.split('/');
    String fileName = pathComponents[pathComponents.length-1];
    fileName = fileName.substring(0, fileName.length - 5) + outputExtension;
    return fileName;
  }
}


class ClassInfo {
  final String className;
  final String fileName;
  final String tableName;

  ClassInfo({this.className, this.fileName, this.tableName});
}
