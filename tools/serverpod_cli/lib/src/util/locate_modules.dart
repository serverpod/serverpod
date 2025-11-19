import 'dart:collection';
import 'dart:io';

import 'package:package_config/package_config.dart';
import 'package:path/path.dart' as path;
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:yaml/yaml.dart';

const _serverSuffix = '_server';

bool _isServerpodModule(String packageName) {
  return packageName.endsWith(_serverSuffix) || packageName == 'serverpod';
}

List<ModuleConfig> loadModuleConfigs({
  required Pubspec projectPubspec,
  required PackageConfig packageConfig,
  Map<String, String?> nickNameOverrides = const {},
}) {
  var projectModuleDependencies = _listModuleDependencies(
    projectPubspec: projectPubspec,
    packageConfig: packageConfig,
  );

  var moduleConfigs = _loadModuleConfigs(
    modules: projectModuleDependencies,
    nickNameOverrides: nickNameOverrides,
  );

  return moduleConfigs;
}

Set<Package> _listModuleDependencies({
  required Pubspec projectPubspec,
  required PackageConfig packageConfig,
}) {
  var projectModuleDependencies = <Package>{};
  var visitedModules = <String>{};
  var foundModules = Queue<String>();

  void queueModulesInPubspec(Pubspec projectPubspec) {
    for (var dependencyName in projectPubspec.dependencies.keys) {
      if (!_isServerpodModule(dependencyName)) {
        continue;
      }

      foundModules.add(dependencyName);
    }
  }

  queueModulesInPubspec(projectPubspec);

  while (foundModules.isNotEmpty) {
    var moduleName = foundModules.removeFirst();
    if (visitedModules.contains(moduleName)) {
      continue;
    }

    visitedModules.add(moduleName);

    var packageInfo = packageConfig.packages
        .where((pkg) => pkg.name == moduleName)
        .firstOrNull;

    if (packageInfo == null) {
      throw ServerpodModulesNotFoundException(
        'Failed to locate module dependency path in package config for '
        'dependency: $moduleName',
      );
    }

    projectModuleDependencies.add(packageInfo);

    Pubspec modulePubspec;
    try {
      var modulePubspecFile = File.fromUri(
        packageInfo.root.resolve('pubspec.yaml'),
      );
      modulePubspec = parsePubspec(modulePubspecFile);
    } catch (_) {
      continue;
    }

    queueModulesInPubspec(modulePubspec);
  }

  return projectModuleDependencies;
}

List<ModuleConfig> _loadModuleConfigs({
  required Set<Package> modules,
  Map<String, String?> nickNameOverrides = const {},
}) {
  var moduleConfigs = <ModuleConfig>[];

  for (var packageInfo in modules) {
    try {
      var packageName = packageInfo.name;

      var packageSrcRoot = packageInfo.root;

      var generatorConfigUri = packageSrcRoot.resolve(
        path.joinAll(['config', 'generator.yaml']),
      );

      var generatorConfigFile = File.fromUri(generatorConfigUri);
      if (!generatorConfigFile.existsSync()) {
        continue;
      }

      var migrationVersions = findAllMigrationVersionsSync(
        directory: Directory.fromUri(packageSrcRoot),
      );

      var moduleInfo = loadConfigFile(generatorConfigFile);

      var moduleName = moduleNameFromServerPackageName(packageName);
      var manualNickname = nickNameOverrides[moduleName];
      var nickname = manualNickname ?? moduleInfo['nickname'] ?? moduleName;

      moduleConfigs.add(
        ModuleConfig(
          type: GeneratorConfig.getPackageType(moduleInfo),
          name: moduleName,
          nickname: nickname,
          migrationVersions: migrationVersions,
          serverPackageDirectoryPathParts: packageSrcRoot.pathSegments,
        ),
      );
    } catch (e) {
      continue;
    }
  }

  return moduleConfigs;
}

Map<dynamic, dynamic> loadConfigFile(File file) {
  var yaml = file.readAsStringSync();
  return loadYaml(yaml) as Map;
}

List<String> findAllMigrationVersionsSync({
  required Directory directory,
}) {
  try {
    var migrationRoot = MigrationConstants.migrationsBaseDirectory(directory);

    var migrationsDir = migrationRoot.listSync().whereType<Directory>();

    var migrationVersions = migrationsDir
        .map((dir) => path.split(dir.path).last)
        .toList();

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
