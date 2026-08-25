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

  /// The runner's capabilities over [session], for whichever surface renders
  /// this context.
  final RunnerApi runnerApi;

  /// Resolves the server VM-service proxy at call time.
  ///
  /// A function rather than a value, since a degraded start has no proxy until
  /// the server first boots.
  final VmServiceProxy? Function() proxy;
  final FlutterAppManager flutterManager;
  final McpSocketServer? mcpSocket;

  /// The attach socket clients render from.
  ///
  /// Null only in tests. A runner that could not bind it aborts its start.
  final RunnerSocketServer? attachSocket;
  final Future<void> Function() closeAnalyzers;
  final Future<void> Function()? stopDocker;
  final void Function() stopFileWatcher;

  /// Announces that the stack is going away, with its exit code.
  ///
  /// Not part of [RunnerApi]. Carries the exit code, since a client renders
  /// the stack rather than hosting it.
  final void Function(int exitCode)? announceStopping;
  final String vmServiceInfoFile;

  /// Keeps `runner.json` current, and removes it on dispose.
  ///
  /// Null in tests that build a context without publishing one.
  final RunnerManifestPublisher? manifestPublisher;

  /// The one-runner-per-package lock, released last so nothing else can claim
  /// the package while this one is still tearing down.
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
    await _step(
      'removing the manifest',
      () async => manifestPublisher?.dispose(),
    );
    await _step('stopping the Docker services', () async => stopDocker?.call());
    await _step('releasing the lock', () async => lock?.release());
  }

  /// Runs one teardown step, keeping its failure to itself.
  ///
  /// The steps that outlive this process go last, the manifest, the Docker
  /// services, and the lock the next runner needs. A socket dying mid-close
  /// must not skip them.
  Future<void> _step(String what, Future<void> Function() body) async {
    try {
      await body();
    } catch (e) {
      log.warning('Failed while $what: $e');
    }
  }
}
