import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:stream_channel/stream_channel.dart';

/// Shared directory under the system temp folder where every running
/// `serverpod start --watch` instance advertises its MCP socket.
///
/// One directory for all instances on the machine; the bridge scans it to
/// discover them. Filenames are `serverpod-<pid>-<project>.sock`.
final serverpodMcpSocketDir = p.join(
  Directory.systemTemp.path,
  'serverpod',
);

/// Ensure [serverpodMcpSocketDir] exists, creating it if necessary.
void ensureServerpodMcpSocketDir() {
  final dir = Directory(serverpodMcpSocketDir);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
}

/// Build the canonical socket path for a `serverpod start --watch` instance.
///
/// Project name is sanitized via [sanitizeProjectName] so it is safe to use
/// in a filename across platforms.
String serverpodMcpSocketPath({required int pid, required String project}) {
  final name = sanitizeProjectName(project);
  final suffix = name.isEmpty ? '' : '-$name';
  return p.join(serverpodMcpSocketDir, 'serverpod-$pid$suffix.sock');
}

/// Sanitize [name] so it is safe to embed in a filename.
///
/// Lower-cases, replaces non-alphanumeric (other than hyphens) with hyphens,
/// collapses runs of hyphens, and strips leading/trailing hyphens.
String sanitizeProjectName(String name) {
  return name
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9-]'), '-')
      .replaceAll(RegExp(r'-+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}

/// Information about a discovered serverpod MCP socket.
typedef ServerpodMcpSocketInfo = ({int pid, String project, String path});

/// Filename pattern for serverpod MCP sockets in [serverpodMcpSocketDir].
final RegExp _socketFilenamePattern = RegExp(
  r'^serverpod-(\d+)(?:-(.+))?\.sock$',
);

/// List all live serverpod MCP sockets in [serverpodMcpSocketDir].
///
/// A socket is considered live if its PID is still running. Stale socket
/// files for dead PIDs are removed as a side effect.
List<ServerpodMcpSocketInfo> listServerpodMcpSockets() {
  final dir = Directory(serverpodMcpSocketDir);
  if (!dir.existsSync()) return const [];

  final results = <ServerpodMcpSocketInfo>[];
  final stale = <File>[];

  for (final entity in dir.listSync()) {
    if (entity is! File) continue;
    final name = p.basename(entity.path);
    final match = _socketFilenamePattern.firstMatch(name);
    if (match == null) continue;

    final socketPid = int.parse(match.group(1)!);
    final project = match.group(2) ?? '';

    if (_isProcessAlive(socketPid)) {
      results.add((pid: socketPid, project: project, path: entity.path));
    } else {
      stale.add(entity);
    }
  }

  for (final file in stale) {
    try {
      file.deleteSync();
    } on FileSystemException {
      // Ignore - another process may have cleaned it up.
    }
  }

  return results;
}

/// Returns `true` if a process with [pid] is currently alive.
///
/// Uses `kill -0` on POSIX (sends no signal, just checks). On Windows, falls
/// back to `tasklist`.
bool _isProcessAlive(int pid) {
  if (Platform.isWindows) {
    final result = Process.runSync('tasklist', [
      '/FI',
      'PID eq $pid',
      '/NH',
      '/FO',
      'CSV',
    ]);
    if (result.exitCode != 0) return false;
    return (result.stdout as String).contains('"$pid"');
  }
  return Process.runSync('kill', ['-0', '$pid']).exitCode == 0;
}

/// Wraps [socket] in a [StreamChannel<String>] using line-delimited messages.
///
/// Matches the framing used by `dart_mcp`'s stdio transport so the same
/// `MCPServer`/`MCPClient` plumbing works over a Unix socket.
StreamChannel<String> socketChannel(Socket socket) {
  final inStream = socket
      .cast<List<int>>()
      .transform(utf8.decoder)
      .transform(const LineSplitter());

  final outController = StreamController<String>();
  outController.stream.listen(
    (line) => socket.write('$line\n'),
    onDone: () => socket.close(),
  );

  return StreamChannel<String>(inStream, outController.sink);
}
