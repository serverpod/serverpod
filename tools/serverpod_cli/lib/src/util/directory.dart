import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';

bool isServerpodRootDirectory([Directory? directory]) {
  // Verify that we are in the serverpod directory

  directory ??= Directory.current;
  var dirPackages = Directory(p.join(directory.path, 'packages'));
  var dirTemplates = Directory(p.join(directory.path, 'templates', 'pubspecs'));

  if (!dirPackages.existsSync() ||
      !dirTemplates.existsSync() ||
      !directory.existsSync()) {
    return false;
  }

  return true;
}

bool isServerDirectory(Directory directory) {
  var pubspec = File(p.join(directory.path, 'pubspec.yaml'));

  if (!pubspec.existsSync()) return false;

  var content = parsePubspec(pubspec);
  if (content.name == 'serverpod') return true;
  if (!content.dependencies.containsKey('serverpod')) return false;

  return true;
}

Directory? findServerDirectory(Directory root) {
  if (isServerDirectory(root)) return root;

  PubspecParseException? firstChildParseError;
  for (var entity in root.listSync()) {
    var dir = Directory.fromUri(entity.uri);
    try {
      if (isServerDirectory(dir)) return dir;
    } on PubspecParseException catch (e) {
      firstChildParseError ??= e;
    }
  }

  if (firstChildParseError != null) throw firstChildParseError;
  return null;
}
