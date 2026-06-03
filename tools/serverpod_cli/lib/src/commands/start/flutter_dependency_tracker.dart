import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// How the Flutter app's dependency closure changed, ordered by the severity
/// of the response required to pick the change up.
enum FlutterDependencyChange {
  /// No change to the closure; source edits are covered by a hot reload.
  none,

  /// Only pure-Dart dependencies changed; a hot restart picks them up.
  dartOnly,

  /// A dependency with native code changed; only a full process relaunch
  /// rebuilds the native host (a hot restart would leave the new native code
  /// out of the binary, failing at runtime with a MissingPluginException).
  native,
}

/// Tracks the Flutter app's dependency closure so the watcher can escalate to
/// a hot restart or a full relaunch only when its dependencies actually
/// change.
///
/// The closure is derived from `.dart_tool/package_graph.json`, which lists
/// every resolved package with its version and direct dependencies. Starting
/// from the Flutter package and following `dependencies` (not
/// `devDependencies`) yields the app's transitive closure, fingerprinted as
/// `name -> version`.
///
/// Scoping to the closure is what keeps a pub *workspace* from
/// over-triggering: in a workspace the `package_graph.json` is shared across
/// all members, but a change to a server-only dependency leaves the Flutter
/// app's closure untouched, so nothing fires.
///
/// When the closure does change, the added or version-changed packages are
/// classified via their pubspecs (located through `package_config.json`):
/// packages with native code ([FlutterDependencyChange.native]) need a full
/// relaunch, while pure-Dart changes ([FlutterDependencyChange.dartOnly]) only
/// need a hot restart. Unreadable or unlocatable packages are conservatively
/// treated as native, so a classification miss degrades to a
/// slower-but-correct relaunch, never a broken app.
class FlutterDependencyTracker {
  /// The `.dart_tool` directory holding `package_graph.json` for the resolution
  /// the Flutter package belongs to — the workspace root in a workspace layout,
  /// or the package's own `.dart_tool` in a non-workspace project.
  final String dartToolDir;

  /// The package name of the Flutter app, as it appears in `package_graph.json`.
  final String flutterPackageName;

  Map<String, String>? _cachedClosureVersions;

  /// Memoized native-code verdicts, keyed by `name@version`. Pub cache
  /// contents are immutable per version, so entries never invalidate.
  final Map<String, bool> _nativeCache = {};

  FlutterDependencyTracker({
    required this.dartToolDir,
    required this.flutterPackageName,
  }) {
    _cachedClosureVersions = _computeClosureVersions();
  }

  /// Resolves the `.dart_tool` directory whose `package_graph.json` describes
  /// [flutterPackageDir]'s dependency resolution.
  ///
  /// Walks up from [flutterPackageDir] to the nearest ancestor (including
  /// itself) that contains `.dart_tool/package_config.json` — the canonical
  /// marker of a pub resolution root, always written by `pub get` (unlike
  /// `package_graph.json`, which requires a newer SDK). In a workspace this
  /// resolves to the workspace root; in a non-workspace project it resolves to
  /// the package's own directory. Returns `null` if no such directory exists
  /// (e.g. dependencies have not been fetched yet).
  static String? resolveDartToolDir(String flutterPackageDir) {
    var dir = p.absolute(flutterPackageDir);
    while (true) {
      final dartTool = p.join(dir, '.dart_tool');
      if (File(p.join(dartTool, 'package_config.json')).existsSync()) {
        return dartTool;
      }
      final parent = p.dirname(dir);
      if (parent == dir) return null; // Reached the filesystem root.
      dir = parent;
    }
  }

  /// Recomputes the dependency closure, compares it to the cached value, and
  /// classifies the change. Updates the cache.
  ///
  /// A transition to or from an unreadable closure (the graph file missing or
  /// unparseable, e.g. mid-`pub get` or after `flutter clean`) is treated as
  /// [FlutterDependencyChange.none], so a transient state never triggers a
  /// restart — the next valid closure simply reseeds the cache.
  FlutterDependencyChange refresh() {
    final next = _computeClosureVersions();
    final previous = _cachedClosureVersions;
    if (next != null) _cachedClosureVersions = next;
    if (next == null || previous == null) return FlutterDependencyChange.none;
    if (const MapEquality<String, String>().equals(next, previous)) {
      return FlutterDependencyChange.none;
    }

    // Removed packages never force a relaunch — their stale native code in
    // the running binary is harmless. Only added or version-changed packages
    // can introduce native code.
    final delta = next.entries
        .where((entry) => previous[entry.key] != entry.value)
        .toList();
    if (delta.isEmpty) return FlutterDependencyChange.dartOnly;

    final packageRoots = _readPackageRoots() ?? const {};
    final hasNative = delta.any(
      (entry) => _hasNativeCode(entry.key, entry.value, packageRoots),
    );
    return hasNative
        ? FlutterDependencyChange.native
        : FlutterDependencyChange.dartOnly;
  }

