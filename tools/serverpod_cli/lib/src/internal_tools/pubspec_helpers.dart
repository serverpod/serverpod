import 'dart:io';

import 'package:pubspec_parse/pubspec_parse.dart';

Pubspec parsePubspec(File pubspecFile, String errorMessage) {
  try {
    var yaml = pubspecFile.readAsStringSync();
    var pubspec = Pubspec.parse(yaml);
    return pubspec;
  } catch (e) {
    print(errorMessage);
    print(e);
    exit(1);
  }
}

List<File> findPubspecsFiles(Directory dir,
    {List<String> ignorePaths = const []}) {
  var pubspecFiles = <File>[];
  for (var file in dir.listSync(recursive: true)) {
    bool ignore = false;
    for (var ignorePath in ignorePaths) {
      if (file.path.contains(ignorePath)) {
        ignore = true;
      }
    }

    if (ignore) continue;

    if (file is File && file.path.endsWith('pubspec.yaml')) {
      pubspecFiles.add(file);
    }
  }

  return pubspecFiles;
}
