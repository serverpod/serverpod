import 'dart:io';
import 'package:serverpod_cli/src/util/locate_modules.dart';
import 'package:yaml/yaml.dart';

Future<String> getProjectName() async {
  var pubspecFile = File('pubspec.yaml');
  if (!await pubspecFile.exists()) {
    throw Exception(
      'No pubspec.yaml file found in current directory.',
    );
  }

  var pubspec = loadYaml(await pubspecFile.readAsString());
  if (pubspec == null) {
    throw Exception(
      'Failed to parse pubspec.yaml file.',
    );
  }

  String? name = pubspec['name'];
  if (name == null) {
    throw Exception(
      'No name found in pubspec.yaml file.',
    );
  }

  name = moduleNameFromServerPackageName(name);
  return name;
}
