import 'dart:io';

import 'package:path/path.dart' as p;

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
