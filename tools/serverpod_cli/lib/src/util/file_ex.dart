import 'dart:io';

extension FileEx on FileSystemEntity {
  /// Deletes the file if it exists.
  Future<void> deleteIfExists({bool recursive = false}) async {
    try {
      if (await exists()) await delete(recursive: recursive);
    } on PathNotFoundException catch (_) {
      // File already deleted (race)
    }
  }
}
