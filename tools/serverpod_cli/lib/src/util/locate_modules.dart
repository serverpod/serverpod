import 'dart:io';

import 'package:package_config/package_config.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:yaml/yaml.dart';

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

        if (!packageName.endsWith(_serverSuffix) &&
            packageName != 'serverpod') {
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

        var moduleInfo = loadConfigFile(generatorConfigFile);

        var manualNickname = manualModules[moduleName];
        var nickname = manualNickname ?? moduleInfo['nickname'] ?? moduleName;

        modules.add(
          ModuleConfig(
            type: GeneratorConfig.getPackageType(moduleInfo),
            name: moduleName,
            nickname: nickname,
            migrationVersions: migrationVersions,
            serverPackageDirectoryPathParts: moduleProjectRoot,
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

Map<dynamic, dynamic> loadConfigFile(File file) {
  var yaml = file.readAsStringSync();
  return loadYaml(yaml) as Map;
}

List<String> findAllMigrationVersionsSync({
  required Directory directory,
  required String moduleName,
}) {
  try {
    var migrationRoot = MigrationConstants.migrationsBaseDirectory(directory);

    var migrationsDir = migrationRoot.listSync().whereType<Directory>();

    var migrationVersions =
        migrationsDir.map((dir) => path.split(dir.path).last).toList();

    migrationVersions.sort();
    return migrationVersions;
  } catch (e) {
    return [];
  }
}

/// This method assumes that server package names end with `_server`.
/// If the package name does not follow this convention, an exception is thrown.
///
/// Throws:
/// - [LocateModuleNameFromServerPackageNameException] if the package name
///   does not end with `_server`, indicating it is not a valid server package.
String moduleNameFromServerPackageName(String packageDirName) {
  var packageName = packageDirName.split('-').first;

  if (packageName == 'serverpod') {
    return 'serverpod';
  }
  if (!packageName.endsWith(_serverSuffix)) {
    throw LocateModuleNameFromServerPackageNameException(
      packageName: packageName,
    );
  }
  return packageName.substring(0, packageName.length - _serverSuffix.length);
}

/// Exception thrown when a module name cannot be determined from the server package name.
class LocateModuleNameFromServerPackageNameException implements Exception {
  /// The package name that doesn't have a suffix of '_server'.
  final String packageName;

  /// Creates a new [LocateModuleNameFromServerPackageNameException].
  LocateModuleNameFromServerPackageNameException({
    required this.packageName,
  });
}
