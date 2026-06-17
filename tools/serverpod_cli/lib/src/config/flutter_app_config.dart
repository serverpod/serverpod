import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

/// One configured companion Flutter app.
///
/// Configured under the `serverpod: flutter_apps:` map in the server's
/// `pubspec.yaml`, keyed by alias. Reserved properties (`path`, `auto_launch`,
/// `device`) are interpreted directly; any other property is forwarded to
/// `flutter run` via [extraRunArgs].
class FlutterAppConfig {
  /// Creates a [FlutterAppConfig].
  const FlutterAppConfig({
    required this.id,
    required this.name,
    required this.relativePathParts,
    required this.serverPackageDirectoryPathParts,
    this.autoLaunch = false,
    this.device,
    this.extraRunArgs = const [],
  });

  /// Stable slug derived from [name] or the last path segment.
  final String id;

  /// Display name used for tab labels and breadcrumbs.
  final String name;

  /// Whether `serverpod start` launches this app automatically on startup
  /// (the `auto_launch` property). Apps with this false can still be launched
  /// on demand from the start TUI with Ctrl+R.
  final bool autoLaunch;

  /// Target device for `flutter run -d` (the `device` property), or `null` to
  /// fall back to the default device when the app is launched.
  final String? device;

  /// Extra arguments forwarded verbatim to `flutter run`, derived from any
  /// non-reserved properties on the app's entry — e.g. `target: lib/main.dart`
  /// becomes `--target=lib/main.dart`. The reserved keys (`path`,
  /// `auto_launch`, `device`) are excluded.
  final List<String> extraRunArgs;

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
/// keyed by app alias, each entry a map of properties. The reserved properties
/// (`path`, `auto_launch`, `device`) are interpreted directly; every other
/// property is forwarded to `flutter run` (see [_flutterRunArgsFromProps]).
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

    final autoLaunchNode = propsNode.nodes['auto_launch'];
    final autoLaunchValue = autoLaunchNode?.value;
    if (autoLaunchValue != null && autoLaunchValue is! bool) {
      throw SourceSpanFormatException(
        'The "$alias" flutter app "auto_launch" property must be a boolean.',
        autoLaunchNode!.span,
      );
    }

    final deviceNode = propsNode.nodes['device'];
    final deviceValue = deviceNode?.value;
    if (deviceValue != null &&
        (deviceValue is! String || deviceValue.isEmpty)) {
      throw SourceSpanFormatException(
        'The "$alias" flutter app "device" property must be a non-empty string.',
        deviceNode!.span,
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
        autoLaunch: autoLaunchValue ?? false,
        device: deviceValue as String?,
        extraRunArgs: _flutterRunArgsFromProps(propsNode, alias),
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
    autoLaunch: true,
  );

  if (!app.hasPackage) {
    return [];
  }

  return [app];
}

/// Properties the parser interprets itself; every other key under an app's
/// entry is forwarded to `flutter run`.
const _reservedFlutterAppKeys = {'path', 'auto_launch', 'device'};

/// Builds `flutter run` arguments from the non-reserved properties of
/// [propsNode], preserving the order they appear in the pubspec.
List<String> _flutterRunArgsFromProps(YamlMap propsNode, String alias) {
  final args = <String>[];
  for (final keyNode in propsNode.nodes.keys) {
    final key = (keyNode as YamlNode).value;
    if (key is! String || _reservedFlutterAppKeys.contains(key)) continue;
    args.addAll(_flutterRunArg(key, propsNode.nodes[keyNode]!, alias));
  }
  return args;
}

/// Converts one `key: value` property into `flutter run` arguments:
/// `target: lib/main.dart` -> `--target=lib/main.dart`; `release: true` ->
/// `--release`; `release: false` -> `--no-release`; a list value repeats the
/// flag once per item (e.g. `dart-define: [A=1, B=2]`); a map value does the
/// same by joining each entry as `entryKey=entryValue` (e.g.
/// `dart-define: {A: 1, B: 2}`).
List<String> _flutterRunArg(String key, YamlNode valueNode, String alias) {
  if (valueNode is YamlScalar) {
    final value = valueNode.value;
    return switch (value) {
      null => ['--$key'],
      bool() => [value ? '--$key' : '--no-$key'],
      _ => ['--$key=$value'],
    };
  }

  if (valueNode is YamlList) {
    final args = <String>[];
    for (final itemNode in valueNode.nodes) {
      args.add('--$key=${_flutterRunCollectionItem(itemNode, key, alias)}');
    }
    return args;
  }

  if (valueNode is YamlMap) {
    final args = <String>[];
    for (final entryKeyNode in valueNode.nodes.keys) {
      final entryKey = (entryKeyNode as YamlNode).value;
      if (entryKey is! String && entryKey is! num) {
        throw SourceSpanFormatException(
          'The "$alias" flutter app option "$key" map keys must be strings '
          'or numbers.',
          entryKeyNode.span,
        );
      }
      final entryValueNode = valueNode.nodes[entryKeyNode]!;
      final entryValue = _flutterRunCollectionItem(entryValueNode, key, alias);
      args.add('--$key=$entryKey=$entryValue');
    }
    return args;
  }

  throw SourceSpanFormatException(
    'The "$alias" flutter app option "$key" must be a string, number, '
    'boolean, list, or map of strings or numbers.',
    valueNode.span,
  );
}

Object _flutterRunCollectionItem(YamlNode itemNode, String key, String alias) {
  final item = itemNode is YamlScalar ? itemNode.value : null;
  if (item is! String && item is! num) {
    throw SourceSpanFormatException(
      'The "$alias" flutter app option "$key" must contain only strings '
      'or numbers.',
      itemNode.span,
    );
  }
  return item;
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
