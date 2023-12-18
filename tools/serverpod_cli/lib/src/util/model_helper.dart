import 'dart:io';

import 'package:serverpod_cli/src/config/config.dart';
import 'package:path/path.dart';

class ModelSource {
  String yaml;
  Uri yamlSourceUri;
  List<String> protocolRootPathParts;

  ModelSource(this.yaml, this.yamlSourceUri, this.protocolRootPathParts);
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
    var protocolSourceDir = Directory(joinAll(config.protocolSourcePathParts));
    var protocolSourceFileList =
        await protocolSourceDir.list(recursive: true).toList();

    var modelSourceDir = Directory(joinAll(config.modelSourcePathParts));
    var modelSourceFileList =
        await modelSourceDir.list(recursive: true).toList();

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
