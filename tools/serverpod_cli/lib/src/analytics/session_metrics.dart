import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config/flutter_app_config.dart';

/// Whether `--docker` was explicitly set on `serverpod start`.
///
/// The flag is tri-state: unset means `start` decides from the project setup
/// (Docker Compose file plus a PostgreSQL database without a `dataPath`).
enum DockerStartMode { on, off, auto }

/// Coarse buckets for a configured Flutter target device.
///
/// Answers "is this a browser, a phone, or a desktop app". See
/// [flutterDevicePlatforms] for the finer split.
const flutterDeviceCategories = {
  'web',
  'mobile',
  'desktop',
  'headless',
  'default',
  'other',
};

/// Canonical target platforms for a configured Flutter device.
///
/// Finer than [flutterDeviceCategories] so the share of each target is
/// visible — which platforms people actually build for is the interesting
/// question, and `mobile` alone cannot answer it.
///
/// Device ids are user-controlled strings (the `device:` property of an entry
/// under `serverpod: flutter_apps:` in the server pubspec), so a raw id is
/// never sent — only the bucket it maps to.
const flutterDevicePlatforms = {
  'ios',
  'ipad',
  'android',
  'macos',
  'windows',
  'linux',
  'chrome',
  'edge',
  'web-server',
  'default',
  'other',
};

/// A configured device resolved into the two buckets that get reported.
class FlutterDeviceBuckets {
  const FlutterDeviceBuckets({required this.category, required this.platform});

  final String category;
  final String platform;
}

/// Companion Flutter app setup for a `serverpod start` session.
///
/// Apps moved from `--flutter-*` command line flags to the
/// `serverpod: flutter_apps:` section of the server pubspec, and a project can
/// now configure several of them, so the session event reports the shape of
/// that configuration rather than a single device.
///
/// Configuration is not usage: an app declared in the pubspec but never
/// launched must not weigh as much as one launched every session. `cli.flutter_
/// launch` carries the usage side.
class FlutterAppMetrics {
  const FlutterAppMetrics({
    required this.appCount,
    required this.autoLaunchCount,
    required this.deviceCategories,
    required this.devicePlatforms,
  });

  const FlutterAppMetrics.none()
    : appCount = 0,
      autoLaunchCount = 0,
      deviceCategories = const [],
      devicePlatforms = const [];

  final int appCount;
  final int autoLaunchCount;

  /// Sorted, de-duplicated [flutterDeviceCategories] across all configured apps.
  final List<String> deviceCategories;

  /// Sorted, de-duplicated [flutterDevicePlatforms] across all configured apps.
  final List<String> devicePlatforms;

  static FlutterAppMetrics load(GeneratorConfig config) {
    try {
      final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);
      final apps = loadFlutterApps(
        serverPubspecFile: File(p.join(serverDir, 'pubspec.yaml')),
        serverPackageDirectoryPathParts: config.serverPackageDirectoryPathParts,
        projectName: config.name,
      );

      final buckets = apps.map((app) => categorizeFlutterDevice(app.device));

      return FlutterAppMetrics(
        appCount: apps.length,
        autoLaunchCount: apps.where((app) => app.autoLaunch).length,
        deviceCategories:
            buckets.map((bucket) => bucket.category).toSet().toList()..sort(),
        devicePlatforms:
            buckets.map((bucket) => bucket.platform).toSet().toList()..sort(),
      );
    } catch (_) {
      // A malformed or absent flutter_apps section must not cost the event.
      return const FlutterAppMetrics.none();
    }
  }
}

/// Maps a `flutter run -d` device id onto its analytics buckets.
///
/// A `null` device means the app did not pin one and `start` picks the default.
FlutterDeviceBuckets categorizeFlutterDevice(String? device) {
  if (device == null) {
    return const FlutterDeviceBuckets(
      category: 'default',
      platform: 'default',
    );
  }

  final id = device.toLowerCase();
  final platform = _platformOf(id);

  return FlutterDeviceBuckets(
    category: _categoryOf(id, platform),
    platform: platform,
  );
}

String _platformOf(String id) {
  // Ordered most specific first: an iPad id also matches `ios`, and a
  // `web-server` id also matches `web`.
  if (id.contains('ipad')) return 'ipad';
  if (RegExp(r'\bios\b|iphone|ios-simulator|apple ?ios').hasMatch(id)) {
    return 'ios';
  }
  if (id.contains('android') || id.contains('emulator')) return 'android';
  if (id.contains('macos') || id.contains('darwin')) return 'macos';
  if (id.contains('windows')) return 'windows';
  if (id.contains('linux')) return 'linux';
  if (id.contains('web-server') || id.contains('web_server')) {
    return 'web-server';
  }
  if (id.contains('chrome')) return 'chrome';
  if (id.contains('edge')) return 'edge';
  return 'other';
}

String _categoryOf(String id, String platform) {
  if (id.contains('headless')) return 'headless';
  return switch (platform) {
    'ios' || 'ipad' || 'android' => 'mobile',
    'macos' || 'windows' || 'linux' => 'desktop',
    'chrome' || 'edge' || 'web-server' => 'web',
    _ => 'other',
  };
}
