import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_shared/process_io.dart';

// ---------------------------------------------------------------------------
// Singleton resolver
// ---------------------------------------------------------------------------

SdkResolver? _resolver;

/// Installs the resolver every call site reads from.
///
/// Called once per invocation, before any command runs. Commands that know a
/// better base directory than the working directory call [rescopeSdkResolver]
/// once they have resolved it.
void initializeSdkResolver() {
  _resolver = SdkResolver(baseDirectory: Directory.current);
}

/// Re-points the singleton at [baseDirectory]. Discards anything already
/// resolved.
void rescopeSdkResolver(Directory baseDirectory) {
  _resolver = SdkResolver(baseDirectory: baseDirectory);
}

/// The resolver for this invocation.
///
/// Self-initializes against the working directory, so entry points
/// that never called [initializeSdkResolver] still get the documented chain
/// rather than a crash.
SdkResolver get sdkResolver =>
    _resolver ??= SdkResolver(baseDirectory: Directory.current);

/// Thrown when the Dart chain is exhausted - no Flutter SDK to derive from,
/// and the SDK running this CLI cannot be located either.
class SdkResolutionException implements Exception {
  final String message;

  const SdkResolutionException(this.message);

  @override
  String toString() => message;
}

/// The `flutter` executable inside [root].
String flutterExecutableIn(String root) =>
    p.join(root, 'bin', Platform.isWindows ? 'flutter.bat' : 'flutter');

/// The `dart` executable inside a Dart SDK [root].
String dartExecutableIn(String root) =>
    p.join(root, 'bin', Platform.isWindows ? 'dart.exe' : 'dart');

/// The Dart SDK a Flutter SDK at [flutterRoot] embeds.
String embeddedDartSdkIn(String flutterRoot) =>
    p.join(flutterRoot, 'bin', 'cache', 'dart-sdk');

/// Whether [root] is a Flutter SDK.
bool isFlutterSdk(String root) => File(flutterExecutableIn(root)).existsSync();

/// Whether [root] is a Dart SDK.
bool isDartSdk(String root) => File(dartExecutableIn(root)).existsSync();

/// Resolves which Dart and Flutter SDK the CLI should use, and where every
/// subprocess it spawns should find them.
///
/// Resolution is lazy and memoized: a command that never touches Flutter never
/// pays for looking for one.
///
/// The resolution chain:
/// the `flutter` on `$PATH`, asked from the project directory, and - for Dart
/// only - the SDK running this CLI.
/// Dart is derived from the resolved Flutter SDK whenever one
/// was found, so the server and the Flutter app are built by matching SDKs.
class SdkResolver {
  /// Directory the project is resolved relative to.
  final Directory baseDirectory;

  /// Overrides the `flutter --version --machine` probe used for the
  /// PATH tier.
  final Future<String?> Function()? _probePathFlutterRoot;

  /// The command the PATH tier probes.
  final List<String> _flutterCommand;

  /// Overrides the last-resort lookup of the SDK running this CLI.
  final String Function()? _runningSdkRoot;

  SdkResolver({
    required this.baseDirectory,
    @visibleForTesting Future<String?> Function()? probePathFlutterRoot,
    @visibleForTesting List<String> flutterCommand = const ['flutter'],
    @visibleForTesting String Function()? runningSdkRoot,
  }) : _probePathFlutterRoot = probePathFlutterRoot,
       _flutterCommand = flutterCommand,
       _runningSdkRoot = runningSdkRoot;

  Future<String?>? _flutter;
  Future<String>? _dart;

  /// The Flutter SDK to use, or `null` when none could be found.
  Future<String?> get flutterSdk => _flutter ??= _resolveFlutter();

  /// The Dart SDK to use.
  /// Throws [SdkResolutionException] when the chain is exhausted.
  Future<String> get dartSdk => _dart ??= _resolveDart();

