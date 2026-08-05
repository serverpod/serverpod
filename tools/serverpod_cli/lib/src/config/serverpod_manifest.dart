import 'dart:io';

import 'package:yaml/yaml.dart';

/// Manifest file for the Serverpod package.
///
/// Stores metadata generated together with the models and endpoints, like the
/// list of shared packages that modules export. Only written to the file system
/// if there is data to write.
final class ServerpodManifest {
  static const fileName = 'manifest.yaml';
  static const currentVersion = 1;

  static const _versionKey = 'version';
  static const _sharedPackagesKey = 'shared_packages';

  /// The list of shared packages that the owner package exports.
  final List<String> sharedPackages;

  /// Creates a new Serverpod manifest.
  ///
  /// [sharedPackages] is the list of shared packages that the owner package
  /// exports.
  ServerpodManifest({required Iterable<String> sharedPackages})
    : sharedPackages = List.unmodifiable(sharedPackages);

  /// Whether the manifest is empty.
  ///
  /// Empty manifests are not written to the file system.
  bool get isEmpty => sharedPackages.isEmpty;

  /// Tries to load a Serverpod manifest from a file.
  ///
  /// Returns `null` if the file does not exist.
  static ServerpodManifest? tryLoadSync(File file) {
    if (!file.existsSync()) return null;

    dynamic document;
    try {
      document = loadYaml(file.readAsStringSync(), sourceUrl: file.uri);
    } catch (error) {
      throw ServerpodManifestException(
        'Failed to read Serverpod manifest at ${file.path}: $error',
      );
    }

    if (document is! Map) {
      throw ServerpodManifestException(
        'Invalid Serverpod manifest at ${file.path}: expected a map.',
      );
    }

    var version = document[_versionKey];
    if (version is! int) {
      throw ServerpodManifestException(
        'Invalid Serverpod manifest at ${file.path}: '
        '$_versionKey must be an integer.',
      );
    }
    if (version != currentVersion) {
      throw ServerpodManifestException(
        'Unsupported Serverpod manifest version $version at ${file.path}. '
        'Expected version $currentVersion.',
      );
    }

    var sharedPackages = document[_sharedPackagesKey];
    if (sharedPackages == null) {
      return ServerpodManifest(sharedPackages: const []);
    }
    if (sharedPackages is! List ||
        sharedPackages.any((packageName) => packageName is! String)) {
      throw ServerpodManifestException(
        'Invalid Serverpod manifest at ${file.path}: '
        '$_sharedPackagesKey must be a list of strings.',
      );
    }

    return ServerpodManifest(sharedPackages: sharedPackages.cast<String>());
  }

  /// Converts the manifest to a YAML string.
  String toYaml() {
    var out = '$_versionKey: $currentVersion\n';
    if (sharedPackages.isEmpty) {
      return '$out$_sharedPackagesKey: []\n';
    }

    out += '$_sharedPackagesKey:\n';
    for (var packageName in sharedPackages) {
      out += '  - $packageName\n';
    }
    return out;
  }
}

/// Exception thrown when a Serverpod manifest is invalid.
final class ServerpodManifestException implements Exception {
  final String message;

  const ServerpodManifestException(this.message);

  @override
  String toString() => message;
}
