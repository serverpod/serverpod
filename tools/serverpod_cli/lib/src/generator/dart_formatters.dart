import 'dart:io';

import 'package:dart_style/dart_style.dart';
// `dart_style` does not expose the configuration resolver used by
// `dart format`.
// ignore: implementation_imports
import 'package:dart_style/src/config_cache.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/analyzer.dart';

/// Formatters for generated Dart, resolved from each output directory's
/// `analysis_options.yaml`.
final class GeneratedDartFormatters {
  /// Formatters in effect for the current serialized generation run.
  static GeneratedDartFormatters _current =
      GeneratedDartFormatters.serverpodDefaults();

  final Map<String, DartFormatter> _byDirectory;
  final DartFormatter _fallback;

  const GeneratedDartFormatters._(this._byDirectory, this._fallback);

  /// The formatter used outside a configured generation run.
  factory GeneratedDartFormatters.serverpodDefaults() {
    return GeneratedDartFormatters._(const {}, serverpodDefaultFormatter);
  }

  /// The formatter matching Serverpod's generated-code defaults.
  static final DartFormatter serverpodDefaultFormatter = DartFormatter(
    languageVersion: Version(3, 10, 0),
    trailingCommas: TrailingCommas.preserve,
  );

  /// Resolves the formatters needed by one generation run.
  static Future<void> resolve(GeneratorConfig config) async {
    final directories = _outputDirectories(config);
    final configCache = ConfigCache();
    final formatters = await Future.wait([
      for (final directory in directories)
        _formatterFor(directory, configCache),
    ]);

    _current = GeneratedDartFormatters._(
      {
        for (var i = 0; i < directories.length; i++)
          p.normalize(p.absolute(directories[i])): formatters[i],
      },
      serverpodDefaultFormatter,
    );
  }

  /// Resets the current instance to the serverpod defaults.
  static void reset() {
    _current = GeneratedDartFormatters.serverpodDefaults();
  }

  /// Returns the formatter applying to [outputPath].
  static DartFormatter of(String outputPath) {
    final path = p.normalize(p.absolute(outputPath));
    String? bestMatch;

    for (final directory in _current._byDirectory.keys) {
      if (!p.isWithin(directory, path)) continue;
      if (bestMatch == null || directory.length > bestMatch.length) {
        bestMatch = directory;
      }
    }

    return bestMatch == null
        ? _current._fallback
        : _current._byDirectory[bestMatch]!;
  }

  static List<String> _outputDirectories(GeneratorConfig config) {
    final serverTestToolsPath = config.generatedServerTestToolsPathParts;

    return [
      p.joinAll(config.generatedServeModelPathParts),
      p.joinAll(config.generatedDartClientModelPathParts),
      p.joinAll([...config.clientPackagePathParts, 'lib', 'migrations']),
      if (serverTestToolsPath != null) p.joinAll(serverTestToolsPath),
      ...config.generatedSharedModelsPaths,
    ];
  }
}

Future<DartFormatter> _formatterFor(
  String directory,
  ConfigCache configCache,
) async {
  final outputFile = File(p.join(directory, 'protocol.dart')).absolute;

  // Package config discovery needs a path inside an existing directory. The
  // generated output folder (e.g. lib/src/protocol) may not exist yet on the
  // first run, so walk up to the nearest existing parent. In a real project
  // that parent is always within the target package (e.g. lib/src or the
  // package root); only test teardown races or a missing package can climb
  // further, in which case language-version lookup falls back below.
  var languageVersionDirectory = outputFile.parent;
  while (!await _directoryExists(languageVersionDirectory)) {
    final parent = languageVersionDirectory.parent;
    if (parent.path == languageVersionDirectory.path) {
      break;
    }
    languageVersionDirectory = parent;
  }
  final languageVersionFile = File(
    p.join(languageVersionDirectory.path, p.basename(outputFile.path)),
  );
  final languageVersion =
      await configCache.findLanguageVersion(
        languageVersionFile,
        outputFile.path,
      ) ??
      DartFormatter.latestLanguageVersion;

  return DartFormatter(
    languageVersion: languageVersion,
    pageWidth: await configCache.findPageWidth(outputFile),
    trailingCommas: await configCache.findTrailingCommas(outputFile),
  );
}

Future<bool> _directoryExists(Directory directory) async {
  try {
    return await directory.exists();
  } on PathAccessException {
    // Windows can deny access while a directory is being deleted.
    return false;
  }
}
