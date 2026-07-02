import 'dart:ffi' show Abi;
import 'dart:io';
import 'dart:typed_data';

import 'package:pub_semver/pub_semver.dart';

import '../exceptions.dart';
import 'binary_artifact.dart';
import 'zonky_archive.dart';

/// GitHub `owner/repo` that hosts the Serverpod-built PostgreSQL bundles
/// (PostgreSQL + PostGIS + pgvector, compiled with Zig). Override-able via
/// the `SERVERPOD_PG_BUNDLE_REPO` env var for forks/mirrors.
String get _bundleRepo =>
    Platform.environment['SERVERPOD_PG_BUNDLE_REPO'] ?? 'serverpod/serverpod';

/// Release tag carrying the bundle assets for a given PG version.
String _releaseTag(String bom) => 'embedded-postgres-v$bom';

/// Every `<os>-<arch>` suffix for which a Serverpod bundle is published.
/// Used to validate caller-supplied targets (e.g. `prefetch`) before they
/// turn into a late 404 at download time.
const Set<String> serverpodPlatformSuffixes = {
  'linux-x64',
  'linux-arm64',
  'macos-x64',
  'macos-arm64',
  'windows-x64',
};

/// Maps a Dart [Abi] to the Serverpod bundle's `<os>-<arch>` suffix.
///
/// Matches the artifact naming produced by the builder (`package.sh`).
String serverpodPlatformSuffix(Abi abi) {
  switch (abi) {
    case Abi.linuxX64:
      return 'linux-x64';
    case Abi.linuxArm64:
      return 'linux-arm64';
    case Abi.macosX64:
      return 'macos-x64';
    case Abi.macosArm64:
      return 'macos-arm64';
    case Abi.windowsX64:
      return 'windows-x64';
    default:
      throw UnsupportedPlatformException(
        'No Serverpod PostgreSQL bundle is published for $abi. '
        'Supported: linuxX64, linuxArm64, macosX64, macosArm64, windowsX64.',
      );
  }
}

/// A Serverpod-built PostgreSQL bundle (PostgreSQL + PostGIS + pgvector),
/// distributed as an `.tar.xz` on GitHub Releases. Unlike Zonky's stock
/// binaries, these ship the spatial + vector extensions.
class ServerpodBundleArtifact implements BinaryArtifact {
  /// Major.minor.patch PG version.
  final Version version;

  /// Bundle platform suffix, e.g. `macos-x64`. Use
  /// [ServerpodBundleArtifact.forCurrentPlatform] to derive it from the host.
  @override
  final String platform;

  /// Direct constructor. Most callers should prefer
  /// [ServerpodBundleArtifact.forCurrentPlatform].
  const ServerpodBundleArtifact({
    required this.version,
    required this.platform,
  });

  /// Resolves the artifact for the host's current ABI.
  factory ServerpodBundleArtifact.forCurrentPlatform({
    required Version version,
  }) {
    return ServerpodBundleArtifact(
      version: version,
      platform: serverpodPlatformSuffix(Abi.current()),
    );
  }

  @override
  String get bom => '${version.major}.${version.minor}.${version.patch}';

  @override
  String get archiveFileName => 'serverpod-postgres-$bom-$platform.tar.xz';

  @override
  Uri get archiveUrl => Uri.parse(
    'https://github.com/$_bundleRepo/releases/download/'
    '${_releaseTag(bom)}/$archiveFileName',
  );

  @override
  Uri get sha256Url => Uri.parse('${archiveUrl.toString()}.sha256');

  @override
  void extractInto(
    Uint8List archiveBytes,
    Directory destination, {
    void Function(double fraction)? onProgress,
  }) {
    ZonkyArchive.extractTarXzInto(
      archiveBytes,
      destination,
      onProgress: onProgress,
    );
  }

  @override
  String toString() => 'ServerpodBundleArtifact($archiveFileName)';

  @override
  bool operator ==(Object other) =>
      other is ServerpodBundleArtifact &&
      other.version == version &&
      other.platform == platform;

  @override
  int get hashCode => Object.hash(version, platform);
}
