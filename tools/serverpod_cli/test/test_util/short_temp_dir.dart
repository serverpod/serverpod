import 'dart:io';

/// Creates a temporary directory under a short path, for a socket that has to
/// fit the Unix socket address limit.
///
/// The system temp directory sits deep on macOS, where the limit is 104 bytes.
/// Elsewhere it is short enough, and `/tmp` may not exist.
Future<Directory> createShortTempDir(String prefix) =>
    (Platform.isMacOS ? Directory('/tmp') : Directory.systemTemp).createTemp(
      prefix,
    );
