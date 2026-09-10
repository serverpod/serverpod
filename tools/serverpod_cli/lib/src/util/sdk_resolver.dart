import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/server_directory_finder.dart';
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

/// An SDK root, and where it was resolved from.
class ResolvedSdk {
  /// Absolute path to the SDK root - the directory holding `bin/`.
  final String root;

  /// Human-readable account of where [root] came from, for diagnostics.
  /// Names the specific file the chain followed rather than just the tier.
  final String origin;

  const ResolvedSdk({required this.root, required this.origin});
}

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
/// project pin (`.fvm/flutter_sdk`), `$PATH`, and - for Dart only - the SDK
/// running this CLI. Dart is derived from the resolved Flutter SDK whenever one
/// was found, so the server and the Flutter app are built by matching SDKs.
class SdkResolver {
  /// Directory the project is resolved relative to.
  final Directory baseDirectory;

  /// Overrides the `flutter --version --machine` probe used for the
  /// PATH tier.
  final Future<String?> Function()? _probePathFlutterRoot;

  /// Overrides the last-resort lookup of the SDK running this CLI.
  final String Function()? _runningSdkRoot;

  SdkResolver({
    required this.baseDirectory,
    @visibleForTesting Future<String?> Function()? probePathFlutterRoot,
    @visibleForTesting String Function()? runningSdkRoot,
  }) : _probePathFlutterRoot = probePathFlutterRoot,
       _runningSdkRoot = runningSdkRoot;

  Future<ResolvedSdk?>? _flutter;
  Future<ResolvedSdk>? _dart;

  /// The Flutter SDK to use, or `null` when none could be found.
  Future<ResolvedSdk?> get flutterSdk => _flutter ??= _resolveFlutter();

  /// The Dart SDK to use.
  /// Throws [SdkResolutionException] when the chain is exhausted.
  Future<ResolvedSdk> get dartSdk => _dart ??= _resolveDart();

  Future<ResolvedSdk?> _resolveFlutter() async {
    final pinned = _findFvmProjectPin();
    if (pinned != null) return pinned;

    // Ask the `flutter` on PATH where it lives. This is the only tier that
    // costs a subprocess, so it runs after the pin lookup rather than before.
    // Going through the executable rather than reading $PATH directly is what
    // makes shim-based managers (asdf, mise, puro) report their real root.
    final probed = await (_probePathFlutterRoot ?? _probeFlutterRootOnPath)();
    if (probed != null && isFlutterSdk(probed)) {
      return ResolvedSdk(
        root: p.normalize(probed),
        origin: '`flutter` on PATH',
      );
    }

    log.debug('No Flutter SDK found.');
    return null;
  }

  Future<ResolvedSdk> _resolveDart() async {
    // Derived from Flutter whenever one was found, so `pub` resolves against
    // the Dart the project's Flutter actually embeds.
    final flutter = await flutterSdk;
    if (flutter != null) {
      final embedded = embeddedDartSdkIn(flutter.root);
      if (isDartSdk(embedded)) {
        return ResolvedSdk(
          root: embedded,
          origin: 'the resolved Flutter SDK',
        );
      }
      // A cold `bin/cache` has no embedded Dart yet.
      log.warning(
        'The Flutter SDK at ${flutter.root} has no populated bin/cache, so '
        'this project will build against the Dart SDK running this CLI '
        'instead of the one it pins. Run `flutter --version` (or `fvm '
        'install`) against it once to set it up.',
      );
    }

    // Last resort: the SDK running this CLI.
    try {
      return ResolvedSdk(
        root: (_runningSdkRoot ?? getSdkPath)(),
        origin: 'the Dart SDK running this CLI',
      );
    } catch (e) {
      throw SdkResolutionException(
        'Could not locate a Dart SDK. You need to have dart installed '
        'and in your \$PATH. ($e)',
      );
    }
  }

  /// Walks up from [baseDirectory] looking for `.fvm/flutter_sdk`.
  ///
  /// The walk stops after the first repository boundary so it never escapes
  /// the project and picks up an unrelated pin from a parent checkout.
  ResolvedSdk? _findFvmProjectPin() {
    var dir = baseDirectory.absolute;
    while (true) {
      final link = p.join(dir.path, '.fvm', 'flutter_sdk');
      if (Directory(link).existsSync() || Link(link).existsSync()) {
        // Resolve through the symlink so the recorded root is the real cache
        // directory. That keeps diagnostics honest about which version is in
        // play, and survives `fvm use` pointing the link somewhere else.
        String resolved;
        try {
          resolved = Directory(link).resolveSymbolicLinksSync();
        } on FileSystemException catch (e) {
          log.debug('Ignoring unusable Flutter pin at $link: ${e.message}');
          return null;
        }

        if (!isFlutterSdk(resolved)) {
          log.debug(
            'Ignoring Flutter pin at $link: $resolved is not a Flutter SDK.',
          );
          return null;
        }

        return ResolvedSdk(
          root: resolved,
          origin: '.fvm/flutter_sdk in ${dir.path}',
        );
      }

      if (ServerDirectoryFinder.isRepositoryBoundary(dir)) return null;

      final parent = dir.parent;
      if (parent.path == dir.path) return null;
      dir = parent;
    }
  }

  /// Asks the `flutter` on `$PATH` for its own root.
  static Future<String?> _probeFlutterRootOnPath() async {
    try {
      final result = await Process.run(
        'flutter',
        ['--version', '--machine'],
        runInShell: Platform.isWindows,
      );
      if (result.exitCode != 0) return null;
      final decoded = jsonDecode(result.stdout as String);
      if (decoded is! Map || decoded['flutterRoot'] is! String) return null;
      return decoded['flutterRoot'] as String;
    } catch (_) {
      // No `flutter` to spawn, or it answered with something unparseable.
      return null;
    }
  }

  /// Describes the resolved SDKs and their resolution origin.
  Future<String> describeResolution() async {
    final flutter = await flutterSdk;
    final dart = await dartSdk;

    final buffer = StringBuffer();
    if (flutter == null) {
      buffer.writeln('Flutter SDK  not found');
    } else {
      buffer.writeln('Flutter SDK ${flutter.root} from ${flutter.origin}');
    }
    buffer.writeln('Dart SDK ${dart.root} from ${dart.origin}');
    return buffer.toString();
  }
}
