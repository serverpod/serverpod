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
///
/// On POSIX, [Directory.systemTemp] resolves to `/tmp` when `TMPDIR` is
/// unset (typical Linux desktop). A plain `Directory.createSync()` calls
/// `mkdir(2)`, which derives the new directory's mode from `0777 & ~umask`.
/// With the typical desktop umask of 0022 that yields mode 0755, leaving
/// the directory (and the sockets inside it) world-readable. Unix domain
/// sockets accept any client that can `connect(2)` to the path, so any
/// other local user could attach to a developer's `serverpod start --watch`
/// MCP socket and call `apply_migrations`.
///
/// `Directory.createTempSync()` is specified to call `mkdtemp(3)`, which
/// always creates with mode 0700. We then `rename(2)` to the canonical
/// path: the syscall preserves the inode (and therefore the mode) and
/// avoids a separate `chmod` step that Dart's `Directory` API does not
/// expose without `Process.runSync('chmod', ...)`. On `EEXIST` we lose the
/// race against another runner that created the dir first, which is fine.
///
/// macOS and Windows already give each user a private temp dir, but this
/// path hardens Linux without any platform-specific calls.
void ensureServerpodMcpSocketDir() {
  final dir = Directory(serverpodMcpSocketDir);
  if (dir.existsSync()) return;

  final temp = Directory.systemTemp.createTempSync('serverpod-mcp-init-');
  try {
    temp.renameSync(serverpodMcpSocketDir);
  } on FileSystemException {
    // Lost the race against another runner that created the dir first.
    temp.deleteSync();
  }
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

    if (_isProcessAlive(socketPid)) {
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

/// Returns `true` if a process with [checkPid] is currently alive.
///
/// Uses `kill -0` on POSIX (sends no signal, just checks). On Windows, falls
/// back to `tasklist`. Short-circuits for the current process to avoid an
/// unnecessary fork and insulate scans from any tasklist quirks on Windows
/// CI runners.
bool _isProcessAlive(int checkPid) {
  if (checkPid == pid) return true;
  if (Platform.isWindows) {
    final result = Process.runSync('tasklist', [
      '/FI',
      'PID eq $checkPid',
      '/NH',
      '/FO',
      'CSV',
    ]);
    if (result.exitCode != 0) return false;
    return (result.stdout as String).contains('"$checkPid"');
  }
  return Process.runSync('kill', ['-0', '$checkPid']).exitCode == 0;
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
