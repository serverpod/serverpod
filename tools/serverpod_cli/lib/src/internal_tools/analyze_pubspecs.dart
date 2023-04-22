import 'dart:io';

import 'package:pub_api_client/pub_api_client.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

/// The internal tool for analyzing the pubspec.yaml files in the Serverpod
/// repo.
Future<void> performAnalyzePubspecs(bool checkLatestVersion) async {
  // Verify that we are in the serverpod directory
  var dirPackages = Directory('packages');
  var dirTemplates = Directory('templates/pubspecs');
  var dirRoot = Directory('.');

  if (!dirPackages.existsSync() ||
      !dirTemplates.existsSync() ||
      !dirRoot.existsSync()) {
    print('Must be run from the serverpod repository root');
    exit(1);
  }

  var pubspecs = _getPubspecs();
  var dependencies = <String, List<_ServerpodDependency>>{};

  for (var pubspec in pubspecs) {
    // Dependencies
    for (var depName in pubspec.dependencies.keys) {
      var dep = pubspec.dependencies[depName]!;

      if (dep is HostedDependency) {
        var depList = dependencies[depName] ?? [];
        depList.add(
          _ServerpodDependency(
            serverpodPackage: pubspec.name,
            dependencyName: depName,
            version: dep.version.toString(),
          ),
        );
        dependencies[depName] = depList;
      }
    }

    // Dev dependencies
    for (var depName in pubspec.devDependencies.keys) {
      var dep = pubspec.devDependencies[depName]!;

      if (dep is HostedDependency) {
        var depList = dependencies[depName] ?? [];
        depList.add(
          _ServerpodDependency(
            serverpodPackage: pubspec.name,
            dependencyName: depName,
            version: dep.version.toString(),
          ),
        );
        dependencies[depName] = depList;
      }
    }
  }

  // Find missmatched dependencies
  var missmatchedDeps = <String>{};
  for (var depName in dependencies.keys) {
    var deps = dependencies[depName]!;
    String? version;
    for (var dep in deps) {
      if (version != null && version != dep.version) {
        missmatchedDeps.add(depName);
      }
      version = dep.version;
    }
  }

  if (missmatchedDeps.isNotEmpty) {
    print('Found missmatched dependencies:');
    for (var depName in missmatchedDeps) {
      print(depName);
      var deps = dependencies[depName]!;
      for (var dep in deps) {
        print('  ${dep.version} ${dep.serverpodPackage}');
      }
    }

    exit(1);
  }

  print('Dependencies match.');

  // Check versions.
  if (checkLatestVersion) {
    print('Checking latest pub versions.');
    try {
      var pub = PubClient();
      for (var depName in dependencies.keys) {
        var deps = dependencies[depName]!;
        var depVersion = deps.first.version;
        var latestPubVersion = _latestStableVersion(
          await pub.packageVersions(depName),
        );

        if (depVersion != '^$latestPubVersion') {
          print(depName);
          print('  local: $depVersion');
          print('  pub:   ^$latestPubVersion');
          print('  found in:');
          for (var dep in deps) {
            print('   - ${dep.serverpodPackage}');
          }
        }
      }
      pub.close();
    } catch (e) {
      print('Version check failed.');
      print(e);
    }
  }
}

String _latestStableVersion(List<String> packageVersions) {
  for (var version in packageVersions) {
    if (!version.contains('-') && !version.contains('+')) {
      return version;
    }
  }
  return packageVersions.first;
}

List<Pubspec> _getPubspecs() {
  try {
    var pubspecFiles = _findPubspecsFiles(['/serverpod/templates/pubspecs/']);

    var pubspecs = <Pubspec>[];
    for (var file in pubspecFiles) {
      var yaml = file.readAsStringSync();
      var pubspec = Pubspec.parse(yaml);
      pubspecs.add(pubspec);
    }
    return pubspecs;
  } catch (e) {
    print(
      'Failed to load PUBLISHABLE_PACKAGES or the pubspec files. Are you'
      'running this command from the serverpod repository root?',
    );
    print(e);
    exit(1);
  }
}

List<File> _findPubspecsFiles(List<String> ignorePaths) {
  var dir = Directory.current;
  var pubspecFiles = <File>[];
  for (var file in dir.listSync(recursive: true)) {
    bool ignore = false;
    for (var ignorePath in ignorePaths) {
      if (file.path.contains(ignorePath)) {
        ignore = true;
      }
    }

    if (ignore) continue;

    if (file is File && file.path.endsWith('pubspec.yaml')) {
      pubspecFiles.add(file);
    }
  }

  return pubspecFiles;
}

class _ServerpodDependency {
  final String serverpodPackage;
  final String dependencyName;
  final String version;

  _ServerpodDependency({
    required this.serverpodPackage,
    required this.dependencyName,
    required this.version,
  });
}
