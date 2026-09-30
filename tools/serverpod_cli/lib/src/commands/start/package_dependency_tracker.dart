import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// How a package's resolved dependency closure changed, ordered by the severity
/// of the response required to pick the change up. [assets] is the one
/// exception - a Flutter build-input change rather than a dependency change -
/// folded in so the watcher classifies every change kind with a single type.
enum PackageDependencyChange {
  /// No change to the closure.
  none,

  /// Only pure-Dart dependencies changed.
  dartOnly,

  /// A dependency with native code changed.
  native,

  /// A Flutter app's bundled assets or fonts changed (the `flutter.assets` /
  /// `flutter.fonts` sections of its `pubspec.yaml`). Not a dependency-closure
  /// change, but it shares this enum so a single type covers every reason a
  /// watched app may need to react; only the Flutter app tracker emits it, and
  /// [refreshClosure] never returns it.
  assets,
}

/// Tracks a package's transitive dependency closure so a watcher can react only
/// when *that package's* dependencies actually change - and classify the change
/// as pure-Dart vs. native.
///
/// The closure is derived from `.dart_tool/package_graph.json`, which lists
/// every resolved package with its version and direct dependencies. Starting
/// from [packageName] and following `dependencies` (not `devDependencies`)
/// yields the transitive closure, fingerprinted as `name -> version`.
///
/// Scoping to the closure is what keeps a pub *workspace* from over-triggering:
/// in a workspace the `package_graph.json` is shared across all members, but a
/// change to a dependency outside this package's closure leaves the fingerprint
/// untouched, so nothing fires.
///
/// When the closure does change, the added or version-changed packages are
/// classified via their pubspecs (located through `package_config.json`):
/// packages with native code ([PackageDependencyChange.native]) need the
/// heaviest response, while pure-Dart changes
/// ([PackageDependencyChange.dartOnly]) are lighter. Unreadable or unlocatable
/// packages are conservatively treated as native, so a classification miss
/// degrades to the slower-but-correct response.
class PackageDependencyTracker {
  /// The `.dart_tool` directory holding `package_graph.json` for the resolution
  /// [packageName] belongs to - the workspace root in a workspace layout, or the
  /// package's own `.dart_tool` in a non-workspace project.
  final String dartToolDir;

  /// The package name whose closure is tracked, as it appears in
  /// `package_graph.json`.
  final String packageName;

  Map<String, String>? _cachedClosureVersions;

  /// Memoized native-code verdicts, keyed by `name@version`. Pub cache
  /// contents are immutable per version, so entries never invalidate.
  final Map<String, bool> _nativeCache = {};

  PackageDependencyTracker({
    required this.dartToolDir,
    required this.packageName,
  }) {
    _cachedClosureVersions = _computeClosureVersions();
  }

  /// Resolves the `.dart_tool` directory whose `package_graph.json` describes
  /// [packageDir]'s dependency resolution: the nearest ancestor (including
  /// itself) with a `.dart_tool/package_config.json` - the workspace root in a
  /// workspace, the package's own directory otherwise. Returns `null` if there
  /// is none (e.g. dependencies have not been fetched yet) or if the one found
  /// does not list [packageName].
  static String? resolveDartToolDir(
    String packageDir, {
    required String packageName,
  }) {
    var dir = p.absolute(packageDir);
    while (true) {
      final dartTool = p.join(dir, '.dart_tool');
      if (File(p.join(dartTool, 'package_config.json')).existsSync()) {
        // The nearest resolution root must list the package. An unrelated
        // resolution (e.g. found after the package's own .dart_tool was
        // deleted) disables tracking rather than risking a wrong root
        // further up that merely contains a same-named package.
        return _packageConfigContains(dartTool, packageName) ? dartTool : null;
      }
      final parent = p.dirname(dir);
      if (parent == dir) return null; // Reached the filesystem root.
      dir = parent;
    }
  }

  /// Whether `<dartTool>/package_config.json` parses and lists a package
  /// named [packageName]. Unreadable or malformed files count as a non-match.
  static bool _packageConfigContains(String dartTool, String packageName) {
    final file = File(p.join(dartTool, 'package_config.json'));
    if (!file.existsSync()) return false;

    final Object? decoded;
    try {
      decoded = jsonDecode(file.readAsStringSync());
    } on FormatException {
      return false;
    } on IOException {
      return false;
    }
    if (decoded is! Map<String, dynamic>) return false;

    final packages = decoded['packages'];
    if (packages is! List) return false;
    return packages.any(
      (pkg) => pkg is Map<String, dynamic> && pkg['name'] == packageName,
    );
  }

  /// Recomputes the dependency closure, compares it to the cached value, and
  /// classifies the change. Updates the cache.
  ///
  /// A transition to or from an unreadable closure (the graph file missing or
  /// unparseable, e.g. mid-`pub get` or after `flutter clean`) is treated as
  /// [PackageDependencyChange.none], so a transient state never triggers a
  /// response - the next valid closure simply reseeds the cache.
  PackageDependencyChange refreshClosure() {
    final next = _computeClosureVersions();
    final previous = _cachedClosureVersions;
    if (next != null) _cachedClosureVersions = next;
    if (next == null || previous == null) return PackageDependencyChange.none;
    if (const MapEquality<String, String>().equals(next, previous)) {
      return PackageDependencyChange.none;
    }

    // Removed packages never force the native response - their stale native
    // code in a running binary is harmless. Only added or version-changed
    // packages can introduce native code.
    final delta = next.entries
        .where((entry) => previous[entry.key] != entry.value)
        .toList();
    if (delta.isEmpty) return PackageDependencyChange.dartOnly;

    final packageRoots = _readPackageRoots() ?? const {};
    final hasNative = delta.any(
      (entry) => _hasNativeCode(entry.key, entry.value, packageRoots),
    );
    return hasNative
        ? PackageDependencyChange.native
        : PackageDependencyChange.dartOnly;
  }

  /// Computes [packageName]'s transitive dependency closure as a
  /// `name -> version` map from `package_graph.json`, or `null` if the file
  /// cannot be read/parsed or [packageName] is absent from the graph.
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
    if (!byName.containsKey(packageName)) return null;

    // Collect the transitive closure by following `dependencies` only;
    // `devDependencies` don't affect the running app/pod, so they are skipped to
    // avoid reacting to test/lint dependency changes.
    final closure = <String>{};
    final stack = <String>[packageName];
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

  /// Whether the package ships native code that an in-process reload cannot pick
  /// up: a classic plugin platform implementation (`pluginClass` in a compiled
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

      final platforms = lookupYaml(pubspec, ['flutter', 'plugin', 'platforms']);
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

  /// Walks [path] keys through nested [YamlMap]s, returning the value at the end
  /// or `null` if any segment is missing or not a map. Shared with subclasses
  /// that inspect other pubspec sections.
  static Object? lookupYaml(YamlMap map, List<String> path) {
    Object? node = map;
    for (final key in path) {
      if (node is! YamlMap) return null;
      node = node[key];
    }
    return node;
  }
}
