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

/// A [FileStat] viewed as just its staleness-relevant identity.
extension type FileStamp(FileStat _stat) {
  /// Fingerprint token for a file that does not exist.
  static const absent = '-1\t-1';

  /// Returns the [FileStamp] of [path], or `null` if it does not exist.
  static Future<FileStamp?> of(String path) async {
    final stat = await FileStat.stat(path);
    return stat.type == FileSystemEntityType.notFound ? null : FileStamp(stat);
  }

  /// The fingerprint token
  String get token => '${_stat.modified.microsecondsSinceEpoch}\t${_stat.size}';
}

/// Computes a deterministic 32-bit FNV-1a fingerprint of [entries].
String _fingerprint(Map<String, FileStamp?> entries) {
  final lines = [
    for (final path in entries.keys.toList()..sort())
      '$path\t${entries[path]?.token ?? FileStamp.absent}',
  ];
  var hash = 0x811c9dc5;
  for (final unit in lines.join('\n').codeUnits) {
    hash = ((hash ^ unit) * 0x01000193) & 0xFFFFFFFF;
  }
  return hash.toRadixString(16);
}

/// Computes the fingerprint for a generation over
/// - [sourceStats] (inputs stat'd before generation), and
/// - [generatedFiles]
Future<String> _computeFingerprint(
  GeneratorConfig config, {
  required Map<String, FileStamp> sourceStats,
  required Set<String> generatedFiles,
}) async {
  final entries = <String, FileStamp?>{...sourceStats};
  for (final path in config.auxiliaryInputPaths) {
    entries[path] = await FileStamp.of(path);
  }
  for (final path in generatedFiles) {
    entries[path] = await FileStamp.of(path);
  }

  return _fingerprint(entries);
}

/// Returns `true` if the running CLI version matches the stamp and the
/// input+output fingerprint is unchanged since the last generation.
Future<bool> isGenerationUpToDate(
  GeneratorConfig config,
  Map<String, FileStamp> sources,
) async {
  final stampFile = File(_stampFilePath(config));
  if (!await stampFile.exists()) return false;

  // Line 0: CLI version. Line 1: fingerprint. Remaining lines: generated paths.
  final lines = (await stampFile.readAsString()).split('\n');
  if (lines.length < 2) return false;
  if (lines[0].trim() != templateVersion) return false;

  final generatedFiles = lines.skip(2).where((l) => l.isNotEmpty).toSet();
  final current = await _computeFingerprint(
    config,
    sourceStats: sources,
    generatedFiles: generatedFiles,
  );
  return lines[1].trim() == current;
}

/// Writes the generation stamp file after a successful generation.
///
/// The stamp format is:
/// ```
/// <cli-version>
/// <input-output-fingerprint>
/// <generated-file-path-1>
/// <generated-file-path-2>
/// ...
/// ```
/// Pass [sourceStats] to reuse them; omit it to re-enumerate the full set.
Future<void> writeGenerationStamp(
  GeneratorConfig config, {
  required Set<String> generatedFiles,
  Map<String, FileStamp>? sourceStats,
}) async {
  final stats = sourceStats ?? await enumerateSourceFiles(config);
  final fingerprint = await _computeFingerprint(
    config,
    sourceStats: stats,
    generatedFiles: generatedFiles,
  );
  final file = File(_stampFilePath(config));
  await file.create(recursive: true);
  final buf = StringBuffer()
    ..writeln(templateVersion)
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
    // Lines 0-1 are version and fingerprint; the rest are generated paths.
    return lines.skip(2).where((l) => l.isNotEmpty).toSet();
  } catch (e) {
    return {};
  }
}

/// Enumerates the source files that feed code generation, capturing each one's
/// [FileStamp] as the walk reads it.
Future<Map<String, FileStamp>> enumerateSourceFiles(
  GeneratorConfig config,
) async {
  final generatedDirs = {
    p.absolute(p.joinAll(config.generatedServeModelPathParts)),
    ...config.generatedSharedModelsPaths.map(p.absolute),
  };
  bool isOutputDir(Directory dir) =>
      generatedDirs.any((d) => p.equals(d, p.absolute(dir.path)));
  bool isSource(String path) =>
      _sourceExtensions.any((ext) => path.endsWith(ext));

  final sources = <String, FileStamp>{};
  Future<void> walk(Directory dir) async {
    if (!await dir.exists()) return;
    await for (final entity in dir.list()) {
      if (entity is Directory) {
        if (!isOutputDir(entity)) await walk(entity);
      } else if (entity is File && isSource(entity.path)) {
        sources[entity.path] = FileStamp(await entity.stat());
      }
    }
  }

  // Endpoints and models can live anywhere under lib/ (matching the endpoint
  // analyzer and model loader, not just lib/src/), so walk it all but the
  // output dirs.
  await walk(Directory(p.joinAll(config.libSourcePathParts)));
  for (final path in config.sharedModelsLibSourcePaths) {
    await walk(Directory(path));
  }

  var extraClassesSourcePaths = config.extraClasses
      .map((e) => e.sourcePath)
      .whereType<String>();

  for (final path in extraClassesSourcePaths) {
    final absolutePath = p.absolute(path);
    final file = File(absolutePath);
    if (await file.exists()) {
      sources[absolutePath] = FileStamp(await file.stat());
    }
  }

  return sources;
}
