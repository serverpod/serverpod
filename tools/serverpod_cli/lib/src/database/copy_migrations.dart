import 'dart:io';

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/util/copy_directory.dart';
import 'package:serverpod_cli/src/util/locate_modules.dart';

Future<void> copyMigrations(GeneratorConfig config) async {
  if (config.type == PackageType.module) {
    return;
  }
  var modulePaths = await locateAllModulePaths(directory: Directory.current);

  for (var modulePath in modulePaths) {
    var moduleDirectory = Directory.fromUri(modulePath);
    if (moduleDirectory.path == Directory.current.path) {
      continue;
    }

    var packageName = modulePath.pathSegments.last;
    var moduleName = moduleNameFromServerPackageName(packageName);

    var srcSegments = List<String>.from(modulePath.pathSegments)
      ..addAll([
        'migrations',
        moduleName,
      ])
      ..toList();
    var srcDirectory = Directory.fromUri(modulePath.replace(
      pathSegments: srcSegments,
    ));

    var dstSegments = List<String>.from(Directory.current.uri.pathSegments)
      ..addAll([
        'migrations',
        moduleName,
      ])
      ..toList();
    var dstDirectory = Directory.fromUri(Directory.current.uri.replace(
      pathSegments: dstSegments,
    ));

    if (!srcDirectory.existsSync()) {
      continue;
    }

    copyDirectory(srcDirectory, dstDirectory);
  }
}
