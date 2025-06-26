import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:yaml/yaml.dart';

/// Represents the type of a dependency in pubspec.lock
enum DependencyType {
  /// Direct dependency from pubspec.yaml
  directMain('direct main'),

  /// Direct dev dependency from pubspec.yaml
  directDev('direct dev'),

  /// Transitive dependency (dependency of a dependency)
  transitive('transitive'),

  /// Direct overridden dependency
  directOverridden('direct overridden');

  final String value;
  const DependencyType(this.value);

  static DependencyType fromString(String value) {
    return DependencyType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw ArgumentError('Unknown dependency type: $value'),
    );
  }
}

/// Represents the source of a package in pubspec.lock
enum PackageSource {
  /// Package from pub.dev or custom hosted repository
  hosted('hosted'),

  /// Local path dependency
  path('path'),

  /// Git repository dependency
  git('git'),

  /// SDK dependency (dart, flutter)
  sdk('sdk');

  final String value;
  const PackageSource(this.value);

  static PackageSource fromString(String value) {
    return PackageSource.values.firstWhere(
      (source) => source.value == value,
      orElse: () => throw ArgumentError('Unknown package source: $value'),
    );
  }
}

/// Represents a package entry in pubspec.lock
class LockedPackage {
  final String name;
  final Dependency dependency;
  final DependencyType dependencyType;
  final Version version;
  final String? sha256;
  final PackageSource source;

  LockedPackage({
    required this.name,
    required this.dependency,
    required this.dependencyType,
    required this.version,
    this.sha256,
    required this.source,
  });

  /// Whether this is a direct dependency (not transitive)
  bool get isDirect =>
      dependencyType == DependencyType.directMain ||
      dependencyType == DependencyType.directDev ||
      dependencyType == DependencyType.directOverridden;

  /// Whether this is a dev dependency
  bool get isDevDependency => dependencyType == DependencyType.directDev;

  /// Whether this is a transitive dependency
  bool get isTransitive => dependencyType == DependencyType.transitive;
}

/// Parser for pubspec.lock files
class PubspecLockParser {
  final Map<String, LockedPackage> packages;
  final VersionConstraint? dartSdkConstraint;
  final VersionConstraint? flutterSdkConstraint;

  PubspecLockParser._({
    required this.packages,
    this.dartSdkConstraint,
    this.flutterSdkConstraint,
  });

  /// Parse a pubspec.lock file from a [File]
  factory PubspecLockParser.fromFile(File file) {
    final content = file.readAsStringSync();
    return PubspecLockParser.parse(content, sourceUrl: file.uri);
  }

  /// Parse a pubspec.lock file from a string
  factory PubspecLockParser.parse(String yamlString, {Uri? sourceUrl}) {
    final yaml = loadYaml(yamlString, sourceUrl: sourceUrl);
    if (yaml is! YamlMap) {
      throw const FormatException('pubspec.lock must be a YAML map');
    }

    final packages = <String, LockedPackage>{};

    // Parse packages
    final packagesYaml = yaml['packages'] as YamlMap?;
    if (packagesYaml != null) {
      for (final entry in packagesYaml.entries) {
        final packageName = entry.key as String;
        final packageData = entry.value as YamlMap;

        final package = _parsePackage(packageName, packageData);
        packages[packageName] = package;
      }
    }

    // Parse SDK constraints
    VersionConstraint? dartSdkConstraint;
    VersionConstraint? flutterSdkConstraint;

    final sdksYaml = yaml['sdks'] as YamlMap?;
    if (sdksYaml != null) {
      final dartConstraint = sdksYaml['dart'];
      if (dartConstraint != null) {
        dartSdkConstraint = VersionConstraint.parse(dartConstraint as String);
      }
      final flutterConstraint = sdksYaml['flutter'];
      if (flutterConstraint != null) {
        flutterSdkConstraint =
            VersionConstraint.parse(flutterConstraint as String);
      }
    }

    return PubspecLockParser._(
      packages: packages,
      dartSdkConstraint: dartSdkConstraint,
      flutterSdkConstraint: flutterSdkConstraint,
    );
  }

