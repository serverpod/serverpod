import 'dart:io';

final _sharedTestDir = _initSharedTestDir();

/// Returns a path that is shared across all test files within a single
/// `dart test` invocation, but unique per invocation.
///
/// This is useful for sharing state between test files that run in separate
/// isolates. Each `dart test` run gets a unique directory based on the
/// process ID.
///
/// On first access, stale directories from previous test runs (older than
/// one day) are cleaned up, if any.
Directory get sharedTestDir => _sharedTestDir;

Directory _initSharedTestDir() {
  const prefix = 'test_run_';
  final testRunDir = Directory('${Directory.systemTemp.path}/$prefix$pid');

  // If directory exists, another isolate already did cleanup
  if (testRunDir.existsSync()) {
    return testRunDir;
  }

  // Clean up stale directories from other PIDs. Mostly to accommodate Windows,
  // but will also cleanup faster on MacOS and Linux.
  final now = DateTime.now();
  for (final entity in Directory.systemTemp.listSync()) {
    if (entity is Directory) {
      final name = entity.uri.pathSegments.last;
      if (name.startsWith(prefix)) {
        final dirPid = int.tryParse(name.substring(prefix.length));
        if (dirPid != null && dirPid != pid) {
          final age = now.difference(entity.statSync().modified);
          if (age.inDays >= 1) {
            try {
              entity.deleteSync(recursive: true);
            } catch (_) {
              // Ignore - might be in use
            }
          }
        }
      }
    }
  }

  testRunDir.createSync(recursive: true);
  return testRunDir;
}