  /// Computes the Flutter app's transitive dependency closure as a
  /// `name -> version` map from `package_graph.json`, or `null` if the file
  /// cannot be read/parsed or the Flutter package is absent from the graph.
  Map<String, String>? _computeClosureVersions() {
    final file = File(p.join(dartToolDir, 'package_graph.json'));
    if (!file.existsSync()) return null;

    final Object? decoded;
    try {
      decoded = jsonDecode(file.readAsStringSync());
    } on FormatException {
      return null;
    } on IOException {
      return null;
    }
    if (decoded is! Map<String, dynamic>) return null;

    final packages = decoded['packages'];
    if (packages is! List) return null;

    final byName = <String, Map<String, dynamic>>{};
    for (final pkg in packages) {
      if (pkg is Map<String, dynamic> && pkg['name'] is String) {
        byName[pkg['name'] as String] = pkg;
      }
    }
    if (!byName.containsKey(flutterPackageName)) return null;

    // Collect the transitive closure by following `dependencies` only;
    // `devDependencies` don't affect the running app, so they are skipped to
    // avoid restarting on test/lint dependency changes.
    final closure = <String>{};
    final stack = <String>[flutterPackageName];
    while (stack.isNotEmpty) {
      final name = stack.removeLast();
      if (!closure.add(name)) continue;
      final deps = byName[name]?['dependencies'];
      if (deps is List) {
        for (final dep in deps) {
          if (dep is String && !closure.contains(dep)) stack.add(dep);
        }
      }
    }

    return {
      for (final name in closure) name: '${byName[name]?['version'] ?? ''}',
    };
  }

  /// Maps each resolved package to its root directory via
  /// `package_config.json`, or `null` if the file cannot be read. Relative
  /// `rootUri`s are resolved against the file's own location, per spec.
  Map<String, String>? _readPackageRoots() {
    final file = File(p.join(dartToolDir, 'package_config.json'));
    if (!file.existsSync()) return null;

    final Object? decoded;
    try {
      decoded = jsonDecode(file.readAsStringSync());
    } on FormatException {
      return null;
    } on IOException {
      return null;
    }
    if (decoded is! Map<String, dynamic>) return null;

    final packages = decoded['packages'];
    if (packages is! List) return null;

    final baseUri = file.absolute.uri;
    final roots = <String, String>{};
    for (final pkg in packages) {
      if (pkg is! Map<String, dynamic>) continue;
      final name = pkg['name'];
      final rootUri = pkg['rootUri'];
      if (name is! String || rootUri is! String) continue;
      try {
        roots[name] = p.fromUri(baseUri.resolve(rootUri));
      } on FormatException {
        continue;
      }
    }
    return roots;
  }

  /// Whether the package ships native code that a hot restart cannot pick up:
  /// a classic plugin platform implementation (`pluginClass` in a compiled
  /// host language, or `ffiPlugin`) or a native-assets build hook.
  /// `dartPluginClass`-only platforms and the `pluginClass: none` convention
  /// are pure Dart. Conservatively returns `true` when the package cannot be
  /// located or its pubspec cannot be read.
  bool _hasNativeCode(
    String name,
    String version,
    Map<String, String> packageRoots,
  ) {
    return _nativeCache.putIfAbsent('$name@$version', () {
      final root = packageRoots[name];
      if (root == null) return true;

      final Object? pubspec;
      try {
        pubspec = loadYaml(
          File(p.join(root, 'pubspec.yaml')).readAsStringSync(),
        );
      } on IOException {
        return true;
      } on YamlException {
        return true;
      }
      if (pubspec is! YamlMap) return true;

      final platforms = _lookup(pubspec, ['flutter', 'plugin', 'platforms']);
      if (platforms is! YamlMap) {
        // Not a classic plugin. Packages using the native-assets mechanism
        // compile native code through a build hook instead.
        return File(p.join(root, 'hook', 'build.dart')).existsSync();
      }
      return platforms.values.any((platform) {
        if (platform is! YamlMap) return false;
        final pluginClass = platform['pluginClass'];
        return (pluginClass != null && pluginClass != 'none') ||
            platform['ffiPlugin'] == true;
      });
    });
  }

  static Object? _lookup(YamlMap map, List<String> path) {
    Object? node = map;
    for (final key in path) {
      if (node is! YamlMap) return null;
      node = node[key];
    }
    return node;
  }
}
