import 'dart:convert';
import 'dart:ffi' show Abi;
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';

import '../exceptions.dart';
import 'binary_artifact.dart';
import 'bundle_spec.dart';
import 'zonky_archive.dart';

/// GitHub `owner/repo` that hosts the Serverpod-built PostgreSQL bundles
/// (PostgreSQL + PostGIS + pgvector, compiled with Zig). Override-able via
/// the `SERVERPOD_PG_BUNDLE_REPO` env var for forks/mirrors.
String get _bundleRepo =>
    Platform.environment['SERVERPOD_PG_BUNDLE_REPO'] ?? 'serverpod/serverpod';

/// Name of the identity manifest at the bundle root. Written by `package.sh`
/// and validated after extraction (see
/// [ServerpodBundleArtifact.validateExtracted]) so a mislabeled or stale
/// archive can never be promoted into the cache.
const String bundleManifestFileName = 'serverpod-bundle-manifest.json';

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
class ServerpodBundleArtifact extends BinaryArtifact {
  /// Full bill of materials: PG version, extension versions, and the bundle
  /// packaging revision.
  final BundleSpec spec;

  /// Bundle platform suffix, e.g. `macos-x64`. Use
  /// [ServerpodBundleArtifact.forCurrentPlatform] to derive it from the host.
  @override
  final String platform;

  /// Direct constructor. Most callers should prefer
  /// [ServerpodBundleArtifact.forCurrentPlatform].
  const ServerpodBundleArtifact({required this.spec, required this.platform});

  /// Resolves the artifact for the host's current ABI.
  factory ServerpodBundleArtifact.forCurrentPlatform({
    required BundleSpec spec,
  }) {
    return ServerpodBundleArtifact(
      spec: spec,
      platform: serverpodPlatformSuffix(Abi.current()),
    );
  }

  /// Major.minor.patch PG version.
  Version get version => spec.postgresVersion;

  @override
  String get bom => spec.bom;

  /// `<bom>-r<revision>`: two revisions of the same PG version are distinct
  /// artifacts with distinct URLs and distinct cache entries, so a bundle
  /// fix always reaches users whose cache holds the previous revision.
  @override
  String get cacheKey => spec.bundleId;

  @override
  String get archiveFileName =>
      'serverpod-postgres-${spec.bundleId}-$platform.tar.xz';

  @override
  Uri get archiveUrl => Uri.parse(
    'https://github.com/$_bundleRepo/releases/download/'
    '${spec.releaseTag}/$archiveFileName',
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

  /// Rejects an extracted tree whose embedded manifest is missing or
  /// disagrees with [spec]/[platform]. This catches mislabeled archives
  /// (right filename, wrong contents) that a SHA-256 sidecar - published
  /// alongside the same wrong archive - cannot.
  @override
  void validateExtracted(Directory installDir) {
    var manifestFile = File(p.join(installDir.path, bundleManifestFileName));
    if (!manifestFile.existsSync()) {
      throw BinaryVerificationException(
        'Bundle $archiveFileName contains no $bundleManifestFileName; '
        'refusing to cache an unidentifiable bundle.',
      );
    }
    Object? decoded;
    try {
      decoded = jsonDecode(manifestFile.readAsStringSync());
    } on FormatException catch (e) {
      throw BinaryVerificationException(
        'Bundle $archiveFileName has a malformed $bundleManifestFileName: '
        '${e.message}',
      );
    }
    if (decoded is! Map<String, Object?>) {
      throw BinaryVerificationException(
        'Bundle $archiveFileName has a malformed $bundleManifestFileName: '
        'expected a JSON object, found ${decoded.runtimeType}.',
      );
    }
    var manifest = decoded;
    var mismatches = <String>[];
    void check(String key, Object expected) {
      var actual = manifest[key];
      if (actual != expected) {
        mismatches.add('$key: expected $expected, found $actual');
      }
    }

    check('postgres', spec.bom);
    check('revision', spec.revision);
    check('platform', platform);
    check('postgis', spec.postgisVersion);
    check('pgvector', spec.pgvectorVersion);
    if (mismatches.isNotEmpty) {
      throw BinaryVerificationException(
        'Bundle manifest of $archiveFileName does not match the requested '
        'artifact:\n  ${mismatches.join('\n  ')}',
      );
    }
  }

  @override
  String toString() => 'ServerpodBundleArtifact($archiveFileName)';

  @override
  bool operator ==(Object other) =>
      other is ServerpodBundleArtifact &&
      other.spec == spec &&
      other.platform == platform;

  @override
  int get hashCode => Object.hash(spec, platform);
}
