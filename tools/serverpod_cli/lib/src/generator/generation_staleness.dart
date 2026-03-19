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

/// Returns `true` if all [paths] are older than the generation stamp,
/// the stamp's CLI version matches the running version, and all previously
/// generated output files still exist on disk.
bool isGenerationUpToDate(GeneratorConfig config, Set<String> paths) {
  final stampFile = File(_stampFilePath(config));
  if (!stampFile.existsSync()) return false;

  final content = stampFile.readAsStringSync().trim();
  if (content.isEmpty) return false;

  // First line is the CLI version.
  final lines = content.split('\n');
  if (lines.first.trim() != templateVersion) return false;

  // Remaining lines (after version and timestamp) are generated file paths.
  // If any are missing, generation must run.
  if (lines.length > 2) {
    final generatedFiles = lines.skip(2).where((l) => l.isNotEmpty);
    for (final filePath in generatedFiles) {
      if (!File(filePath).existsSync()) return false;
    }
  }

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
///
/// The stamp format is:
/// ```
/// <cli-version>
/// <iso8601-timestamp>
/// <generated-file-path-1>
/// <generated-file-path-2>
/// ...
/// ```
Future<void> writeGenerationStamp(
  GeneratorConfig config, {
  required Set<String> generatedFiles,
}) async {
  final file = File(_stampFilePath(config));
  await file.create(recursive: true);
  final buf = StringBuffer()
    ..writeln(templateVersion)
    ..writeln(DateTime.now().toIso8601String());
  for (final path in generatedFiles) {
    buf.writeln(path);
  }
  await file.writeAsString(buf.toString());
}

/// Enumerates all source files that feed into code generation.
Future<Set<String>> enumerateSourceFiles(GeneratorConfig config) async {
  final sources = <String>{};

  // Server lib/src/ directory.
  final srcDir = Directory(p.joinAll(config.srcSourcePathParts));
  if (await srcDir.exists()) {
    await for (final entity in srcDir.list(recursive: true)) {
      if (entity is File &&
          _sourceExtensions.any((ext) => entity.path.endsWith(ext))) {
        sources.add(entity.path);
      }
    }
  }

  // Shared model packages.
  for (final path in config.sharedModelsLibSourcePaths) {
    final dir = Directory(path);
    if (!await dir.exists()) continue;
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File &&
          _sourceExtensions.any((ext) => entity.path.endsWith(ext))) {
        sources.add(entity.path);
      }
    }
  }

  return sources;
}
