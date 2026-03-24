import 'dart:io';

extension FileEx on File {
  /// Deletes the file if it exists.
  Future<void> deleteIfExists() async {
    try {
      if (await exists()) await delete();
    } on PathNotFoundException catch (_) {
      // File already deleted (race)
    }
  }
}
