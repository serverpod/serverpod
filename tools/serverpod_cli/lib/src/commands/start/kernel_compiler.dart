import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/sdk_path.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/vendored/frontend_server_client.dart';

export 'package:serverpod_cli/src/vendored/frontend_server_client.dart'
    show CompileResult;

/// Manages incremental Dart compilation using the Frontend Server.
///
/// Tracks whether a full or incremental compile is needed internally.
/// After [start], [reset], or [restart], the next [compile] will produce
/// a complete kernel. Otherwise, [compile] performs an incremental build
/// using the provided [changedPaths].
class KernelCompiler {
  final String entryPoint;
  final String outputDill;
  final String? packagesPath;

  late final String _sdkRoot;
  late final String _platformDill;
  late Future<FrontendServerClient> _client;

  bool _needsFullCompile = true;
  bool _started = false;

  KernelCompiler({
    required this.entryPoint,
    this.outputDill = '.dart_tool/serverpod/server.dill',
    this.packagesPath,
  });

  /// The path to the `dart` executable from the SDK used by this compiler.
  String get dartExecutable => p.join(_sdkRoot, 'bin', 'dart');

  /// Start the Frontend Server process.
  ///
  /// This starts the server in resident mode, ready to receive compile
  /// commands. Call [compile] to perform the initial compilation.
  Future<void> start() async {
    if (_started) return;

    _sdkRoot = getSdkPath();
    _platformDill = p.join(
      _sdkRoot,
      'lib',
      '_internal',
      'vm_platform_strong.dill',
    );

    _client = FrontendServerClient.start(
      entryPoint,
      outputDill,
      _platformDill,
      sdkRoot: _sdkRoot,
      target: 'vm',
      packagesJson: packagesPath,
    );
    _started = true;
    _needsFullCompile = true;
  }

  /// Returns `true` if [outputDill] exists, is newer than every file under
  /// [watchDirs], and is compatible with the current Dart SDK's kernel binary
  /// format.
  Future<bool> isDillUpToDate(Set<String> watchDirs) async {
    final dillFile = File(outputDill);
    if (!await dillFile.exists()) return false;

    if (!_dillHeadersMatch(outputDill, _platformDill)) return false;

    final dillMtime = (await dillFile.stat()).modified;

    for (final watchDir in watchDirs) {
      final dir = Directory(watchDir);
      if (!await dir.exists()) continue;
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File &&
            (await entity.stat()).modified.isAfter(dillMtime)) {
          return false;
        }
      }
    }

    return true;
  }

  /// Compiles the project if the cached dill is stale relative to [watchDirs].
  ///
  /// Returns `true` on success (including when no compilation was needed).
  /// Returns `false` if compilation failed.
  Future<bool> compileIfNeeded(Set<String> watchDirs) async {
    if (await isDillUpToDate(watchDirs)) {
      log.debug('Cached server.dill is up to date, skipping initial compile.');
      return true;
    }

    final result = await compileWithProgress('Compiling server', this);
    if (result == null) return false;
    accept();
    return true;
  }

  /// Compile the project.
  ///
  /// If a full compile is needed (after [start], [reset], or [restart]),
  /// [changedPaths] is ignored and a complete kernel is produced.
  /// Otherwise, performs an incremental recompile for [changedPaths].
  Future<CompileResult> compile({Set<String> changedPaths = const {}}) async {
    final client = await _client;

    if (_needsFullCompile) {
      log.debug('compile: full');
      final result = await client.compile();
      _needsFullCompile = false;
      return result;
    }

    log.debug('compile: $changedPaths');
    final invalidatedUris = changedPaths.map(Uri.file).toList();
    return client.compile(invalidatedUris);
  }

  /// Accept the last compile result.
  void accept() => _client.then((c) => c.accept());

  /// Reject the last compile result.
  Future<void> reject() => _client.then((c) => c.reject());

  /// Reset the compiler so the next [compile] produces a complete kernel.
  ///
  /// Use this when incremental state may be stale (e.g., an external reload
  /// happened without going through this compiler).
  Future<void> reset() async {
    if (_needsFullCompile) return; // No compile yet; already in full state.
    final client = await _client;
    client.reset();
    _needsFullCompile = true;
  }

  /// Restart the Frontend Server process.
  ///
  /// Required when package_config.json changes, since the FES reads it
  /// only at startup. Kills the existing process and starts a fresh one.
  Future<void> restart() async {
    await dispose();
    await start();
  }

  /// Stop the Frontend Server process.
  Future<void> dispose() async {
    if (_started) {
      final client = await _client;
      client.kill();
      _started = false;
    }
  }

  /// The Dart kernel binary header is 8 bytes: 4-byte magic number followed by
  /// a 4-byte binary format version. Two .dill files are compatible only if
  /// these bytes match.
  static const _dillHeaderSize = 8;

  /// Returns `true` if both files exist and their first [_dillHeaderSize] bytes
  /// are identical.
  static bool _dillHeadersMatch(String pathA, String pathB) {
    try {
      final fileA = File(pathA);
      final fileB = File(pathB);
      final headerA = fileA.openSync()..setPositionSync(0);
      final headerB = fileB.openSync()..setPositionSync(0);
      try {
        final bytesA = headerA.readSync(_dillHeaderSize);
        final bytesB = headerB.readSync(_dillHeaderSize);
        if (bytesA.length != _dillHeaderSize ||
            bytesB.length != _dillHeaderSize) {
          return false;
        }
        for (var i = 0; i < _dillHeaderSize; i++) {
          if (bytesA[i] != bytesB[i]) return false;
        }
        return true;
      } finally {
        headerA.closeSync();
        headerB.closeSync();
      }
    } on FileSystemException {
      return false;
    }
  }
}

/// Runs a compilation step with progress feedback.
///
/// Returns the [CompileResult] on success, or `null` if compilation failed.
/// On failure, logs compiler output. If [rejectOnFailure] is true, also
/// rejects the compile result via [compiler].
Future<CompileResult?> compileWithProgress(
  String message,
  KernelCompiler compiler, {
  Set<String> changedPaths = const {},
  bool rejectOnFailure = false,
}) async {
  late CompileResult result;
  final success = await log.progress(message, () async {
    result = await compiler.compile(changedPaths: changedPaths);
    return result.errorCount == 0;
  });

  if (!success) {
    for (final line in result.compilerOutputLines) {
      log.error(line);
    }
    if (rejectOnFailure) {
      await compiler.reject();
    }
    return null;
  }

  return result;
}
