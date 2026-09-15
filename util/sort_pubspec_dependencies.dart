import 'dart:io';

import 'package:sort_pubspec_dependencies/pubspec_reader/pubspec_reader.dart';

/// Sorts every `pubspec.yaml` in the repository in a single process.
///
/// `dart run sort_pubspec_dependencies` from the workspace root resolves the
/// whole workspace. Doing that in parallel while rewriting member pubspecs
/// races: other `dart run` invocations read a file mid-write and fail with
/// "Missing the required name field" or "does not have resolution: workspace".
void main() {
  final pubspecs = <String>[];

  _collectPubspecs(Directory('.'), pubspecs);
  pubspecs.sort();

  final reader = PubspecReader();
  for (final path in pubspecs) {
    reader.writeSortedPubspec(path);
    stdout.writeln('✓ Sorted: $path');
  }
}

void _collectPubspecs(Directory dir, List<String> pubspecs) {
  for (final entity in dir.listSync(followLinks: false)) {
    if (entity is Directory) {
      final name = _baseName(entity.path);
      if (name == '.git' || name == '.dart_tool') continue;
      _collectPubspecs(entity, pubspecs);
      continue;
    }

    if (entity is! File || _baseName(entity.path) != 'pubspec.yaml') {
      continue;
    }

    // Same exclusion as `find ! -path "./pubspec.yaml"`: leave the workspace
    // root alone. `File.absolute.path` does not collapse `./`, so do not
    // compare resolved paths here.
    if (entity.path == 'pubspec.yaml' || entity.path == './pubspec.yaml') {
      continue;
    }
    pubspecs.add(entity.path);
  }
}

String _baseName(String path) {
  final separator = path.lastIndexOf(Platform.pathSeparator);
  return separator == -1 ? path : path.substring(separator + 1);
}
