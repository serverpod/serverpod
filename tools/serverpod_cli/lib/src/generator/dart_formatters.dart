import 'dart:convert';
import 'dart:io';

import 'package:dart_style/dart_style.dart';
// `dart_style` does not expose the configuration resolver used by
// `dart format`.
// ignore: implementation_imports
import 'package:dart_style/src/config_cache.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

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
  ///
  /// `dart_style` reports problems with a target package's
  /// `analysis_options.yaml` by writing to `stderr` itself, which corrupts the
  /// TUI. Those writes are captured and re-emitted through the logger instead.
  static Future<void> resolve(GeneratorConfig config) async {
    final formatterStderr = _BufferedStdout();

    await IOOverrides.runZoned(
      () => _resolve(config),
      stderr: () => formatterStderr,
      stdout: () => formatterStderr,
    );

    // Output directories in the same package share an `analysis_options.yaml`,
    // so a problem with it is reported once per directory. Report each distinct
    // line once, as a single warning, keeping multi-line messages intact.
    final warnings = <String>{};
    for (final line in const LineSplitter().convert(formatterStderr.text)) {
      if (line.trim().isEmpty) continue;
      warnings.add(line);
    }

    if (warnings.isNotEmpty) {
      log.warning(warnings.join('\n'));
    }
  }

  static Future<void> _resolve(GeneratorConfig config) async {
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

  // Package config discovery needs a path inside an existing directory: it
  // starts at the file's own directory and does not walk up out of one that
  // is missing. The generated output folder (e.g. lib/src/protocol) may not
  // exist yet on the first run, so resolve against the nearest existing
  // parent instead. Only missing directories are skipped, and those can hold
  // neither a `.dart_tool/` nor an `analysis_options.yaml`, so this finds the
  // same configuration the output directory itself would once it exists.
  //
  // In a real project that parent is always within the target package (e.g.
  // lib/src or the package root); only test teardown races or a missing
  // package can climb further, in which case language-version lookup falls back below.
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
    pageWidth: await configCache.findPageWidth(languageVersionFile),
    trailingCommas: await configCache.findTrailingCommas(languageVersionFile),
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

/// A [Stdout] that buffers everything written to it in memory.
///
/// Installed over `stderr` with [IOOverrides.runZoned] so that direct writes
/// from within `dart_style` can be routed through the logger. The top-level
/// `stderr` in `dart:io` resolves [IOOverrides.current] on every access, and
/// the overrides are zone scoped, so the buffer stays in effect across the
/// `await`s inside the library.
class _BufferedStdout implements Stdout {
  final StringBuffer _buffer = StringBuffer();

  /// Everything written so far.
  String get text => _buffer.toString();

  @override
  Encoding encoding = utf8;

  @override
  void write(Object? object) => _buffer.write(object);

  @override
  void writeln([Object? object = '']) => _buffer.writeln(object);

  @override
  void writeAll(Iterable<Object?> objects, [String separator = '']) =>
      _buffer.writeAll(objects, separator);

  @override
  void writeCharCode(int charCode) => _buffer.writeCharCode(charCode);

  @override
  void add(List<int> data) => _buffer.write(encoding.decode(data));

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      _buffer.writeln(error);

  @override
  Future<void> addStream(Stream<List<int>> stream) => stream.forEach(add);

  @override
  Future<void> flush() async {}

  @override
  Future<void> close() async {}

  @override
  Future<void> get done => Future.value();

  @override
  IOSink get nonBlocking => this;

  // Reported as a non-terminal so that anything checking before emitting ANSI
  // escapes writes plain text the logger can render.
  @override
  bool get hasTerminal => false;

  @override
  bool get supportsAnsiEscapes => false;

  @override
  int get terminalColumns => 80;

  @override
  int get terminalLines => 24;

  // Declaring `noSuchMethod` makes the compiler generate forwarders for any
  // member a later SDK adds to `Stdout`, so this keeps compiling across SDK
  // upgrades. Reaching one throws, as it would on any unimplemented member.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
