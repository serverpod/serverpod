import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_shared/serverpod_shared.dart';
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

/// Ensure [serverpodMcpSocketDir] exists with mode 0700 on POSIX (so
/// other local users can't `connect(2)` to a developer's MCP socket and
/// invoke `apply_migrations`). Delegates to the shared mkdtemp+rename
/// helper.
void ensureServerpodMcpSocketDir() {
  ensureSecureDirectorySync(serverpodMcpSocketDir);
}

/// Build the canonical socket path for a `serverpod start --watch` instance.
///
/// Project name is sanitized via [sanitizeProjectName] so it is safe to use
/// in a filename across platforms. The PID - guaranteed unique per running
/// process - is the disambiguator: two distinct runners can never produce
/// the same filename even if their sanitized project names collide. The
/// project segment is purely for human discoverability in
/// `serverpod://instances` and the bridge's `connect`/`stop` tools.
String serverpodMcpSocketPath({required int pid, required String project}) {
  final name = sanitizeProjectName(project);
  final suffix = name.isEmpty ? '' : '-$name';
  return p.join(serverpodMcpSocketDir, 'serverpod-$pid$suffix.sock');
}

/// Sanitize [name] so it is safe to embed in a filename.
///
/// Lower-cases, replaces non-alphanumeric (other than hyphens) with hyphens,
/// collapses runs of hyphens, and strips leading/trailing hyphens. Purely
/// cosmetic - distinct projects whose sanitized names happen to collide
/// (e.g. `my_app` and `my-app`) are still uniquely identified by the PID
/// embedded in the socket filename.
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
  final stalePaths = <String>[];

  // followLinks: false - on Windows, AF_UNIX socket files are reparse points
  // with a tag Dart does not recognize. With the default followLinks: true,
  // listSync() tries to resolve them, fails, and silently drops the entry.
  // We also do not filter on FileSystemEntity type: the filename regex is
  // specific enough, and Windows AF_UNIX entries do not classify cleanly
  // as File.
  for (final entity in dir.listSync(followLinks: false)) {
    final name = p.basename(entity.path);
    final match = _socketFilenamePattern.firstMatch(name);
    if (match == null) continue;

    final socketPid = int.parse(match.group(1)!);
    final project = match.group(2) ?? '';

    // Self-pid: skip the FFI call entirely (common during self-scans).
    if (socketPid == pid || isProcessAlive(socketPid)) {
      results.add((pid: socketPid, project: project, path: entity.path));
    } else {
      stalePaths.add(entity.path);
    }
  }

  for (final path in stalePaths) {
    try {
      File(path).deleteSync();
    } on FileSystemException {
      // Ignore - another process may have cleaned it up.
    }
  }

  return results;
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
