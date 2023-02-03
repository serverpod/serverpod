import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:yaml/yaml.dart';

/// Check current Serverpod CLI version and promt user to update if needed
Future<void> promtToUpdateIfNeeded() async {
  try {
    Logger logger = Logger(
      filter: _WithoutFiltering(),
      printer: PrettyPrinter(
        methodCount: 0,
        colors: false,
        printEmojis: true,
        lineLength: 80,
      ),
    );
    File file = File('pubspec.yaml');
    String str = file.readAsStringSync();
    YamlDocument doc = loadYamlDocument(str);
    YamlNode contents = doc.contents;
    if (contents is! YamlMap) return;
    String? packageName = contents.nodes['name']?.value.toString();
    String? currentVersion = contents.nodes['version']?.value.toString();
    if (currentVersion == null || packageName == null) return;
    Package? package = await _PackageService.getLatestPackage(packageName);
    if (package == null) return;
    bool isUpToDate = package.version == currentVersion;

    if (!isUpToDate) {
      print('');
      logger.i(
          '\nA new version ${package.version} of Serverpod CLI is available.\nhttps://pub.dev/packages/$packageName\n');
      print('');
    }
  } catch (e) {
    print(e);
  }
}

class _WithoutFiltering extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => true;
}

abstract class _PackageService {
  static Future<Package?> getLatestPackage(String name) async {
    try {
      Response respose =
          await get(Uri.parse('https://pub.dev/api/packages/$name'));
      Map<String, dynamic> map = jsonDecode(respose.body);
      return Package(name: map['name'], version: map['latest']['version']);
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class Package {
  final String name;
  final String version;
  Package({
    required this.name,
    required this.version,
  });
}
