import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:yaml/yaml.dart';

const promtMessage = '''
┌───────────────────────────────────────────────────────────────────────────────────────┐
│ A new version of Serverpod is available!                                              │
│                                                                                       │
│ To update to the latest version, run "dart pub global activate serverpod_cli".        │
│ Also, do not forget to update packages in your server, client, and flutter projects.  │
└───────────────────────────────────────────────────────────────────────────────────────┘
''';

/// Check current Serverpod CLI version and promt user to update if needed
Future<void> promtToUpdateIfNeeded() async {
  try {
    File file = File('pubspec.yaml');
    String str = file.readAsStringSync();
    YamlDocument doc = loadYamlDocument(str);
    YamlNode contents = doc.contents;
    if (contents is! YamlMap) return;
    String? packageName = contents.nodes['name']?.value.toString();
    String? currentVersion = contents.nodes['version']?.value.toString();
    if (currentVersion == null || packageName == null) return;
    _Package? package = await _PackageService.getLatestPackage(packageName);
    if (package == null) return;
    bool isUpToDate = package.version == currentVersion;

    if (!isUpToDate) {
      print('');
      print(promtMessage);
      print('');
    }
  } catch (e) {
    print(e);
  }
}

abstract class _PackageService {
  static Future<_Package?> getLatestPackage(String name) async {
    try {
      Response respose =
          await get(Uri.parse('https://pub.dev/api/packages/$name'));
      Map<String, dynamic> map = jsonDecode(respose.body);
      return _Package(name: map['name'], version: map['latest']['version']);
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class _Package {
  final String name;
  final String version;
  _Package({
    required this.name,
    required this.version,
  });
}