  static LockedPackage _parsePackage(String name, YamlMap packageData) {
    final dependencyTypeStr = packageData['dependency'] as String;
    final dependencyType = DependencyType.fromString(dependencyTypeStr);

    final sourceStr = packageData['source'] as String;
    final source = PackageSource.fromString(sourceStr);
    final versionStr = packageData['version'] as String;
    final version = Version.parse(versionStr);

    final descriptionYaml = packageData['description'];

    // Parse dependency based on source type
    final Dependency dependency;
    String? sha256;

    switch (source) {
      case PackageSource.hosted:
        if (descriptionYaml is String) {
          // Simple hosted dependency
          dependency = HostedDependency(
            version: VersionConstraint.compatibleWith(version),
          );
        } else if (descriptionYaml is YamlMap) {
          // Hosted dependency with details
          final hostedName = descriptionYaml['name'] as String?;
          final url = descriptionYaml['url'] as String?;
          sha256 = descriptionYaml['sha256'] as String?;

          dependency = HostedDependency(
            version: VersionConstraint.compatibleWith(version),
            hosted:
                url != null ? HostedDetails(hostedName, Uri.parse(url)) : null,
          );
        } else {
          throw const FormatException('Invalid hosted dependency description');
        }

      case PackageSource.path:
        final path = descriptionYaml is YamlMap
            ? descriptionYaml['path'] as String
            : descriptionYaml as String;
        dependency = PathDependency(path);

      case PackageSource.git:
        if (descriptionYaml is! YamlMap) {
          throw const FormatException(
              'Git dependency must have a map description');
        }
        final url = descriptionYaml['url'] as String;
        final ref = descriptionYaml['ref'] as String?;
        final path = descriptionYaml['path'] as String?;

        dependency = GitDependency(
          Uri.parse(url),
          ref: ref,
          path: path,
        );

      case PackageSource.sdk:
        final sdk = descriptionYaml as String;
        dependency = SdkDependency(
          sdk,
          version: VersionConstraint.compatibleWith(version),
        );
    }

    return LockedPackage(
      name: name,
      dependency: dependency,
      dependencyType: dependencyType,
      version: version,
      sha256: sha256,
      source: source,
    );
  }

  /// Get all packages
  List<LockedPackage> get allPackages => packages.values.toList();

  /// Get direct dependencies (excluding dev dependencies)
  List<LockedPackage> get directDependencies => packages.values
      .where((p) => p.dependencyType == DependencyType.directMain)
      .toList();

  /// Get dev dependencies
  List<LockedPackage> get devDependencies => packages.values
      .where((p) => p.dependencyType == DependencyType.directDev)
      .toList();

  /// Get transitive dependencies
  List<LockedPackage> get transitiveDependencies =>
      packages.values.where((p) => p.isTransitive).toList();

  /// Get a specific package by name
  LockedPackage? getPackage(String name) => packages[name];

  /// Check if a package exists
  bool hasPackage(String name) => packages.containsKey(name);

  /// Get all packages of a specific type
  List<LockedPackage> getPackagesByType(DependencyType type) =>
      packages.values.where((p) => p.dependencyType == type).toList();

  /// Get all packages from a specific source
  List<LockedPackage> getPackagesBySource(PackageSource source) =>
      packages.values.where((p) => p.source == source).toList();

  /// Get all hosted packages
  List<LockedPackage> get hostedPackages =>
      getPackagesBySource(PackageSource.hosted);

  /// Get all path packages
  List<LockedPackage> get pathPackages =>
      getPackagesBySource(PackageSource.path);

  /// Get all git packages
  List<LockedPackage> get gitPackages => getPackagesBySource(PackageSource.git);

  /// Get all SDK packages
  List<LockedPackage> get sdkPackages => getPackagesBySource(PackageSource.sdk);

  /// Get package count by type
  Map<DependencyType, int> get packageCountByType {
    final counts = <DependencyType, int>{};
    for (final type in DependencyType.values) {
      counts[type] = getPackagesByType(type).length;
    }
    return counts;
  }
}
