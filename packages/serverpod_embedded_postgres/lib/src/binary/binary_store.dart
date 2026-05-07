import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

import '../exceptions.dart';
import 'cache_lock.dart';
import 'maven_url.dart';
import 'zonky_archive.dart';

/// Per-user cache of Zonky PG binaries.
///
/// Conceptually a key/value store from [ZonkyArtifact] -> on-disk install
/// directory. On cache miss [ensure] downloads the JAR from Maven, verifies
/// its SHA-256 against Maven's sidecar, and extracts the inner txz into the
/// install dir.
///
/// Cross-process safe via [CacheLock]: parallel `serverpod_cli start`
/// invocations share the same cache without partial-extract races. Stops
/// short of a full content-addressable store - we trust the published
/// SHA-256 and pin BOMs, so a corrupt cache entry is recoverable by
/// removing the install dir and re-running [ensure].
class BinaryStore {
  /// Cache root, e.g. `~/Library/Caches/serverpod/pg-binaries`.
  /// Each artifact installs under `<cacheRoot>/<bom>/<platform>/`.
  final Directory cacheRoot;

  /// HTTP client used for Maven fetches. Injectable for tests; the default
  /// is a per-store [http.Client] - call [close] to release it.
  final http.Client _http;

  /// Whether [_http] is owned by this store (and should be closed by
  /// [close]) or was injected by the caller (and is the caller's to close).
  final bool _ownsHttp;

  /// Creates a binary store. Defaults to [defaultCacheRoot] for [cacheRoot]
  /// and a fresh [http.Client] when [httpClient] is omitted; pass either
  /// to override (tests typically inject both).
  BinaryStore({Directory? cacheRoot, http.Client? httpClient})
    : cacheRoot = cacheRoot ?? defaultCacheRoot(),
      _http = httpClient ?? http.Client(),
      _ownsHttp = httpClient == null;

  /// Top-level binary cache directory for the current user.
  ///
  ///   - macOS:   `~/Library/Caches/serverpod/pg-binaries`
  ///   - Linux:   `$XDG_CACHE_HOME/serverpod/pg-binaries` (or
  ///              `~/.cache/serverpod/pg-binaries` if XDG_CACHE_HOME unset)
  ///   - Windows: `%LOCALAPPDATA%\serverpod\Cache\pg-binaries`
  static Directory defaultCacheRoot() {
    final env = Platform.environment;

    if (Platform.isMacOS || Platform.isIOS) {
      var home =
          env['HOME'] ??
          (throw StateError('\$HOME is not set; cannot resolve cache root'));
      return Directory(
        p.join(home, 'Library', 'Caches', 'serverpod', 'pg-binaries'),
      );
    }

    if (Platform.isWindows) {
      var local =
          env['LOCALAPPDATA'] ??
          (throw StateError(
            '%LOCALAPPDATA% is not set; cannot resolve cache root',
          ));
      return Directory(p.join(local, 'serverpod', 'Cache', 'pg-binaries'));
    }

    // Linux + everything POSIX-ish.
    var xdg = env['XDG_CACHE_HOME'];
    if (xdg != null && xdg.isNotEmpty) {
      return Directory(p.join(xdg, 'serverpod', 'pg-binaries'));
    }
    var home =
        env['HOME'] ??
        (throw StateError('\$HOME is not set; cannot resolve cache root'));
    return Directory(p.join(home, '.cache', 'serverpod', 'pg-binaries'));
  }

  /// Install dir for [artifact] under this cache root. Read-only by
  /// convention - callers should not write into the returned directory.
  Directory installDirFor(ZonkyArtifact artifact) =>
      Directory(p.join(cacheRoot.path, artifact.bom, artifact.platform));

  /// Path to the manifest written after a successful install. Presence of
  /// this file is the cache-hit predicate for [ensure].
  @visibleForTesting
  File metaFileFor(ZonkyArtifact artifact) =>
      File(p.join(installDirFor(artifact).path, '.meta.json'));

