import 'dart:io';

import 'package:yaml/yaml.dart';

import 'class_generator_dart.dart';

void performGenerateClasses(bool verbose,) {
  // Load config file for generation
  Map generatorConfig;
  try {
    var file = File('config/generate.yaml');
    var yamlStr = file.readAsStringSync();
    generatorConfig = loadYaml(yamlStr);
  }
  catch(_) {
    print('Failed to load config/generator.yaml. Are you running serverpod from your projects root directory?');
    return;
  }

  String pathServer = generatorConfig['server'];
  if (pathServer == null) {
    print('Option "server" is required in config/generator.yaml');
    return;
  }

  String pathSource = generatorConfig['source'];
  if (pathSource == null) {
    print('Option "source" is required in config/generator.yaml');
  }

  // Generate server side code
  print('Generating server side code.');
  var generator = ClassGeneratorDart(pathSource, pathServer, verbose, true);
  generator.generate();

  // Generate client side code
  String pathClientDart = generatorConfig['client-dart'];
  if (pathClientDart != null) {
    print('Generating Dart client side code.');
    var clientGenerator = ClassGeneratorDart(pathSource, pathClientDart, verbose, false);
    clientGenerator.generate();
  }

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
          print('  - processing file: ${inputPath}');

        try {
          var outFileName = _transformFileNameWithoutPath(entity.path);
          var outFile = File('$outputPath$outFileName');

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
    var outFile = File(outputPath + 'protocol$outputExtension');
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
