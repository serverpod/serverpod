import 'dart:io';

/// Creates a temporary directory under a short path, for a Unix socket.
///
/// macOS's temp directory is too deep. Elsewhere `/tmp` may not exist.
Future<Directory> createShortTempDir(String prefix) =>
    (Platform.isMacOS ? Directory('/tmp') : Directory.systemTemp).createTemp(
      prefix,
    );
