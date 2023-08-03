import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/util/directory.dart';
import 'package:serverpod_cli/src/util/pub_api_client.dart';
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';

/// The internal tool for analyzing the pubspec.yaml files in the Serverpod
/// repo.
Future<bool> pubspecDependenciesMatch(bool checkLatestVersion) async {
  var directory = Directory.current;
  if (!isServerpodRootDirectory(directory)) {
    log.error('Must be run from the serverpod repository root');
    return false;
  }

  var pubspecFiles = findPubspecsFiles(directory,
      ignorePaths: [p.join('templates', 'pubspecs'), 'test_assets']);

  Map<String, List<_ServerpodDependency>> dependencies;
  try {
    dependencies = _getDependencies(pubspecFiles);
  } catch (e) {
    log.error('Failed to get dependencies');
    log.error(e.toString());
    return false;
  }

  var mismatchedDeps = _findMismatchedDependencies(dependencies);

  if (mismatchedDeps.isNotEmpty) {
    _printMismatchedDependencies(mismatchedDeps, dependencies);
    return false;
  }

  log.info('Dependencies match.');

  if (checkLatestVersion) {
    await _checkLatestVersion(dependencies);
  }

  return true;
}

Future<void> _checkLatestVersion(
    Map<String, List<_ServerpodDependency>> dependencies) async {
  log.info('Checking latest pub versions.');
  try {
    var pub = PubApiClient();
    for (var depName in dependencies.keys) {
      var deps = dependencies[depName]!;
      var depVersion = deps.first.version;
      var latestPubVersion = await pub.tryFetchLatestStableVersion(depName);

      if (latestPubVersion != null &&
          depVersion != '^${latestPubVersion.toString()}') {
        log.info(depName);
        log.info('local: $depVersion');
        log.info('pub:   ^$latestPubVersion');
        log.info('found in:');
        for (var dep in deps) {
          log.info(
            dep.serverpodPackage,
            type: TextLogType.bullet,
          );
        }
      }
    }
  } catch (e) {
    log.error('Version check failed.');
    log.error(e.toString());
  }
}

void _printMismatchedDependencies(Set<String> mismatchedDeps,
    Map<String, List<_ServerpodDependency>> dependencies) {
  log.error('Found mismatched dependencies:');
  for (var depName in mismatchedDeps) {
    log.error(
      depName,
      type: const RawLogType(),
    );
    var deps = dependencies[depName]!;
    for (var dep in deps) {
      log.error(
        '${dep.version} ${dep.serverpodPackage}',
        type: TextLogType.bullet,
      );
    }
  }
}

Set<String> _findMismatchedDependencies(
  Map<String, List<_ServerpodDependency>> dependencies,
) {
  var mismatchedDeps = <String>{};
  for (var depName in dependencies.keys) {
    var deps = dependencies[depName]!;
    String? version;
    for (var dep in deps) {
      if (version != null && version != dep.version) {
        mismatchedDeps.add(depName);
      }
      version = dep.version;
    }
  }
  return mismatchedDeps;
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
