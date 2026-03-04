import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/vendored/frontend_server_client.dart';

import 'sdk_path.dart';

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

  FrontendServerClient? _clientOrNull;
  FrontendServerClient get _client =>
      _clientOrNull ?? (throw StateError('Compiler not started'));

  bool _needsFullCompile = true;

  KernelCompiler({
    required this.entryPoint,
    this.outputDill = '.dart_tool/serverpod/server.dill',
    this.packagesPath,
  });

  /// Start the Frontend Server process.
  ///
  /// This starts the server in resident mode, ready to receive compile
  /// commands. Call [compile] to perform the initial compilation.
  Future<void> start() async {
    final sdkRoot = getSdkPath();
    final platformDill = p.join(
      sdkRoot,
      'lib',
      '_internal',
      'vm_platform_strong.dill',
    );

    _clientOrNull = await FrontendServerClient.start(
      entryPoint,
      outputDill,
      platformDill,
      sdkRoot: sdkRoot,
      target: 'vm',
      packagesJson: packagesPath,
    );
    _needsFullCompile = true;
  }

  /// Compile the project.
  ///
  /// If a full compile is needed (after [start], [reset], or [restart]),
  /// [changedPaths] is ignored and a complete kernel is produced.
  /// Otherwise, performs an incremental recompile for [changedPaths].
  Future<CompileResult> compile({Set<String> changedPaths = const {}}) {
    if (_needsFullCompile) {
      _needsFullCompile = false;
      return _client.compile();
    }

    final invalidatedUris = changedPaths.map(Uri.file).toList();
    return _client.compile(invalidatedUris);
  }

  /// Accept the last compile result.
  void accept() => _client.accept();

  /// Reject the last compile result.
  Future<void> reject() => _client.reject();

  /// Reset the compiler so the next [compile] produces a complete kernel.
  ///
  /// Use this when incremental state may be stale (e.g., an external reload
  /// happened without going through this compiler).
  void reset() {
    _client.reset();
    _needsFullCompile = true;
  }

  /// Restart the Frontend Server process.
  ///
  /// Required when package_config.json changes, since the FES reads it
  /// only at startup. Kills the existing process and starts a fresh one.
  Future<void> restart() async {
    _clientOrNull?.kill();
    _clientOrNull = null;
    await start();
  }

  /// Stop the Frontend Server process.
  Future<void> dispose() async {
    _clientOrNull?.kill();
    _clientOrNull = null;
  }
}
