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
  static const _syncTablesKey = 'sync_tables';

  /// The list of shared packages that the owner package exports.
  final List<String> sharedPackages;

  /// Whether the owner package exports a generated sync tables list for the
  /// `serverpod_offline_sync` package.
  final bool syncTables;

  /// Creates a new Serverpod manifest.
  ///
  /// [sharedPackages] is the list of shared packages that the owner package
  /// exports.
  ServerpodManifest({
    required Iterable<String> sharedPackages,
    this.syncTables = false,
  }) : sharedPackages = List.unmodifiable(sharedPackages);

  /// Whether the manifest is empty.
  ///
  /// Empty manifests are not written to the file system.
  bool get isEmpty => sharedPackages.isEmpty && !syncTables;

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

    var syncTables = document[_syncTablesKey];
    if (syncTables is! bool?) {
      throw ServerpodManifestException(
        'Invalid Serverpod manifest at ${file.path}: '
        '$_syncTablesKey must be a boolean.',
      );
    }

    var sharedPackages = document[_sharedPackagesKey];
    if (sharedPackages == null) {
      return ServerpodManifest(
        sharedPackages: const [],
        syncTables: syncTables ?? false,
      );
    }
    if (sharedPackages is! List ||
        sharedPackages.any((packageName) => packageName is! String)) {
      throw ServerpodManifestException(
        'Invalid Serverpod manifest at ${file.path}: '
        '$_sharedPackagesKey must be a list of strings.',
      );
    }

    return ServerpodManifest(
      sharedPackages: sharedPackages.cast<String>(),
      syncTables: syncTables ?? false,
    );
  }

  /// Converts the manifest to a YAML string.
  String toYaml() {
    var out = '$_versionKey: $currentVersion\n';
    if (sharedPackages.isEmpty) {
      out += '$_sharedPackagesKey: []\n';
    } else {
      out += '$_sharedPackagesKey:\n';
      for (var packageName in sharedPackages) {
        out += '  - $packageName\n';
      }
    }
    if (syncTables) {
      out += '$_syncTablesKey: true\n';
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
