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
    List<FileSystemEntity> protocolSourceFileList = [];
    try {
      var protocolSourceDir =
          Directory(joinAll(config.protocolSourcePathParts));
      protocolSourceFileList =
          await protocolSourceDir.list(recursive: true).toList();
    } on PathNotFoundException catch (_) {}

    List<FileSystemEntity> modelSourceFileList = [];
    try {
      var modelSourceDir = Directory(joinAll(config.modelSourcePathParts));
      modelSourceFileList = await modelSourceDir.list(recursive: true).toList();
    } on PathNotFoundException catch (_) {}

    var sourceFileList = [...protocolSourceFileList, ...modelSourceFileList];

    // TODO This sort is needed to make sure all generated methods
    // are in the same order. Move this logic to the code generator instead.
    sourceFileList.sort((a, b) => a.path.compareTo(b.path));

    var files = sourceFileList.whereType<File>().where(
        (file) => modelFileExtensions.any((ext) => file.path.endsWith(ext)));

    List<ModelSource> sources = [];
    for (var model in files) {
      var yaml = await model.readAsString();

      sources.add(ModelSource(
        defaultModuleAlias,
        yaml,
        model.uri,
        extractPathFromModelRoot(config, model.uri),
      ));
    }

    return sources;
  }

  static List<String> extractPathFromModelRoot(
      GeneratorConfig config, Uri fileUri) {
    var sourceDir = Directory(joinAll(config.protocolSourcePathParts));
    var sourceDirPartsLength = split(sourceDir.path).length;
    return split(dirname(fileUri.path)).skip(sourceDirPartsLength).toList();
  }
}
