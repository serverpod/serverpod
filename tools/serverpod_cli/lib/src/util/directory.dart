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
  var generator = File(p.join(directory.path, 'config', 'generator.yaml'));


  if (!pubspec.existsSync() || !generator.existsSync()) {
    return false;
  }

  if (!pubspec.existsSync()) return false;

  var content = parsePubspec(pubspec);
  if (content.name == 'serverpod') return true;
  if (!content.dependencies.containsKey('serverpod')) return false;

  return true;
}
