import 'dart:ffi' show Abi;
import 'dart:io';
import 'dart:typed_data';

import 'package:pub_semver/pub_semver.dart';

import '../exceptions.dart';
import 'binary_artifact.dart';
import 'zonky_archive.dart';

/// Base URL of Zonky's Maven Central group.
///
/// `<base>/<artifact>/<bom>/<artifact>-<bom>.jar` is the canonical artifact
/// URL.
const String mavenZonkyBaseUrl =
    'https://repo1.maven.org/maven2/io/zonky/test/postgres';

/// Maps a Dart [Abi] to Zonky's `<platform>-<arch>` artifact suffix.
///
/// Throws [UnsupportedPlatformException] for tuples not covered by Zonky's
/// distribution.
String platformSuffixForAbi(Abi abi) {
  switch (abi) {
    case Abi.linuxX64:
      return 'linux-amd64';
    case Abi.linuxArm64:
      return 'linux-arm64v8';
    case Abi.macosX64:
      return 'darwin-amd64';
    case Abi.macosArm64:
      return 'darwin-arm64v8';
    case Abi.windowsX64:
      return 'windows-amd64';
    default:
      throw UnsupportedPlatformException(
        'Zonky does not publish binaries for $abi. '
        'Supported: linuxX64, linuxArm64, macosX64, macosArm64, windowsX64.',
      );
  }
}

/// A single Zonky binary artifact, identified by PG version + platform.
///
/// Combines the inputs needed to fetch the JAR and verify it. Stateless;
/// safe to share across calls.
class ZonkyArtifact extends BinaryArtifact {
  /// Major.minor.patch PG version (Zonky calls this the "BOM").
  final Version version;

  /// Platform suffix in Zonky's naming, e.g. `darwin-amd64`,
  /// `linux-arm64v8`. Use [ZonkyArtifact.forCurrentPlatform] to derive this
  /// from [Abi.current].
  @override
  final String platform;

  /// Direct constructor. Most callers should prefer
  /// [ZonkyArtifact.forCurrentPlatform].
  const ZonkyArtifact({required this.version, required this.platform});

  /// Resolves the artifact for the host's current ABI.
  factory ZonkyArtifact.forCurrentPlatform({required Version version}) {
    return ZonkyArtifact(
      version: version,
      platform: platformSuffixForAbi(Abi.current()),
    );
  }

  /// Maven BOM, e.g. `16.13.0`.
  @override
  String get bom => '${version.major}.${version.minor}.${version.patch}';

  /// Maven artifact ID, e.g. `embedded-postgres-binaries-darwin-amd64`.
  String get artifactId => 'embedded-postgres-binaries-$platform';

  /// JAR filename Maven serves, e.g.
  /// `embedded-postgres-binaries-darwin-amd64-16.13.0.jar`.
  String get jarFileName => '$artifactId-$bom.jar';

  /// Full URL to the JAR on Maven Central.
  Uri get jarUrl =>
      Uri.parse('$mavenZonkyBaseUrl/$artifactId/$bom/$jarFileName');

  /// Full URL to the JAR's `.sha256` sidecar on Maven Central.
  @override
  Uri get sha256Url => Uri.parse('${jarUrl.toString()}.sha256');

  @override
  Uri get archiveUrl => jarUrl;

  @override
  String get archiveFileName => jarFileName;

  @override
  void extractInto(
    Uint8List archiveBytes,
    Directory destination, {
    void Function(double fraction)? onProgress,
  }) {
    ZonkyArchive.extractInto(archiveBytes, destination, onProgress: onProgress);
  }

  @override
  String toString() => '$artifactId@$bom';

  @override
  bool operator ==(Object other) =>
      other is ZonkyArtifact &&
      other.version == version &&
      other.platform == platform;

  @override
  int get hashCode => Object.hash(version, platform);
}
