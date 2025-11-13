import 'dart:io';

import 'package:path/path.dart';
import 'package:serverpod_cli/src/config/config.dart';
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

const spyModelFileExtensions = [
  '.spy',
  '.spy.yaml',
  '.spy.yml',
];

const yamlModelFileExtensions = [
  '.yaml',
  '.yml',
];

const modelFileExtensions = [
  ...spyModelFileExtensions,
  ...yamlModelFileExtensions,
];

class ModelHelper {
  static Future<List<ModelSource>> loadProjectYamlModelsFromDisk(
    GeneratorConfig config,
  ) async {
    var modelSources = <ModelSource>[];

    var modelSource = await _loadYamlModelsFromDisk(
      moduleAlias: defaultModuleAlias,
      loadConfig: config,
      absoluteSourcePathParts: _absolutePathParts(config.libSourcePathParts),
    );
    modelSources.addAll(modelSource);

    for (var moduleConfig in config.modulesDependent) {
      modelSource = await _loadYamlModelsFromDisk(
        moduleAlias: moduleConfig.nickname,
        loadConfig: moduleConfig,
        absoluteSourcePathParts: moduleConfig.libSourcePathParts,
      );
      modelSources.addAll(modelSource);
    }

    // This sort is needed to make sure all analyzed models are processed in
    // the same order. This affects the order of partial imports in sealed
    // classes.
    modelSources.sort(
      (a, b) => a.yamlSourceUri.path.compareTo(b.yamlSourceUri.path),
    );

    return modelSources;
  }

  static List<String> _absolutePathParts(List<String> pathParts) {
    return split(absolute(joinAll(pathParts)));
  }

  static Future<List<ModelSource>> _loadYamlModelsFromDisk({
    required List<String> absoluteSourcePathParts,
    required ModelLoadConfig loadConfig,
    required String moduleAlias,
  }) async {
    var files = await _loadAllModelFiles(
      loadConfig: loadConfig,
      absoluteSourcePathParts,
    );

    List<ModelSource> sources = [];
    for (var model in files) {
      var yaml = await model.readAsString();

      sources.add(
        ModelSource(
          moduleAlias,
          yaml,
          model.uri,
          extractPathFromConfig(
            loadConfig,
            model.uri,
          ),
        ),
      );
    }

    return sources;
  }

  static bool isModelFile(
    String path, {
    required ModelLoadConfig loadConfig,
  }) {
    if (spyModelFileExtensions.any((ext) => path.endsWith(ext))) {
      return true;
    }

    var allowedYamlExtensionModelPaths = [
      joinAll(loadConfig.relativeModelSourcePathParts),
      joinAll(loadConfig.relativeProtocolSourcePathParts),
    ];

    var allowedYamlPath = path.containsAny(allowedYamlExtensionModelPaths);

    var yamlExtension = yamlModelFileExtensions.any(
      (ext) => path.endsWith(ext),
    );

    return allowedYamlPath && yamlExtension;
  }

  static Future<Iterable<File>> _loadAllModelFiles(
    List<String> absolutePathParts, {
    required ModelLoadConfig loadConfig,
  }) async {
    List<FileSystemEntity> modelSourceFileList = [];

    var path = joinAll(absolutePathParts);

    if (!isAbsolute(path)) {
      path = Platform.isWindows
          ? '$separator$separator$path'
          : '$separator$path';
    }

    var modelSourceDir = Directory(path);

    var isDirectoryAvailable = await modelSourceDir.exists();

    if (isDirectoryAvailable) {
      modelSourceFileList = await modelSourceDir.list(recursive: true).toList();
    }

    return modelSourceFileList.whereType<File>().where(
      (file) => isModelFile(
        file.path,
        loadConfig: loadConfig,
      ),
    );
  }

  static List<String> extractPathFromConfig(
    ModelLoadConfig config,
    Uri uri,
  ) {
    List<List<String>> modelRootPathParts = [
      config.protocolSourcePathParts,
      config.modelSourcePathParts,
      config.srcSourcePathParts,
      config.libSourcePathParts,
    ];

    for (var pathParts in modelRootPathParts) {
      var directory = Directory(joinAll(pathParts));
      if (isWithin(directory.absolute.path, uri.toFilePath())) {
        return _extractPathFromModelRoot(directory, uri);
      }
    }

    return split(uri.path);
  }

  static List<String> _extractPathFromModelRoot(
    Directory sourceDir,
    Uri fileUri,
  ) {
    var relativePath = relative(
      dirname(fileUri.toFilePath()),
      from: sourceDir.path,
    );

    if (relativePath == '.') {
      return [];
    }

    return split(relativePath);
  }
}
