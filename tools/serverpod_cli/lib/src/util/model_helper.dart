import 'dart:io';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:path/path.dart';

const String defaultModuleAlias = 'protocol';

class ModelSource {
  String moduleAlias;
  String yaml;
  Uri yamlSourceUri;
  List<String> protocolRootPathParts;

  ModelSource(
    this.moduleAlias,
    this.yaml,
    this.yamlSourceUri,
    this.protocolRootPathParts,
  );
}

const modelFileExtensions = [
  '.yaml',
  '.yml',
  '.spy',
  '.spy.yaml',
  '.spy.yml',
];

class ModelHelper {
  static Future<List<ModelSource>> loadProjectYamlModelsFromDisk(
    GeneratorConfig config,
  ) async {
    var modelSources = <ModelSource>[];

    var modelSource = await _loadYamlModelsFromDisk(
        defaultModuleAlias, _absolutePathParts(config.modelSourcePathParts));
    modelSources.addAll(modelSource);

    modelSource = await _loadYamlModelsFromDisk(
        defaultModuleAlias, _absolutePathParts(config.protocolSourcePathParts));
    modelSources.addAll(modelSource);

    for (var module in config.modulesDependent) {
      modelSource = await _loadYamlModelsFromDisk(
          module.name, module.modelSourcePathParts);
      modelSources.addAll(modelSource);

      modelSource = await _loadYamlModelsFromDisk(
          module.name, module.protocolSourcePathParts);
      modelSources.addAll(modelSource);
    }

    return modelSources;
  }

  static List<String> _absolutePathParts(List<String> pathParts) {
    return split(absolute(joinAll(pathParts)));
  }

  static Future<List<ModelSource>> _loadYamlModelsFromDisk(
    String moduleAlias,
    List<String> pathParts,
  ) async {
    var files = await _loadAllModelFiles(pathParts);

    // TODO This sort is needed to make sure all generated methods
    // are in the same order. Move this logic to the code generator instead.
    files.toList().sort((a, b) => a.path.compareTo(b.path));

    List<ModelSource> sources = [];
    for (var model in files) {
      var yaml = await model.readAsString();

      sources.add(ModelSource(
        moduleAlias,
        yaml,
        model.uri,
        extractPathFromModelRoot(pathParts, model.uri),
      ));
    }

    return sources;
  }

  static Future<Iterable<File>> _loadAllModelFiles(
    List<String> absolutePathParts,
  ) async {
    List<FileSystemEntity> modelSourceFileList = [];

    var dir = Directory('/${joinAll(absolutePathParts)}');

    try {
      var modelSourceDir = dir;
      modelSourceFileList = await modelSourceDir.list(recursive: true).toList();
    } on PathNotFoundException catch (_) {}

    return modelSourceFileList.whereType<File>().where(
        (file) => modelFileExtensions.any((ext) => file.path.endsWith(ext)));
  }

  static List<String> extractPathFromModelRoot(
    List<String> pathParts,
    Uri fileUri,
  ) {
    var sourceDir = Directory(joinAll(pathParts));
    var sourceDirPartsLength = split(sourceDir.path).length;
    return split(dirname(fileUri.path)).skip(sourceDirPartsLength).toList();
  }
}
