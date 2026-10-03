import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:yaml/yaml.dart';

/// A model file that uses a bare `.yaml`/`.yml` extension, which Serverpod
/// no longer recognizes as a model file.
class LegacyModelFile {
  /// Absolute path of the file.
  final String path;

  /// Nickname of the module the file belongs to, or `null` when the file is
  /// part of the project itself (server or shared package).
  final String? moduleNickname;

  LegacyModelFile(this.path, {this.moduleNickname});
}

/// Serverpod 3 accepted bare `.yaml`/`.yml` model files in these directories.
/// Serverpod 4 requires one of the [modelFileExtensions], so such files are
/// silently ignored unless reported to the user.
abstract final class LegacyModelFiles {
  static const _legacyExtensions = ['.yaml', '.yml'];
  static const _legacyModelDirectories = [
    ['lib', 'src', 'models'],
    ['lib', 'src', 'protocol'],
  ];
  static const _modelKeys = ['class', 'enum', 'exception'];

  /// Finds bare yaml model files in the project's server package, its shared
  /// packages, and its dependent modules.
  static Future<List<LegacyModelFile>> find(GeneratorConfig config) async {
    var found = <LegacyModelFile>[];

    await _collect(found, config.serverPackageDirectoryPathParts);
    for (var sharedPathParts in config.sharedModelsSourcePathsParts.values) {
      await _collect(found, [
        ...config.serverPackageDirectoryPathParts,
        ...sharedPathParts,
      ]);
    }

    for (var module in config.modulesDependent) {
      await _collect(
        found,
        module.serverPackageDirectoryPathParts,
        moduleNickname: module.nickname,
      );
      for (var sharedPathParts in module.sharedPackageRootPathParts.values) {
        await _collect(
          found,
          sharedPathParts,
          moduleNickname: module.nickname,
        );
      }
    }

    found.sort((a, b) => a.path.compareTo(b.path));
    return found;
  }

  /// Logs an error for any legacy model files found in [config], explaining
  /// how to fix them. Returns `true` when at least one file was reported.
  static Future<bool> report(GeneratorConfig config) async {
    var files = await find(config);
    if (files.isEmpty) return false;

    var projectFiles = files.where((f) => f.moduleNickname == null).toList();
    var moduleFiles = files.where((f) => f.moduleNickname != null).toList();

    if (projectFiles.isNotEmpty) {
      var serverDir = p.absolute(
        p.joinAll(config.serverPackageDirectoryPathParts),
      );
      var buffer = StringBuffer(
        'Model files must use the ${modelFileExtensions.first} extension. '
        'The following files are ignored:\n',
      );
      for (var file in projectFiles) {
        buffer.writeln('  ${p.relative(file.path, from: serverDir)}');
      }
      buffer.write(
        'Rename the files to use the ${modelFileExtensions.first} extension '
        'and run the command again.',
      );
      log.error(buffer.toString());
    }

    for (var nickname in moduleFiles.map((f) => f.moduleNickname).toSet()) {
      var buffer = StringBuffer(
        'The module "$nickname" contains model files without the '
        '${modelFileExtensions.first} extension, which are ignored:\n',
      );
      for (var file in moduleFiles.where((f) => f.moduleNickname == nickname)) {
        buffer.writeln('  ${file.path}');
      }
      buffer.write(
        'Update the module to a version compatible with Serverpod 4.',
      );
      log.error(buffer.toString());
    }

    return true;
  }

  static Future<void> _collect(
    List<LegacyModelFile> found,
    List<String> packageRootPathParts, {
    String? moduleNickname,
  }) async {
    for (var directoryParts in _legacyModelDirectories) {
      var directory = Directory(
        p.absolute(p.joinAll([...packageRootPathParts, ...directoryParts])),
      );
      if (!await directory.exists()) continue;

      await for (var entity in directory.list(recursive: true)) {
        if (entity is! File) continue;
        if (!_isLegacyModelFile(entity)) continue;
        found.add(
          LegacyModelFile(entity.path, moduleNickname: moduleNickname),
        );
      }
    }
  }

  /// Whether [file] has a bare yaml extension and a top-level model key.
  /// Files that cannot be read or parsed as yaml maps are not models, and
  /// are ignored.
  static bool _isLegacyModelFile(File file) {
    var path = file.path;
    if (ModelHelper.isModelFile(path)) return false;
    if (!_legacyExtensions.any(path.endsWith)) return false;

    try {
      var document = loadYaml(file.readAsStringSync());
      return document is YamlMap &&
          _modelKeys.any((key) => document.containsKey(key));
    } on FileSystemException {
      return false;
    } on YamlException {
      return false;
    }
  }
}
