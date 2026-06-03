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
/// Pass [sourceFiles] (the set already enumerated this run) to skip a second
/// directory walk; omit it to re-enumerate the full set.
Future<void> writeGenerationStamp(
  GeneratorConfig config, {
  required Set<String> generatedFiles,
  Set<String>? sourceFiles,
}) async {
  final sources = sourceFiles ?? await enumerateSourceFiles(config);
  final fingerprint = _sourceSetFingerprint(sources);
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
///
/// Generated output dirs are excluded - they are outputs, and including them
/// would make the set differ before vs. after a generation.
Future<Set<String>> enumerateSourceFiles(GeneratorConfig config) async {
  final sources = <String>{};

  final generatedDirs = {
    p.absolute(p.joinAll(config.generatedServeModelPathParts)),
    ...config.generatedSharedModelsPaths.map(p.absolute),
  };
  bool isGenerated(String path) =>
      generatedDirs.any((dir) => p.isWithin(dir, p.absolute(path)));

  Future<void> collect(Directory dir, List<String> extensions) async {
    if (!await dir.exists()) return;
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File &&
          extensions.any((ext) => entity.path.endsWith(ext)) &&
          !isGenerated(entity.path)) {
        sources.add(entity.path);
      }
    }
  }

  // Server lib/ directory. Endpoints and models can live anywhere under lib/,
  // matching the endpoint analyzer and model loader (not just lib/src/).
  await collect(
    Directory(p.joinAll(config.libSourcePathParts)),
    _sourceExtensions,
  );

  // Shared model packages.
  for (final path in config.sharedModelsLibSourcePaths) {
    await collect(Directory(path), _sourceExtensions);
  }

  return sources;
}
