import 'dart:io';

import 'package:package_config/package_config.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/util/print.dart';
import 'package:yaml/yaml.dart';

const _serverSuffix = '_server';

Future<List<ModuleConfig>> locateModules({
  required Directory directory,
  List<String> exludePackages = const [],
}) async {
  var modules = <ModuleConfig>[];

  var packageConfig = await findPackageConfig(directory);
  if (packageConfig != null) {
    for (var packageInfo in packageConfig.packages) {
      try {
        var packageName = packageInfo.name;
        if (exludePackages.contains(packageName)) {
          continue;
        }

        if (!packageName.endsWith(_serverSuffix)) {
          continue;
        }
        var moduleName = packageName.substring(
          0,
          packageName.length - _serverSuffix.length,
        );

        var packageSrcRoot = packageInfo.packageUriRoot;
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

        var moduleInfo = _ModuleGeneratorConfigLite(generatorConfigFile);
        if (moduleInfo.nickname == null) {
          continue;
        }

        modules.add(
          ModuleConfig(name: moduleName, nickname: moduleInfo.nickname!),
        );
      } catch (e) {
        continue;
      }
    }

    return modules;
  } else {
    printww(
      'Failed to read your server\'s package configuration. Have you run '
      '`dart pub get` in your server directory?',
    );
    exit(1);
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
