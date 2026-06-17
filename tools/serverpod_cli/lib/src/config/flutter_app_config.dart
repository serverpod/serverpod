import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

/// One configured companion Flutter app.
///
/// Configured under the `serverpod: flutter_apps:` map in the server's
/// `pubspec.yaml`, keyed by alias. The per-app property map leaves room for
/// future options (e.g. `device`) without a schema break.
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

/// Parses the `serverpod: flutter_apps:` map from the server pubspec, or
/// synthesizes the default sibling app when it is absent.
///
/// [flutterAppsNode] is the value node of `serverpod/flutter_apps` from the
/// server `pubspec.yaml`, or `null` when the key is not present. The map is
/// keyed by app alias, each entry a map of properties (currently `path`).
List<FlutterAppConfig> loadFlutterApps({
  required YamlNode? flutterAppsNode,
  required List<String> serverPackageDirectoryPathParts,
  required String projectName,
}) {
  if (flutterAppsNode == null) {
    return _synthesizeDefaultFlutterApps(
      serverPackageDirectoryPathParts: serverPackageDirectoryPathParts,
      projectName: projectName,
    );
  }

  if (flutterAppsNode is! YamlMap) {
    throw SourceSpanFormatException(
      'The "serverpod: flutter_apps" property must be a map of app alias to '
      'app properties.',
      flutterAppsNode.span,
    );
  }

  final usedIds = <String>{};
  final apps = <FlutterAppConfig>[];

  for (final aliasNode in flutterAppsNode.nodes.keys) {
    final alias = (aliasNode as YamlNode).value;
    final propsNode = flutterAppsNode.nodes[aliasNode]!;

    if (alias is! String || alias.isEmpty) {
      throw SourceSpanFormatException(
        'Each "flutter_apps" key must be a non-empty app alias.',
        aliasNode.span,
      );
    }

    if (propsNode is! YamlMap) {
      throw SourceSpanFormatException(
        'The "$alias" flutter app must be a map of properties (e.g. `path`).',
        propsNode.span,
      );
    }

    final pathNode = propsNode.nodes['path'];
    final pathValue = pathNode?.value;
    if (pathValue is! String || pathValue.isEmpty) {
      throw SourceSpanFormatException(
        'The "$alias" flutter app must include a non-empty "path".',
        pathNode?.span ?? propsNode.span,
      );
    }

    final relativePathParts = p.split(pathValue);
    final id = _uniqueId(_slugFromName(alias, relativePathParts), usedIds);

    apps.add(
      FlutterAppConfig(
        id: id,
        name: alias,
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
