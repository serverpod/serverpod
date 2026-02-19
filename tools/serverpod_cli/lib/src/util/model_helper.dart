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
  bool isSharedModel;

  ModelSource(
    this.moduleAlias,
    this.yaml,
    this.yamlSourceUri,
    this.subDirPathParts,
    this.isSharedModel,
  );

  String? get sharedPackageName => isSharedModel ? moduleAlias : null;
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

/// Relative path parts from package root to model roots (most specific first).
const _modelRootSuffixes = [
  ['lib', 'src', 'models'],
  ['lib', 'src', 'protocol'],
  ['lib', 'src'],
];

class ModelHelper {
  static Future<List<ModelSource>> loadProjectYamlModelsFromDisk(
    GeneratorConfig config,
  ) async {
    var modelSources = <ModelSource>[];

    for (var e in config.sharedModelsSourcePathsParts.entries) {
      var sharedPackageAbsolutePath = _absolutePathParts(
        [...config.serverPackageDirectoryPathParts, ...e.value],
      );
      modelSources.addAll(
        await _loadYamlModelsFromDisk(
          moduleAlias: e.key,
          loadConfig: config,
          absoluteSourcePathParts: sharedPackageAbsolutePath,
          isSharedModel: true,
        ),
      );
    }

    var modelSource = await _loadYamlModelsFromDisk(
      moduleAlias: defaultModuleAlias,
      loadConfig: config,
      absoluteSourcePathParts: _absolutePathParts(config.libSourcePathParts),
      isSharedModel: false,
    );
    modelSources.addAll(modelSource);

    for (var moduleConfig in config.modulesDependent) {
      modelSource = await _loadYamlModelsFromDisk(
        moduleAlias: moduleConfig.nickname,
        loadConfig: moduleConfig,
        absoluteSourcePathParts: moduleConfig.libSourcePathParts,
        isSharedModel: false,
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
    required bool isSharedModel,
  }) async {
    var files = await _loadAllModelFiles(
      loadConfig: loadConfig,
      absoluteSourcePathParts,
    );

    List<ModelSource> sources = [];
    for (var model in files) {
      var yaml = await model.readAsString();

      var subDirPathParts = isSharedModel
          ? _extractPathFromSharedPackageRoot(
              absoluteSourcePathParts,
              model.uri,
            )
          : extractPathFromConfig(loadConfig, model.uri);

      sources.add(
        ModelSource(
          moduleAlias,
          yaml,
          model.uri,
          subDirPathParts,
          isSharedModel,
        ),
      );
    }

    return sources;
  }

  /// Extracts subDirPathParts for a file in a package, relative to the
  /// package's lib/src/models, lib/src/protocol, or lib/src directory.
  static List<String> _extractPathFromSharedPackageRoot(
    List<String> packageRootPathParts,
    Uri fileUri,
  ) {
    var filePath = fileUri.toFilePath();
    for (var suffix in _modelRootSuffixes) {
      var rootPath = absolute(joinAll([...packageRootPathParts, ...suffix]));
      if (isWithin(rootPath, filePath)) {
        return _extractPathFromModelRoot(Directory(rootPath), fileUri);
      }
    }
    return [];
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

    var fromUri = _extractPathFromUriPath(uri);
    if (fromUri.isNotEmpty) return fromUri;
    return split(uri.toFilePath());
  }

  /// Fallback when no config root matches the URI. Needed when path resolution
  /// differs (e.g. LSP document URIs vs config paths, or isolates with another
  /// cwd). Infers package root by finding "lib/src/models" or similar in the
  /// path, then reuses [_extractPathFromSharedPackageRoot].
  static List<String> _extractPathFromUriPath(Uri uri) {
    var normalizedDir = absolute(dirname(uri.toFilePath()));
    for (var suffixParts in _modelRootSuffixes) {
      var suffix = joinAll(suffixParts);
      var idx = normalizedDir.indexOf(suffix);
      if (idx != -1) {
        var packageRootPath = normalizedDir.substring(0, idx);
        var packageRootPathParts = split(absolute(packageRootPath));
        return _extractPathFromSharedPackageRoot(packageRootPathParts, uri);
      }
    }
    return [];
  }

  /// If [absolutePath] is under a shared package's lib, returns that package's
  /// alias and root path parts; otherwise null (server or unknown).
  static ({String alias, List<String> rootParts})? _findSharedPackageForPath(
    GeneratorConfig config,
    String absolutePath,
  ) {
    var serverLibPath = absolute(
      joinAll([...config.serverPackageDirectoryPathParts, 'lib']),
    );
    if (isWithin(serverLibPath, absolutePath)) return null;
    for (var e in config.sharedModelsSourcePathsParts.entries) {
      var rootParts = [
        ...config.serverPackageDirectoryPathParts,
        ...e.value,
      ];
      var sharedLibPath = absolute(joinAll([...rootParts, 'lib']));
      if (isWithin(sharedLibPath, absolutePath)) {
        return (alias: e.key, rootParts: rootParts);
      }
    }
    return null;
  }

  /// Creates a [ModelSource] for the given [path] and [yaml] content.
  /// Used when a model file is added or modified (e.g. in continuous generation).
  /// Returns the correct [moduleAlias] and [subDirPathParts] for server or
  /// shared package paths.
  static ModelSource createModelSourceForPath(
    GeneratorConfig config,
    String path,
    String yaml,
  ) {
    var absolutePath = absolute(path);
    var uri = Uri.file(absolutePath);
    var shared = _findSharedPackageForPath(config, absolutePath);
    var moduleAlias = shared?.alias ?? defaultModuleAlias;
    var subDirParts = shared != null
        ? _extractPathFromSharedPackageRoot(shared.rootParts, uri)
        : extractPathFromConfig(config, uri);

    return ModelSource(
      moduleAlias,
      yaml,
      uri,
      subDirParts,
      shared != null,
    );
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
