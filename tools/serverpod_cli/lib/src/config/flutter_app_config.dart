import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

/// One configured companion Flutter app.
///
/// The map shape in `generator.yaml` leaves room for per-app options (e.g.
/// `device`) without a schema break.
class FlutterAppConfig {
  /// Creates a [FlutterAppConfig].
  const FlutterAppConfig({
    required this.id,
    required this.name,
    required this.relativePathParts,
    required this.serverPackageDirectoryPathParts,
  });

  /// Stable slug derived from [name] or the last path segment.
  final String id;

  /// Display name used for tab labels and breadcrumbs.
  final String name;

  /// Path parts relative to the server package directory.
  final List<String> relativePathParts;

  /// Absolute path parts of the server package directory at load time.
  final List<String> serverPackageDirectoryPathParts;

  /// Absolute path parts to the Flutter package directory.
  List<String> get pathParts => [
    ...serverPackageDirectoryPathParts,
    ...relativePathParts,
  ];

  /// True when [pathParts] is a directory containing `pubspec.yaml`.
  bool get hasPackage {
    final dirPath = p.joinAll(pathParts);
    if (!Directory(dirPath).existsSync()) return false;
    return File(p.join(dirPath, 'pubspec.yaml')).existsSync();
  }
}

/// Parses `flutter_apps` from generator config, or synthesizes the default.
List<FlutterAppConfig> loadFlutterApps({
  required YamlMap generatorConfig,
  required List<String> serverPackageDirectoryPathParts,
  required String projectName,
}) {
  final flutterAppsNode = generatorConfig.nodes['flutter_apps'];
  if (flutterAppsNode == null) {
    return _synthesizeDefaultFlutterApps(
      serverPackageDirectoryPathParts: serverPackageDirectoryPathParts,
      projectName: projectName,
    );
  }

  final flutterAppsValue = flutterAppsNode.value;
  if (flutterAppsValue is! YamlList) {
    throw SourceSpanFormatException(
      'The "flutter_apps" property must be a list of app entries.',
      flutterAppsNode.span,
    );
  }

  final usedIds = <String>{};
  final apps = <FlutterAppConfig>[];

  for (final entry in flutterAppsValue) {
    if (entry is! YamlMap) {
      throw SourceSpanFormatException(
        'Each "flutter_apps" entry must be a map with "name" and "path".',
        flutterAppsValue.span,
      );
    }

    final pathNode = entry.nodes['path'];
    final pathValue = pathNode?.value;
    if (pathValue is! String || pathValue.isEmpty) {
      throw SourceSpanFormatException(
        'Each "flutter_apps" entry must include a non-empty "path".',
        pathNode?.span ?? entry.span,
      );
    }

    final nameNode = entry.nodes['name'];
    final nameValue = nameNode?.value;
    final name = nameValue is String && nameValue.isNotEmpty
        ? nameValue
        : p.basename(pathValue);

    final relativePathParts = p.split(pathValue);
    final id = _uniqueId(
      _slugFromName(name, relativePathParts),
      usedIds,
    );

    apps.add(
      FlutterAppConfig(
        id: id,
        name: name,
        relativePathParts: relativePathParts,
        serverPackageDirectoryPathParts: serverPackageDirectoryPathParts,
      ),
    );
  }

  return apps;
}

List<FlutterAppConfig> _synthesizeDefaultFlutterApps({
  required List<String> serverPackageDirectoryPathParts,
  required String projectName,
}) {
  final relativePathParts = ['..', '${projectName}_flutter'];
  final app = FlutterAppConfig(
    id: _slugFromName(projectName, relativePathParts),
    name: projectName,
    relativePathParts: relativePathParts,
    serverPackageDirectoryPathParts: serverPackageDirectoryPathParts,
  );

  if (!app.hasPackage) {
    return [];
  }

  return [app];
}

String _slugFromName(String name, List<String> relativePathParts) {
  final source = name.trim().isNotEmpty ? name.trim() : relativePathParts.last;
  final slug = source
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return slug.isNotEmpty ? slug : 'app';
}

String _uniqueId(String baseId, Set<String> usedIds) {
  var candidate = baseId;
  var suffix = 2;
  while (usedIds.contains(candidate)) {
    candidate = '$baseId-$suffix';
    suffix++;
  }
  usedIds.add(candidate);
  return candidate;
}
