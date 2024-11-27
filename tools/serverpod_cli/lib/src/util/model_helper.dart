import 'dart:io';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:path/path.dart';
import 'package:super_string/super_string.dart';

const String defaultModuleAlias = 'protocol';

class ModelSource {
  String moduleAlias;
  String yaml;
  Uri yamlSourceUri;
  List<String> subDirPathParts;

  ModelSource(
    this.moduleAlias,
    this.yaml,
    this.yamlSourceUri,
    this.subDirPathParts,
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

    var relativeModelSourcePath = joinAll(config.relativeModelSourcePathParts);
    var relativeProtocolSourcePath =
        joinAll(config.relativeProtocolSourcePathParts);

    var modelSource = await _loadYamlModelsFromDisk(
      defaultModuleAlias,
      _absolutePathParts(config.modelSourcePathParts),
      relativeModelSourcePath: relativeModelSourcePath,
      relativeProtocolSourcePath: relativeProtocolSourcePath,
    );
    modelSources.addAll(modelSource);

    modelSource = await _loadYamlModelsFromDisk(
      defaultModuleAlias,
      _absolutePathParts(config.protocolSourcePathParts),
      relativeModelSourcePath: relativeModelSourcePath,
      relativeProtocolSourcePath: relativeProtocolSourcePath,
    );
    modelSources.addAll(modelSource);

    for (var module in config.modulesDependent) {
      modelSource = await _loadYamlModelsFromDisk(
        module.nickname,
        module.modelSourcePathParts,
        relativeModelSourcePath: relativeModelSourcePath,
        relativeProtocolSourcePath: relativeProtocolSourcePath,
      );
      modelSources.addAll(modelSource);

      modelSource = await _loadYamlModelsFromDisk(
        module.nickname,
        module.protocolSourcePathParts,
        relativeModelSourcePath: relativeModelSourcePath,
        relativeProtocolSourcePath: relativeProtocolSourcePath,
      );
      modelSources.addAll(modelSource);
    }

    // TODO This sort is needed to make sure all generated methods
    // are in the same order. Move this logic to the code generator instead.
    modelSources
        .sort((a, b) => a.yamlSourceUri.path.compareTo(b.yamlSourceUri.path));

    return modelSources;
  }

  static List<String> _absolutePathParts(List<String> pathParts) {
    return split(absolute(joinAll(pathParts)));
  }

  static Future<List<ModelSource>> _loadYamlModelsFromDisk(
    String moduleAlias,
    List<String> pathParts, {
    required String relativeModelSourcePath,
    required String relativeProtocolSourcePath,
  }) async {
    var files = await _loadAllModelFiles(
      pathParts,
      relativeModelSourcePath: relativeModelSourcePath,
      relativeProtocolSourcePath: relativeProtocolSourcePath,
    );

    List<ModelSource> sources = [];
    for (var model in files) {
      var yaml = await model.readAsString();

      sources.add(ModelSource(
        moduleAlias,
        yaml,
        model.uri,
        _extractPathFromModelRoot(pathParts, model.uri),
      ));
    }

    return sources;
  }

  static bool isModelFile(
    String path,
    String modelSourcePath,
    String protocolSourcePath,
  ) {
    var hasValidPath = path.containsAny([
      modelSourcePath,
      protocolSourcePath,
    ]);

    var hasValidExtension = modelFileExtensions.any(
      (ext) => path.endsWith(ext),
    );

    return hasValidPath && hasValidExtension;
  }

  static Future<Iterable<File>> _loadAllModelFiles(
    List<String> absolutePathParts, {
    required String relativeModelSourcePath,
    required String relativeProtocolSourcePath,
  }) async {
    List<FileSystemEntity> modelSourceFileList = [];

    var path = joinAll(absolutePathParts);

    if (!isAbsolute(path)) {
      path =
          Platform.isWindows ? '$separator$separator$path' : '$separator$path';
    }

    var modelSourceDir = Directory(path);

    var isDirectoryAvailable = await modelSourceDir.exists();

    if (isDirectoryAvailable) {
      modelSourceFileList = await modelSourceDir.list(recursive: true).toList();
    }

    return modelSourceFileList.whereType<File>().where((file) => isModelFile(
          file.path,
          relativeModelSourcePath,
          relativeProtocolSourcePath,
        ));
  }

  static List<String> extractPathFromConfig(GeneratorConfig config, Uri uri) {
    if (isWithin(joinAll(config.protocolSourcePathParts), uri.path)) {
      return _extractPathFromModelRoot(config.protocolSourcePathParts, uri);
    }

    if (isWithin(joinAll(config.modelSourcePathParts), uri.path)) {
      return _extractPathFromModelRoot(config.modelSourcePathParts, uri);
    }

    return split(uri.path);
  }

  static List<String> _extractPathFromModelRoot(
    List<String> pathParts,
    Uri fileUri,
  ) {
    var sourceDir = Directory(joinAll(pathParts));
    var sourceDirPartsLength = split(sourceDir.path).length;

    return split(dirname(fromUri(fileUri))).skip(sourceDirPartsLength).toList();
  }
}
