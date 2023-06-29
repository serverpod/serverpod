import 'dart:io';

import 'package:path/path.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

Pubspec parsePubspec(File pubspecFile) {
  try {
    var yaml = pubspecFile.readAsStringSync();
    var pubspec = Pubspec.parse(yaml);
    return pubspec;
  } catch (e) {
    throw Exception(
        'Error while parsing pubspec file: ${pubspecFile.path}: $e');
  }
}

List<File> findPubspecsFiles(Directory dir,
    {List<String> ignorePaths = const []}) {
  var pubspecFiles = <File>[];
  for (var file in dir.listSync(recursive: true)) {
    if (_shouldBeIgnored(file.path, ignorePaths)) continue;

    if (file is File && basename(file.path) == 'pubspec.yaml') {
      pubspecFiles.add(file);
    }
  }

  return pubspecFiles;
}

bool _shouldBeIgnored(String path, List<String> ignorePaths) {
  for (var ignorePath in ignorePaths) {
    if (path.contains(ignorePath)) {
      return true;
    }
  }

  return false;
}
