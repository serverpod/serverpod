import 'dart:io';

import 'package:pub_api_client/pub_api_client.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:serverpod_cli/src/util/directory.dart';
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';

/// The internal tool for analyzing the pubspec.yaml files in the Serverpod
/// repo.
Future<void> performAnalyzePubspecs(bool checkLatestVersion) async {
  var directory = Directory.current;
  if (!isServerpodRootDirectory(directory)) {
    print('Must be run from the serverpod repository root');
    exit(1);
  }

  var pubspecFiles = findPubspecsFiles(directory,
      ignorePaths: ['/templates/pubspecs/', '/test_assets/']);

  Map<String, List<_ServerpodDependency>> dependencies;
  try {
    dependencies = _getDependencies(pubspecFiles);
  } catch (e) {
    print('Failed to get dependencies');
    print(e);
    exit(1);
  }

  var missmatchedDeps = _findMissmatchedDependencies(dependencies);

  if (missmatchedDeps.isNotEmpty) {
    _printMissmatchedDependencies(missmatchedDeps, dependencies);
    exit(1);
  }

  print('Dependencies match.');

  if (checkLatestVersion) {
    await _checkLatestVersion(dependencies);
  }
}

Future<void> _checkLatestVersion(
    Map<String, List<_ServerpodDependency>> dependencies) async {
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

void _printMissmatchedDependencies(Set<String> missmatchedDeps,
    Map<String, List<_ServerpodDependency>> dependencies) {
  print('Found missmatched dependencies:');
  for (var depName in missmatchedDeps) {
    print(depName);
    var deps = dependencies[depName]!;
    for (var dep in deps) {
      print('  ${dep.version} ${dep.serverpodPackage}');
    }
  }
}

Set<String> _findMissmatchedDependencies(
  Map<String, List<_ServerpodDependency>> dependencies,
) {
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
  return missmatchedDeps;
}

Map<String, List<_ServerpodDependency>> _getDependencies(
  List<File> pubspecFiles,
) {
  var dependencies = <String, List<_ServerpodDependency>>{};
  for (var pubspecFile in pubspecFiles) {
    var pubspec = parsePubspec(pubspecFile);

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

  return dependencies;
}

String _latestStableVersion(List<String> packageVersions) {
  for (var version in packageVersions) {
    if (!version.contains('-') && !version.contains('+')) {
      return version;
    }
  }
  return packageVersions.first;
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
