import 'dart:io';

extension FileEx on File {
  /// Deletes the file if it exists.
  Future<void> deleteIfExists() async {
    if (await exists()) await delete();
  }
}
