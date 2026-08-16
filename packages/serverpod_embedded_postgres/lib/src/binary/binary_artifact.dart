import 'dart:io';
import 'dart:typed_data';

/// A downloadable, verifiable PostgreSQL binary bundle.
///
/// [BinaryStore] is generic over this: it keys the per-user cache on
/// ([cacheKey], [platform]), downloads [archiveUrl], verifies the bytes
/// against [sha256Url], and asks the artifact to [extractInto] the install
/// dir. This decouples the cache/concurrency machinery from where the bytes
/// come from (Zonky's Maven JARs vs Serverpod's own GitHub-Releases
/// tarballs).
abstract class BinaryArtifact {
  /// Enables const constructors in subclasses.
  const BinaryArtifact();

  /// Major.minor.patch version.
  String get bom;

  /// Platform suffix, e.g. `macos-x64`. Part of the cache namespace.
  String get platform;

  /// Identity of the artifact's contents within [platform] - the other half
  /// of the cache namespace, also naming claim files and staging dirs, so
  /// artifacts with the same PG version but different contents (e.g. two
  /// bundle revisions) can never collide or satisfy each other's cache
  /// lookups. Defaults to [bom]; override when the contents can change
  /// while [bom] stays the same.
  String get cacheKey => bom;

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

  /// Validates the freshly extracted tree in [installDir] before it is
  /// promoted into the cache, beyond the generic `bin/` shape check. Throw
  /// a `BinaryVerificationException` to reject the tree (nothing is cached).
  /// Default: no extra checks.
  void validateExtracted(Directory installDir) {}
}
