import 'dart:io';
import 'package:serverpod_cli/src/util/locate_modules.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as path;

Future<String?> getProjectName([Directory? projectDirectory]) async {
  projectDirectory ??= Directory.current;
  var pubspecFile = File(path.join(projectDirectory.path, 'pubspec.yaml'));
  if (!await pubspecFile.exists()) {
    log.error('No pubspec.yaml file found in current directory.');
    return null;
  }

  var pubspec = loadYaml(await pubspecFile.readAsString());
  if (pubspec == null) {
    log.error('Failed to parse pubspec.yaml file.');
    return null;
  }

  String? name = pubspec['name'];
  if (name == null) {
    log.error('No name found in pubspec.yaml file.');
    return null;
  }

  try {
    return moduleNameFromServerPackageName(name);
  } catch (e) {
    log.error(e.toString());
    return null;
  }
}
