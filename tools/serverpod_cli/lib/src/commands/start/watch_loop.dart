import 'dart:async';
import 'dart:io';

import 'package:serverpod_cli/src/commands/start/flutter_app_manager.dart';
import 'package:serverpod_cli/src/commands/start/mcp_socket.dart';
import 'package:serverpod_cli/src/commands/start/watch_session.dart';
import 'package:serverpod_cli/src/runner/runner_api.dart';
import 'package:serverpod_cli/src/runner/runner_lock.dart';
import 'package:serverpod_cli/src/runner/runner_manifest_publisher.dart';
import 'package:serverpod_cli/src/runner/runner_socket_server.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/vm_proxy/proxy.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Mutable holder for `serverArgs` so the migration-fallback hook can
/// prepend `--apply-migrations` and have the next pod start observe it.
class ServerArgsRef {
  List<String> value;
  ServerArgsRef(this.value);
}

sealed class WatchLoopSetupResult {
  const WatchLoopSetupResult();
}

final class WatchLoopReady extends WatchLoopSetupResult {
  final WatchLoopContext ctx;
  const WatchLoopReady(this.ctx);
}

final class WatchLoopAborted extends WatchLoopSetupResult {
  final int exitCode;
  const WatchLoopAborted(this.exitCode);
}

/// Owns everything constructed by the watch-loop setup and provides a
/// single, idempotent [dispose] for cleanup.
class WatchLoopContext {
  final WatchSession session;

  final RunnerApi runnerApi;

  /// The server's VM service proxy, null until the server first boots.
  final VmServiceProxy? Function() proxy;
  final FlutterAppManager flutterManager;
  final McpSocketServer? mcpSocket;

  /// The attach socket, null only in tests.
  final RunnerSocketServer? attachSocket;
  final Future<void> Function() closeAnalyzers;
  final Future<void> Function()? stopDocker;
  final void Function() stopFileWatcher;

  /// Announces the stack is stopping, which only its hosting process can do.
  final void Function(int exitCode)? announceStopping;
  final String vmServiceInfoFile;

  /// The manifest publisher, null in tests that publish no manifest.
  final RunnerManifestPublisher? manifestPublisher;

  /// The runner lock, released last so no other runner starts mid-teardown.
  final RunnerLock? lock;

  bool _disposed = false;

  WatchLoopContext({
    required this.session,
    required this.runnerApi,
    required this.proxy,
    required this.flutterManager,
    required this.mcpSocket,
    required this.attachSocket,
    required this.closeAnalyzers,
    required this.stopDocker,
    required this.stopFileWatcher,
    this.announceStopping,
    required this.vmServiceInfoFile,
    this.manifestPublisher,
    this.lock,
  });

  /// Whether [dispose] has been called.
  bool get isDisposed => _disposed;

  Future<void> dispose({int exitCode = 0}) async {
    if (_disposed) return;
    _disposed = true;
    stopFileWatcher();
    announceStopping?.call(exitCode);
    await _step('closing the MCP socket', () async => mcpSocket?.close());
    await _step('closing the attach socket', () async => attachSocket?.close());
    await _step('closing the runner API', runnerApi.close);
    await _step('closing the analyzers', closeAnalyzers);
    await _step('stopping the server', session.dispose);
    await _step('closing the VM service proxy', () async => proxy()?.close());
    await _step('stopping the Flutter apps', flutterManager.dispose);
    await _step(
      'removing the VM service info file',
      () => File(vmServiceInfoFile).deleteIfExists(),
    );
    await _step('stopping the Docker services', () async => stopDocker?.call());
    await _step(
      'finishing the manifest',
      () async => manifestPublisher?.finish(exitCode: exitCode),
    );
    await _step('releasing the lock', () async => lock?.release());
  }

  /// Runs one teardown step, logging a failure so later steps still run.
  Future<void> _step(String what, Future<void> Function() body) async {
    try {
      await body();
    } catch (e) {
      log.warning('Failed while $what: $e');
    }
  }
}
