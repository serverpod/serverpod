import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';

/// Extensions considered as code-generation source files.
const _sourceExtensions = ['.dart', ...modelFileExtensions];

/// Path to the generation stamp file for the given [config].
String _stampFilePath(GeneratorConfig config) => p.joinAll([
  ...config.serverPackageDirectoryPathParts,
  '.dart_tool',
  'serverpod',
  'generation.stamp',
]);

/// Returns `true` if all [paths] are older than the generation stamp
/// and the stamp's CLI version matches the running version.
bool isGenerationUpToDate(GeneratorConfig config, Set<String> paths) {
  final stampFile = File(_stampFilePath(config));
  if (!stampFile.existsSync()) return false;

  final content = stampFile.readAsStringSync().trim();
  if (content.isEmpty) return false;

  // First line is the CLI version.
  final lines = content.split('\n');
  if (lines.first.trim() != templateVersion) return false;

  final stampMtime = stampFile.statSync().modified;

  // Check config/generator.yaml - config changes should trigger regen.
  final configFile = File(
    p.joinAll([
      ...config.serverPackageDirectoryPathParts,
      'config',
      'generator.yaml',
    ]),
  );
  if (configFile.existsSync() &&
      configFile.statSync().modified.isAfter(stampMtime)) {
    return false;
  }

  for (final path in paths) {
    final file = File(path);
    if (file.existsSync() && file.statSync().modified.isAfter(stampMtime)) {
      return false;
    }
  }

  return true;
}

/// Writes the generation stamp file after a successful generation.
Future<void> writeGenerationStamp(GeneratorConfig config) async {
  final file = File(_stampFilePath(config));
  await file.create(recursive: true);
  await file.writeAsString(
    '$templateVersion\n${DateTime.now().toIso8601String()}\n',
  );
}

/// Enumerates all source files that feed into code generation.
Set<String> enumerateSourceFiles(GeneratorConfig config) {
  final sources = <String>{};

  // Server lib/src/ directory.
  final srcDir = Directory(p.joinAll(config.srcSourcePathParts));
  if (srcDir.existsSync()) {
    for (final entity in srcDir.listSync(recursive: true)) {
      if (entity is File &&
          _sourceExtensions.any((ext) => entity.path.endsWith(ext))) {
        sources.add(entity.path);
      }
    }
  }

  // Shared model packages.
  for (final pathParts in config.sharedModelsSourcePathsParts.values) {
    final dir = Directory(
      p.joinAll([
        ...config.serverPackageDirectoryPathParts,
        ...pathParts,
        'lib',
      ]),
    );
    if (!dir.existsSync()) continue;
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is File &&
          _sourceExtensions.any((ext) => entity.path.endsWith(ext))) {
        sources.add(entity.path);
      }
    }
  }

  return sources;
}
