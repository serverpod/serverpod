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

/// Deterministic fingerprint of the source-file *set*.
///
/// Used to detect added or removed source files, which the mtime checks alone
/// cannot: a deleted file has no mtime left to compare against the stamp.
/// 32-bit FNV-1a over the sorted paths - stable across runs, unlike
/// [Object.hashCode].
String _sourceSetFingerprint(Set<String> paths) {
  final sorted = paths.toList()..sort();
  var hash = 0x811c9dc5;
  for (final unit in sorted.join('\n').codeUnits) {
    hash = ((hash ^ unit) * 0x01000193) & 0xFFFFFFFF;
  }
  return hash.toRadixString(16);
}

/// Returns `true` if all [paths] are older than the generation stamp, the
/// stamp's CLI version matches the running version, the source-file set is
/// unchanged, and all previously generated output files still exist on disk.
Future<bool> isGenerationUpToDate(
  GeneratorConfig config,
  Set<String> paths,
) async {
  final stampFile = File(_stampFilePath(config));
  if (!await stampFile.exists()) return false;

  final content = (await stampFile.readAsString()).trim();
  if (content.isEmpty) return false;

  // Line 0: CLI version. Line 1: timestamp. Line 2: source-set fingerprint.
  // Remaining lines: generated file paths.
  final lines = content.split('\n');
  if (lines.length < 3) return false;
  if (lines.first.trim() != templateVersion) return false;

  // A fingerprint mismatch means a source file was added or removed.
  if (lines[2].trim() != _sourceSetFingerprint(paths)) return false;

  // If any previously generated file is missing, generation must run.
  if (lines.length > 3) {
    final generatedFiles = lines.skip(3).where((l) => l.isNotEmpty);
    for (final filePath in generatedFiles) {
      if (!await File(filePath).exists()) return false;
    }
  }

  final stampMtime = (await stampFile.stat()).modified;

  // Check config/generator.yaml - config changes should trigger regen.
  final configFile = File(
    p.joinAll([
      ...config.serverPackageDirectoryPathParts,
      'config',
      'generator.yaml',
    ]),
  );
  if (await configFile.exists() &&
      (await configFile.stat()).modified.isAfter(stampMtime)) {
    return false;
  }

  for (final path in paths) {
    final file = File(path);
    if (await file.exists() &&
        (await file.stat()).modified.isAfter(stampMtime)) {
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
/// <source-set-fingerprint>
/// <generated-file-path-1>
/// <generated-file-path-2>
/// ...
/// ```
Future<void> writeGenerationStamp(
  GeneratorConfig config, {
  required Set<String> generatedFiles,
}) async {
  final fingerprint = _sourceSetFingerprint(await enumerateSourceFiles(config));
  final file = File(_stampFilePath(config));
  await file.create(recursive: true);
  final buf = StringBuffer()
    ..writeln(templateVersion)
    ..writeln(DateTime.now().toIso8601String())
    ..writeln(fingerprint);
  for (final path in generatedFiles) {
    buf.writeln(path);
  }
  await file.writeAsString(buf.toString());
}

/// Reads the list of previously generated files from the generation stamp.
///
/// Returns an empty set if the stamp file doesn't exist or is malformed.
Set<String> readGenerationStamp(GeneratorConfig config) {
  try {
    final stampFile = File(_stampFilePath(config));
    final lines = stampFile.readAsLinesSync();
    // Lines 0-2 are version, timestamp, and fingerprint; the rest are paths.
    return lines.skip(3).where((l) => l.isNotEmpty).toSet();
  } catch (e) {
    return {};
  }
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
