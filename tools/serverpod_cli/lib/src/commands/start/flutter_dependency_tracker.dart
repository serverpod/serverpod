import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/package_dependency_tracker.dart';
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

  /// Assets or fonts declared in `pubspec.yaml` changed. These are bundled at
  /// build time so only a full process relaunch picks them up.
  assets,
}

/// A [PackageDependencyTracker] for a companion Flutter app, adding the
/// asset/font fingerprint on top of the shared dependency-closure tracking.
///
/// Beyond the closure (native vs. pure-Dart) classification inherited from the
/// base, a change to the `flutter.assets` or `flutter.fonts` sections of the
/// app's `pubspec.yaml` maps to [FlutterDependencyChange.assets]: those are
/// bundled at build time, so only a full process relaunch picks them up.
class FlutterDependencyTracker extends PackageDependencyTracker {
  /// The package directory of the Flutter app, whose `pubspec.yaml` is read
  /// to fingerprint assets and fonts so their changes trigger a full relaunch.
  final String flutterPackageDir;

  /// Cached fingerprint of the Flutter app's `pubspec.yaml` assets and
  /// fonts sections. `null` when the file could not be read or when
  /// the sections are missing from the pubspec.
  String? _cachedAssetFingerprint;

  FlutterDependencyTracker({
    required super.dartToolDir,
    required String flutterPackageName,
    required this.flutterPackageDir,
  }) : super(packageName: flutterPackageName) {
    _cachedAssetFingerprint = _computeAssetFingerprint();
  }

  /// The package name of the Flutter app, as it appears in
  /// `package_graph.json`.
  String get flutterPackageName => packageName;

  /// Recomputes the asset/font fingerprint and the dependency closure, compares
  /// them to the cached values, and classifies the change. Updates the caches.
  ///
  /// Assets and fonts are checked first: they are bundled at build time so they
  /// always need a full relaunch, regardless of whether the dependency closure
  /// also changed.
  FlutterDependencyChange refresh() {
    final nextFingerprint = _computeAssetFingerprint();
    final previousFingerprint = _cachedAssetFingerprint;
    _cachedAssetFingerprint = nextFingerprint;
    if (nextFingerprint != previousFingerprint) {
      return FlutterDependencyChange.assets;
    }

    return switch (refreshClosure()) {
      PackageDependencyChange.none => FlutterDependencyChange.none,
      PackageDependencyChange.dartOnly => FlutterDependencyChange.dartOnly,
      PackageDependencyChange.native => FlutterDependencyChange.native,
    };
  }

  /// Reads the Flutter app's `pubspec.yaml` and produces a fingerprint
  /// of the `flutter.assets` and `flutter.fonts` sections.
  /// Returns `null` when the file cannot be read or parsed,
  /// or when those sections are not found in the pubspec.
  String? _computeAssetFingerprint() {
    final file = File(p.join(flutterPackageDir, 'pubspec.yaml'));
    if (!file.existsSync()) return null;

    final Object? pubspec;
    try {
      pubspec = loadYaml(file.readAsStringSync());
    } catch (_) {
      return null;
    }
    if (pubspec is! YamlMap) return null;

    final flutter = PackageDependencyTracker.lookupYaml(pubspec, ['flutter']);
    if (flutter is! YamlMap) return null;

    final buffer = StringBuffer();

    final assets = flutter['assets'];
    if (assets is YamlList) {
      buffer.writeln('${assets.value}');
    }

    final fonts = flutter['fonts'];
    if (fonts is YamlList) {
      buffer.writeln('${fonts.value}');
    }

    return buffer.toString();
  }
}
