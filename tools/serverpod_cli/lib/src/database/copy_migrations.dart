import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/util/copy_directory.dart';
import 'package:serverpod_cli/src/util/locate_modules.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

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

    var srcDirectory = _moduleMigrationDirectory(moduleDirectory, moduleName);

    var dstDirectory = _moduleMigrationDirectory(Directory.current, moduleName);

    if (!srcDirectory.existsSync()) {
      continue;
    }

    if (dstDirectory.existsSync()) {
      dstDirectory.deleteSync(recursive: true);
    }

    copyDirectory(srcDirectory, dstDirectory);
  }
}

Directory _moduleMigrationDirectory(
        Directory projectDirectory, String moduleName) =>
    Directory(
      path.join(
          MigrationConstants.migrationsBaseDirectory(projectDirectory).path,
          moduleName),
    );
