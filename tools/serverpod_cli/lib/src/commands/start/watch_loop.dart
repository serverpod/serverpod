import 'dart:async';
import 'dart:io';

import 'package:serverpod_cli/src/commands/start/mcp_socket.dart';
import 'package:serverpod_cli/src/commands/start/watch_session.dart';
import 'package:serverpod_cli/src/util/file_ex.dart';
import 'package:serverpod_cli/src/vm_proxy/proxy.dart';

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
  final VmServiceProxy? proxy;
  final McpSocketServer? mcpSocket;
  final StreamSubscription<void>? fileChangeSub;
  final Future<void> Function() closeAnalyzers;
  final Future<void> Function()? stopDocker;
  final Future<void> Function()? stopFlutterProcess;
  final String vmServiceInfoFile;
  bool _disposed = false;

  WatchLoopContext({
    required this.session,
    required this.proxy,
    required this.mcpSocket,
    required this.fileChangeSub,
    required this.closeAnalyzers,
    required this.stopDocker,
    required this.stopFlutterProcess,
    required this.vmServiceInfoFile,
  });

  /// Whether [dispose] has been called.
  bool get isDisposed => _disposed;

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    await fileChangeSub?.cancel();
    await mcpSocket?.close();
    await closeAnalyzers();
    await session.dispose();
    await proxy?.close();
    await File(vmServiceInfoFile).deleteIfExists();
    await stopDocker?.call();
    await stopFlutterProcess?.call();
  }
}
