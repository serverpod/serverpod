import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:serverpod_cli/src/util/directory.dart';
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:yaml/yaml.dart';

class CheckLatestVersion {
  final bool onlyMajorUpdate;
  final bool ignoreServerpodPackages;

  CheckLatestVersion({
    required this.onlyMajorUpdate,
    required this.ignoreServerpodPackages,
  });
}

/// The internal tool for analyzing the pubspec.yaml files in the Serverpod
/// repo.
Future<bool> pubspecDependenciesMatch({
  required CheckLatestVersion? checkLatestVersion,
}) async {
  var directory = Directory.current;
  if (!isServerpodRootDirectory(directory)) {
    log.error('Must be run from the serverpod repository root');
    return false;
  }

  var pubspecFiles = findPubspecsFiles(
    directory,
    ignorePaths: [p.join('templates', 'pubspecs'), 'test_assets'],
  );

  Map<String, List<_ServerpodDependency>> dependencies;
  try {
    dependencies = _getDependencies(pubspecFiles);
  } catch (e) {
    log.error('Failed to get dependencies');
    log.error(e.toString());
    return false;
  }

  var ignoredPackages = _loadIgnoredPackages(directory);
  var mismatchedDeps = _findMismatchedDependencies(
    dependencies,
    ignoredPackages,
  );

  if (mismatchedDeps.isNotEmpty) {
    _printMismatchedDependencies(mismatchedDeps, dependencies);
    return false;
  }

  log.info('Dependencies match.');

  if (checkLatestVersion != null) {
    return await _checkLatestVersion(
      dependencies,
      onlyMajorUpdate: checkLatestVersion.onlyMajorUpdate,
      ignoreServerpodPackages: checkLatestVersion.ignoreServerpodPackages,
    );
  }

  return true;
}

Future<bool> _checkLatestVersion(
  Map<String, List<_ServerpodDependency>> dependencies, {
  required bool onlyMajorUpdate,
  required bool ignoreServerpodPackages,
}) async {
  bool latestVersionMatch = true;
  log.info('Checking latest pub versions.');
  try {
    var pub = PubApiClient();
    for (var depName in dependencies.keys) {
      var deps = dependencies[depName]!;
      Version? latestPubVersion;
      try {
        latestPubVersion = await pub.tryFetchLatestStableVersion(depName);
      } on VersionFetchException catch (e) {
        log.error(e.message);
      } on VersionParseException catch (e) {
        log.error(e.message);
      }

      // Crude way to ignore serverpod packages when checking for latest version.
      // This might cause unintentionally exclusion of external packages.
      // TODO: Improve this, tracking issue: https://github.com/serverpod/serverpod/issues/2603
      if (ignoreServerpodPackages && depName.startsWith('serverpod')) {
        continue;
      }

      if (latestPubVersion == null) {
        continue;
      }

      var depVersion = VersionConstraint.parse(deps.first.version);
      var differentVersion = switch (onlyMajorUpdate) {
        true => !depVersion.allows(latestPubVersion),
        false => depVersion != latestPubVersion,
      };

      if (differentVersion) {
        latestVersionMatch = false;
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
    pub.close();
  } catch (e) {
    log.error('Version check failed.');
    log.error(e.toString());
  }

  return latestVersionMatch;
}

void _printMismatchedDependencies(
  Set<String> mismatchedDeps,
  Map<String, List<_ServerpodDependency>> dependencies,
) {
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

Set<String> _loadIgnoredPackages(Directory directory) {
  var rootPubspecFile = File(p.join(directory.path, 'pubspec.yaml'));
  if (!rootPubspecFile.existsSync()) {
    return {};
  }

  try {
    var yamlString = rootPubspecFile.readAsStringSync();
    var yaml = loadYaml(yamlString);

    if (yaml is! YamlMap) {
      return {};
    }

    var serverpodCli = yaml['serverpod_cli'];
    if (serverpodCli is! YamlMap) {
      return {};
    }

    var analyzePubspecs = serverpodCli['analyze_pubspecs'];
    if (analyzePubspecs is! YamlMap) {
      return {};
    }

    var ignorePackages = analyzePubspecs['ignore_packages'];
    if (ignorePackages is! YamlList) {
      return {};
    }

    return ignorePackages.cast<String>().toSet();
  } catch (e) {
    log.warning('Failed to load ignored packages from root pubspec.yaml: $e');
    return {};
  }
}

Set<String> _findMismatchedDependencies(
  Map<String, List<_ServerpodDependency>> dependencies,
  Set<String> ignoredPackages,
) {
  var mismatchedDeps = <String>{};
  for (var depName in dependencies.keys) {
    if (ignoredPackages.contains(depName)) {
      continue;
    }
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
