import 'dart:io';

import 'package:pubspec_parse/pubspec_parse.dart';

Pubspec? tryParsePubspec(File pubspecFile) {
  try {
    var yaml = pubspecFile.readAsStringSync();
    var pubspec = Pubspec.parse(yaml);
    return pubspec;
  } catch (e) {
    print('Error while parsing pubspec file: ${pubspecFile.path}');
    print(e);
    return null;
  }
}

List<File> findPubspecsFiles(Directory dir,
    {List<String> ignorePaths = const []}) {
  var pubspecFiles = <File>[];
  for (var file in dir.listSync(recursive: true)) {
    if (_shouldBeIgnored(file.path, ignorePaths)) continue;

    if (file is File && file.path.endsWith('pubspec.yaml')) {
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
