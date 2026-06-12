import 'dart:io';

import 'package:path/path.dart' as p;

/// Waits until the file system reports an mtime strictly after [reference].
///
/// Avoids hard-coded delays that may be too short on platforms with coarse
/// timestamp resolution (e.g. Windows). A scratch [dir] can be supplied to
/// probe on the same volume as the files under test.
Future<void> waitForMtimeAfter(DateTime reference, [Directory? dir]) async {
  dir ??= await Directory.systemTemp.createTemp();
  final probe = File(p.join(dir.path, '.mtime_probe'));
  try {
    for (var i = 0; i < 100; i++) {
      await probe.writeAsString('$i');
      if (probe.statSync().modified.isAfter(reference)) return;
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    throw StateError('File system mtime did not advance after 5 seconds');
  } finally {
    if (probe.existsSync()) await probe.delete();
  }
}
