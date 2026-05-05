import 'dart:async';
import 'dart:io';

import 'package:stream_transform/stream_transform.dart';

import 'socket_directory.dart';

/// Discovers running `serverpod start --watch` instances by scanning the
/// shared MCP socket directory.
///
/// The bridge process owns one of these. It watches the directory for
/// changes and maintains a list of live sockets, but does not connect to
/// any instance - that is the bridge MCP server's responsibility.
class ServerpodMcpBridge {
  List<ServerpodMcpSocketInfo> _sockets = const [];
  StreamSubscription<void>? _watchSub;

  /// The currently discovered live sockets.
  List<ServerpodMcpSocketInfo> get sockets => _sockets;

  /// Called when the socket list changes.
  void Function()? onSocketsChanged;

  /// Scan for existing serverpod sockets.
  Future<void> scan() async {
    _sockets = listServerpodMcpSockets();
    onSocketsChanged?.call();
  }

  /// Start watching the shared socket directory for changes.
  ///
  /// Coalesces bursts of file events into a single rescan via
  /// `asyncMapBuffer` so that sockets disappearing and reappearing in quick
  /// succession produce one notification rather than many.
  void startWatching() {
    ensureServerpodMcpSocketDir();
    _watchSub = Directory(
      serverpodMcpSocketDir,
    ).watch().asyncMapBuffer((_) => scan()).listen((_) {});
  }

  /// Look up a socket by project name or PID string.
  ///
  /// Project name is matched first; if no match, the input is interpreted
  /// as a PID. This lets callers refer to instances by either identifier.
  ServerpodMcpSocketInfo? findSocket(String id) {
    return _sockets.where((s) => s.project == id).firstOrNull ??
        _sockets.where((s) => s.pid.toString() == id).firstOrNull;
  }

  /// Stop watching.
  Future<void> dispose() async {
    await _watchSub?.cancel();
    _watchSub = null;
  }
}
