import 'dart:io';
import 'dart:typed_data';

/// A downloadable, verifiable PostgreSQL binary bundle.
///
/// [BinaryStore] is generic over this: it keys the per-user cache on
/// ([bom], [platform]), downloads [archiveUrl], verifies the bytes against
/// [sha256Url], and asks the artifact to [extractInto] the install dir. This
/// decouples the cache/concurrency machinery from where the bytes come from
/// (Zonky's Maven JARs vs Serverpod's own GitHub-Releases tarballs).
abstract class BinaryArtifact {
  /// Major.minor.patch version. Part of the cache namespace.
  String get bom;

  /// Platform suffix, e.g. `macos-x64`. Part of the cache namespace.
  String get platform;

  /// URL of the archive to download.
  Uri get archiveUrl;

  /// URL of the `.sha256` sidecar (hex digest of the archive bytes).
  Uri get sha256Url;

  /// Archive filename. Diagnostics + the SHA-mismatch message; some
  /// implementations also build [archiveUrl] from it, so it is not purely
  /// cosmetic.
  String get archiveFileName;

  /// Extracts the (already SHA-256-verified) [archiveBytes] into
  /// [destination]. [onProgress] receives a 0.0..1.0 fraction.
  void extractInto(
    Uint8List archiveBytes,
    Directory destination, {
    void Function(double fraction)? onProgress,
  });
}
