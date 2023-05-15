import 'dart:io';
import 'package:yaml/yaml.dart';

const _serverSuffix = '_server';

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

  name = name.substring(0, name.length - _serverSuffix.length);

  print('project name: $name');
  return name;
}
