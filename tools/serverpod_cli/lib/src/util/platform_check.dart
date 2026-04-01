import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/file_ex.dart';

/// Throws a [SocketException] if the current platform does not support Unix
/// domain sockets.
///
/// On Windows, AF_UNIX sockets require Dart 3.11+. On macOS and Linux they
/// are always available.
void requireUnixSocketSupport() {
  if (!hasUnixSocketSupport()) {
    throw SocketException(
      'Unix domain sockets require Dart 3.11+ on Windows '
      '(current: ${Platform.version.split(' ').first}).',
    );
  }
}

/// Returns `true` if the current platform supports Unix domain sockets.
///
/// On Windows, AF_UNIX sockets require Dart 3.11+. On macOS and Linux they
/// are always available.
bool hasUnixSocketSupport() {
  if (Platform.isWindows) {
    final parts = Platform.version.split(' ').first.split('.');
    final major = int.parse(parts[0]);
    final minor = parts.length > 1 ? int.parse(parts[1]) : 0;

    if (major < 3 || (major == 3 && minor < 11)) return false;
  }
  return true; // supported on other platforms if it compiles
}

/// Returns the shortest equivalent form of [path].
///
/// Normalizes the path (removing `.`, `..`, duplicate separators), then
/// returns the shorter of the absolute and relative forms.
String shortestPath(String path) {
  final normalized = p.canonicalize(path);
  final relative = p.relative(normalized);
  return relative.length < normalized.length ? relative : normalized;
}

/// Binds a [ServerSocket] to a Unix domain socket at [path].
///
/// Removes any stale socket file before binding and uses [shortestPath] to
/// minimize the path length (Unix sockets are limited to 104–108 bytes).
Future<ServerSocket> bindUnixSocket(String path) async {
  requireUnixSocketSupport();

  // Clean up stale socket file if it exists.
  await File(path).deleteIfExists();

  return ServerSocket.bind(
    InternetAddress(shortestPath(path), type: InternetAddressType.unix),
    0,
  );
}

/// Connects to a Unix domain socket at [path].
///
/// Uses [shortestPath] to minimize the path length (Unix sockets are limited
/// to 104–108 bytes).
Future<Socket> connectUnixSocket(String path) async {
  requireUnixSocketSupport();

  return Socket.connect(
    InternetAddress(shortestPath(path), type: InternetAddressType.unix),
    0,
  );
}
