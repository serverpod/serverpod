import 'dart:io';

import 'package:package_config/package_config.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as path;

const _serverSuffix = '_server';

Future<List<ModuleConfig>?> locateModules({
  required Directory directory,
  List<String> excludePackages = const [],
  Map<String, String?> manualModules = const {},
}) async {
  var modules = <ModuleConfig>[];

  var packageConfig = await findPackageConfig(directory);
  if (packageConfig != null) {
    for (var packageInfo in packageConfig.packages) {
      try {
        var packageName = packageInfo.name;
        if (excludePackages.contains(packageName)) {
          continue;
        }

        if (!packageName.endsWith(_serverSuffix)) {
          continue;
        }
        var moduleName = moduleNameFromServerPackageName(packageName);

        var packageSrcRoot = packageInfo.packageUriRoot;
        var moduleProjectRoot = List<String>.from(packageSrcRoot.pathSegments)
          ..removeLast()
          ..removeLast();
        var generatorConfigSegments = path
            .joinAll([...moduleProjectRoot, 'config', 'generator.yaml']).split(
                path.separator);

        var generatorConfigUri = packageSrcRoot.replace(
          pathSegments: generatorConfigSegments,
        );

        var generatorConfigFile = File.fromUri(generatorConfigUri);
        if (!await generatorConfigFile.exists()) {
          continue;
        }

        var moduleProjectUri = packageSrcRoot.replace(
          pathSegments: moduleProjectRoot,
        );

        var migrationVersions = findAllMigrationVersionsSync(
          directory: Directory.fromUri(moduleProjectUri),
          moduleName: moduleName,
        );

        var moduleInfo = _ModuleGeneratorConfigLite(generatorConfigFile);

        var manualNickname = manualModules[moduleName];
        var nickname = manualNickname ?? moduleInfo.nickname ?? moduleName;

        modules.add(
          ModuleConfig(
            name: moduleName,
            nickname: nickname,
            migrationVersions: migrationVersions,
          ),
        );
      } catch (e) {
        continue;
      }
    }

    return modules;
  } else {
    log.error(
      'Failed to read your server\'s package configuration. Have you run '
      '`dart pub get` in your server directory?',
    );
    return null;
  }
}

class _ModuleGeneratorConfigLite {
  String? nickname;

  _ModuleGeneratorConfigLite(File file) {
    var yaml = file.readAsStringSync();
    var map = loadYaml(yaml) as Map;
    if (map['type'] != 'module') {
      throw const FormatException('Not a module config');
    }
    nickname = map['nickname'];
  }
}

List<String> findAllMigrationVersionsSync({
  required Directory directory,
  required String moduleName,
}) {
  try {
    var migrationRoot = Directory(path.join(
      MigrationConstants.migrationsBaseDirectory(directory).path,
      moduleName,
    ));

    var migrationsDir = migrationRoot.listSync().whereType<Directory>();

    var migrationVersions =
        migrationsDir.map((dir) => path.split(dir.path).last).toList();

    return migrationVersions;
  } catch (e) {
    return [];
  }
}

Future<List<Uri>> locateAllModulePaths({
  required Directory directory,
}) async {
  var packageConfig = await findPackageConfig(directory);
  if (packageConfig == null) {
    throw Exception('Failed to read package configuration.');
  }

  var paths = <Uri>[];
  for (var packageInfo in packageConfig.packages) {
    try {
      var packageName = packageInfo.name;
      if (!packageName.endsWith(_serverSuffix) && packageName != 'serverpod') {
        continue;
      }

      var packageSrcRoot = packageInfo.packageUriRoot;

      // Check for generator file
      var generatorConfigSegments =
          List<String>.from(packageSrcRoot.pathSegments)
            ..removeLast()
            ..removeLast()
            ..addAll(['config', 'generator.yaml']);
      var generatorConfigUri = packageSrcRoot.replace(
        pathSegments: generatorConfigSegments,
      );

      var generatorConfigFile = File.fromUri(generatorConfigUri);
      if (!await generatorConfigFile.exists()) {
        continue;
      }

      // Get the root of the package
      var packageRootSegments = List<String>.from(packageSrcRoot.pathSegments)
        ..removeLast()
        ..removeLast();
      var packageRoot = packageSrcRoot.replace(
        pathSegments: packageRootSegments,
      );
      paths.add(packageRoot);
    } catch (e) {
      log.debug(e.toString());
      continue;
    }
  }
  return paths;
}

String moduleNameFromServerPackageName(String packageDirName) {
  var packageName = packageDirName.split('-').first;

  if (packageName == 'serverpod') {
    return 'serverpod';
  }
  if (!packageName.endsWith(_serverSuffix)) {
    throw Exception('Not a server package ($packageName)');
  }
  return packageName.substring(0, packageName.length - _serverSuffix.length);
}