  /// Ensures [artifact] is installed locally and returns its install dir.
  ///
  /// On cache miss this fetches the JAR from Maven, verifies it against
  /// Maven's `.sha256` sidecar, and extracts into a staging dir under the
  /// cache root before atomically renaming into place. The atomic rename
  /// means a partial extract is never observable as a cache hit.
  ///
  /// [onProgress] receives `(fraction, stage)` where `stage` is one of
  /// `'verify'`, `'download'`, or `'extract'`. The `fraction` ramps 0->1
  /// within each stage; the stage label changes at each phase boundary.
  Future<Directory> ensure(
    ZonkyArtifact artifact, {
    void Function(double fraction, String stage)? onProgress,
  }) async {
    var installDir = installDirFor(artifact);
    var meta = metaFileFor(artifact);

    if (meta.existsSync()) {
      return installDir;
    }

    return CacheLock.withLock(cacheRoot, () async {
      // Re-check inside the lock - a concurrent caller may have completed
      // the install between our pre-check and lock acquisition.
      if (meta.existsSync()) {
        return installDir;
      }

      onProgress?.call(0.0, 'verify');
      var expectedSha = await _fetchSha256(artifact);
      onProgress?.call(1.0, 'verify');

      onProgress?.call(0.0, 'download');
      var jarBytes = await _downloadJar(artifact);
      onProgress?.call(1.0, 'download');

      var actualSha = sha256.convert(jarBytes).toString();
      if (actualSha != expectedSha) {
        throw BinaryVerificationException(
          'SHA-256 mismatch for ${artifact.jarFileName}:\n'
          '  expected $expectedSha\n  actual   $actualSha',
        );
      }

      // Stage extract under a sibling temp dir, then atomic rename. Avoids
      // ever leaving a partial install at the canonical path. Single fixed
      // name is safe because we hold the cache lock; any leftover from a
      // crashed prior run is removed up-front.
      var stagingDir = Directory(
        p.join(cacheRoot.path, '${artifact.bom}.${artifact.platform}.staging'),
      );
      if (stagingDir.existsSync()) {
        stagingDir.deleteSync(recursive: true);
      }
      stagingDir.createSync(recursive: true);

      try {
        ZonkyArchive.extractInto(
          jarBytes,
          stagingDir,
          onProgress: onProgress == null
              ? null
              : (f) => onProgress(f, 'extract'),
        );

        // Move into place. Parent dir must exist; sibling at the canonical
        // path (if any from a prior failed install) is removed first.
        installDir.parent.createSync(recursive: true);
        if (installDir.existsSync()) {
          installDir.deleteSync(recursive: true);
        }
        stagingDir.renameSync(installDir.path);

        meta.writeAsStringSync(
          jsonEncode({
            'bom': artifact.bom,
            'platform': artifact.platform,
            'source_url': artifact.jarUrl.toString(),
            'sha256': actualSha,
            'installed_at': DateTime.now().toUtc().toIso8601String(),
          }),
        );
      } catch (_) {
        if (stagingDir.existsSync()) {
          stagingDir.deleteSync(recursive: true);
        }
        rethrow;
      }

      return installDir;
    });
  }

  Future<String> _fetchSha256(ZonkyArtifact artifact) async {
    final resp = await _http.get(artifact.sha256Url);
    if (resp.statusCode != 200) {
      throw BinaryFetchException(
        'GET ${artifact.sha256Url} returned ${resp.statusCode}',
      );
    }
    final body = resp.body.trim();
    final token = body.split(RegExp(r'\s+')).first;
    if (token.length != 64 || !RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(token)) {
      throw BinaryFetchException(
        'Malformed sha256 sidecar from ${artifact.sha256Url}: ${jsonEncode(body)}',
      );
    }
    return token.toLowerCase();
  }

  Future<Uint8List> _downloadJar(ZonkyArtifact artifact) async {
    final resp = await _http.get(artifact.jarUrl);
    if (resp.statusCode != 200) {
      throw BinaryFetchException(
        'GET ${artifact.jarUrl} returned ${resp.statusCode}',
      );
    }
    return resp.bodyBytes;
  }

  /// Releases the underlying HTTP client if it was created by this store.
  /// No-op when an external client was injected via the constructor.
  void close() {
    if (_ownsHttp) _http.close();
  }
}
