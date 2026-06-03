import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// Tracks the Flutter app's dependency closure so the watcher can fully
/// relaunch the app only when its dependencies actually change.
///
/// The fingerprint is derived from `.dart_tool/package_graph.json`, which lists
/// every resolved package with its version and direct dependencies. Starting
/// from the Flutter package and following `dependencies` (not
/// `devDependencies`) yields the app's transitive closure; the closure's
/// `name@version` pairs form the fingerprint.
///
/// Scoping to the closure is what keeps a pub *workspace* from over-triggering:
/// in a workspace the `package_graph.json` is shared across all members, but a
/// change to a server-only dependency leaves the Flutter app's closure
/// untouched, so no relaunch fires.
class FlutterDependencyTracker {
  /// The `.dart_tool` directory holding `package_graph.json` for the resolution
  /// the Flutter package belongs to — the workspace root in a workspace layout,
  /// or the package's own `.dart_tool` in a non-workspace project.
  final String dartToolDir;

  /// The package name of the Flutter app, as it appears in `package_graph.json`.
  final String flutterPackageName;

  String? _cachedFingerprint;

  FlutterDependencyTracker({
    required this.dartToolDir,
    required this.flutterPackageName,
  }) {
    _cachedFingerprint = computeFingerprint();
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

  /// Recomputes the fingerprint, compares it to the cached value, and updates
  /// the cache. Returns `true` only when the closure changed between two
  /// successfully computed fingerprints.
  ///
  /// A transition to or from `null` (the graph file missing or unparseable,
  /// e.g. mid-`pub get` or after `flutter clean`) is treated as "no change", so
  /// a transient state never triggers a relaunch — the next valid fingerprint
  /// simply reseeds the cache.
  bool refreshIfChanged() {
    final next = computeFingerprint();
    final previous = _cachedFingerprint;
    if (next != null) _cachedFingerprint = next;
    if (next == null || previous == null) return false;
    return next != previous;
  }

  /// Computes a fingerprint of the Flutter app's transitive dependency closure
  /// from `package_graph.json`, or `null` if the file cannot be read/parsed or
  /// the Flutter package is absent from the graph.
  String? computeFingerprint() {
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
    // avoid relaunching on test/lint dependency changes.
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

    // Canonical, order-independent fingerprint: sorted `name@version` pairs.
    final entries = closure.map((name) {
      final version = byName[name]?['version'];
      return '$name@${version ?? ''}';
    }).toList()..sort();
    return entries.join(';');
  }
}
