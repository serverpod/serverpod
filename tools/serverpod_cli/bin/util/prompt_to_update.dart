import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:yaml/yaml.dart';

import 'print.dart';

/// Check current Serverpod CLI version and prompt user to update if needed
Future<void> promptToUpdateIfNeeded() async {
  try {
    String? currentVersion = _getPackageVersion();
    String? packageName = _getPackageName();
    if (currentVersion == null || packageName == null) return;
    _Package? package = await _PackageService.getLatestPackage(packageName);
    if (package == null) return;
    bool isUpToDate = package.version == 'currentVersion';

    if (!isUpToDate) {
      print('');
      print(promptMessage(package.version));
      print('');
    }
  } catch (e) {
    print(e);
  }
}

YamlMap? _getcurrentPackage() {
  File file = File('pubspec.yaml');
  String str = file.readAsStringSync();
  YamlDocument doc = loadYamlDocument(str);
  YamlNode contents = doc.contents;
  if (contents is! YamlMap) return null;
  return contents;
}

String? _getPackageVersion() {
  YamlMap? package = _getcurrentPackage();

  return package?.nodes['version']?.value.toString();
}

String? _getPackageName() {
  YamlMap? package = _getcurrentPackage();

  return package?.nodes['name']?.value.toString();
}

Future<void> updateCLI(
    {String? versionConstraint, bool verbose = false}) async {
  try {
    String? currentVersion = _getPackageVersion();
    String? packageName = _getPackageName();
    if (currentVersion == null || packageName == null) return;
    _Package? package = await _PackageService.getLatestPackage(packageName);
    if (package == null) return;
    if (package.version == currentVersion) {
      printww('Serverpod is up to date 😉');
    }
    ProcessResult upgrade = await Process.run(
      'dart',
      [
        'pub',
        'global',
        'activate',
        'serverpod',
        if (versionConstraint != null) versionConstraint,
      ],
    );
    if (upgrade.exitCode == 0) {
      stdout.write(upgrade.stdout);
      stderr.write(upgrade.stderr);
      printwwln('Serverpod CLI upgraded successfully');
      return;
    } else {
      if (verbose) printwwln(upgrade.stderr.toString());
      printwwln('Something went wrong, Failed to upgrade Serverpod CLI.');
      return;
    }
  } on Exception catch (e) {
    if (verbose) printwwln(e.toString());
    printwwln('Something went wrong, Failed to upgrade Serverpod CLI.');
    return;
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

String promptMessage(String version) {
  var versionLine =
      '│ A new version $version of Serverpod is available!                                              │';
  if (versionLine.length > 89) {
    while (versionLine.length > 89) {
      versionLine = versionLine.removeAtIndex(versionLine.length - 2);
    }
  }

  return '''
┌───────────────────────────────────────────────────────────────────────────────────────┐
$versionLine
│                                                                                       │
│ To update to the latest version, run "serverpod upgrade".                             │
│ Also, do not forget to update packages in your server, client, and flutter projects.  │
└───────────────────────────────────────────────────────────────────────────────────────┘
''';
}

extension on String {
  String removeAtIndex(int i) => substring(0, i) + substring(i + 1);
}
