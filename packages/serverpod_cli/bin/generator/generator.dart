import 'dart:io';

abstract class Generator {
  final String outputPath;
  final String inputPath;
  final bool verbose;

  Generator(this.inputPath, this.outputPath, this.verbose);

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
    }

    // Generate factory class
    var outFile = File(outputPath + 'protocol.dart');
    var out = generateFactory(classInfos);
    outFile.createSync();
    outFile.writeAsStringSync(out);
  }

  String generateFile(String input, String outputFileName, Set<ClassInfo> classNames);

  String generateFactory(Set<ClassInfo> classNames);

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