  Future<String?> _resolveFlutter() async {
    // Ask the `flutter` on PATH where it lives, from the project directory.
    // Going through the executable rather than reading $PATH directly is what
    // makes version managers that shim `flutter` (asdf, mise, puro, or fvm
    // behind a `flutter` that runs `fvm flutter`) report the SDK they picked
    // for the project.
    final probePath =
        _probePathFlutterRoot ??
        () => _probeFlutterRoot(_flutterCommand, _probeDirectory);
    final flutterOnPath = await probePath();
    if (flutterOnPath != null && isFlutterSdk(flutterOnPath)) {
      return p.normalize(flutterOnPath);
    }

    log.debug('No Flutter SDK found.');
    return null;
  }

  Future<String> _resolveDart() async {
    // Derived from Flutter whenever one was found, so `pub` resolves against
    // the Dart the project's Flutter actually embeds.
    final flutter = await flutterSdk;
    if (flutter != null) {
      final embedded = embeddedDartSdkIn(flutter);
      if (isDartSdk(embedded)) return embedded;
      // A cold `bin/cache` has no embedded Dart yet.
      log.warning(
        'The Flutter SDK at $flutter has no populated bin/cache, so '
        'this project will build against the Dart SDK running this CLI '
        'instead of the one it pins. Run `flutter --version` (or `fvm '
        'install`) against it once to set it up.',
      );
    }

    // Last resort: the SDK running this CLI.
    try {
      return (_runningSdkRoot ?? getSdkPath)();
    } catch (e) {
      throw SdkResolutionException(
        'Could not locate a Dart SDK. You need to have dart installed '
        'and in your \$PATH. ($e)',
      );
    }
  }

  /// The directory the probes run in, so version managers that bind an SDK to
  /// a directory report the project's SDK.
  ///
  /// `serverpod create` resolves against a directory it has not created yet,
  /// so this is the nearest ancestor of [baseDirectory] that exists.
  String get _probeDirectory {
    var dir = baseDirectory.absolute;
    while (!dir.existsSync() && dir.parent.path != dir.path) {
      dir = dir.parent;
    }
    return dir.path;
  }

  /// Whether `flutter` is installed.
  Future<bool> get isFlutterInstalled async {
    if (await flutterSdk != null) return true;
    try {
      final result = await Process.run(
        'flutter',
        ['--version'],
        runInShell: Platform.isWindows,
      );
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  /// Runs [command] with `--version --machine` in [workingDirectory] and
  /// returns the `flutterRoot` it reports.
  static Future<String?> _probeFlutterRoot(
    List<String> command,
    String workingDirectory,
  ) async {
    try {
      final result = await Process.run(
        command.first,
        [...command.skip(1), '--version', '--machine'],
        workingDirectory: workingDirectory,
        runInShell: Platform.isWindows,
      );
      if (result.exitCode != 0) return null;
      return _flutterRootIn(result.stdout as String);
    } catch (_) {
      // Nothing to spawn.
      return null;
    }
  }

  /// The `flutterRoot` reported in [stdout], the output of
  /// `--version --machine`.
  ///
  /// Wrappers such as fvm and puro can print notices around the machine JSON,
  /// and a notice can be JSON itself. So every run of whole lines that could
  /// be a JSON object is decoded, and the first one that reports a
  /// `flutterRoot` wins.
  static String? _flutterRootIn(String stdout) {
    final lines = const LineSplitter().convert(stdout);
    for (var start = 0; start < lines.length; start++) {
      if (!lines[start].trimLeft().startsWith('{')) continue;
      for (var end = start; end < lines.length; end++) {
        if (!lines[end].trimRight().endsWith('}')) continue;
        final Object? decoded;
        try {
          decoded = jsonDecode(lines.sublist(start, end + 1).join('\n'));
        } on FormatException {
          continue;
        }
        if (decoded is Map && decoded['flutterRoot'] is String) {
          return decoded['flutterRoot'] as String;
        }
      }
    }
    return null;
  }

  /// Describes the resolved SDKs.
  Future<String> describeResolution() async {
    final flutter = await flutterSdk;
    final dart = await dartSdk;

    final buffer = StringBuffer();
    if (flutter == null) {
      buffer.writeln('Flutter SDK  not found');
    } else {
      buffer.writeln('Flutter SDK $flutter');
    }
    buffer.writeln('Dart SDK $dart');
    return buffer.toString();
  }
}
