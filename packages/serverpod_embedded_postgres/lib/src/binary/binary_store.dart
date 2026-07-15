import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_shared/serverpod_shared.dart' show FileEx;

import '../exceptions.dart';
import 'binary_artifact.dart';
import 'binary_source.dart';
import 'bundle_builder.dart';
import 'serverpod_bundle.dart';

/// Per-user cache of Zonky PG binaries.
///
/// Conceptually a key/value store from [BinaryArtifact] -> on-disk install
/// directory. On cache miss [ensure] downloads the JAR from Maven, verifies
/// its SHA-256 against Maven's sidecar, and extracts the inner txz into the
/// install dir.
///
/// Concurrency model: a per-artifact claim file (`O_CREAT|O_EXCL` via
/// [File.createSync] with `exclusive: true`) elects one extractor. Other
/// callers - whether parallel `serverpod_cli start` invocations across OS
/// processes or parallel test isolates within the same Dart VM - poll for
/// the winner's [metaFileFor] to appear. This is the cross-isolate-correct
/// successor to the original `RandomAccessFile.lock`-based scheme, which
/// failed because `fcntl(F_SETLK)` is per-process and does not serialize
/// isolates that share a process (e.g. `dart test`'s parallel runners).
///
/// If the winner crashes mid-extract its claim sits stale; losers detect
/// this via the claim file's mtime (set atomically by `createSync`) and
/// steal it after [_staleAfter]. A hard ceiling of [_hardTimeout] turns
/// runaway claims into actionable failures rather than CI hangs.
class BinaryStore {
  /// Cache root, e.g. `~/Library/Caches/serverpod/pg-binaries`.
  /// Each artifact installs under `<cacheRoot>/<cacheKey>/<platform>/`.
  final Directory cacheRoot;

  /// HTTP client used for Maven fetches. Injectable for tests; the default
  /// is a per-store [http.Client] - call [close] to release it.
  final http.Client _http;

  /// Whether [_http] is owned by this store (and should be closed by
  /// [close]) or was injected by the caller (and is the caller's to close).
  final bool _ownsHttp;

  /// How long a claim must sit untouched before a waiting loser treats it
  /// as crashed-and-abandoned, deletes it, and re-races for ownership.
  ///
  /// Sized for ~10x a slow CI cold extract (~30s real-world); tightening
  /// this risks false-positive steals on a legitimately-slow winner.
  final Duration _staleAfter;

  /// Upper bound on the total time a loser spends waiting for the winner's
  /// `meta.json`. Past this, [ensure] throws rather than waiting forever
  /// - protects CI from a runaway claim that's neither stale nor making
  /// progress (e.g. a paused debugger).
  final Duration _hardTimeout;

  /// How often a loser stat()s the claim and the meta sentinel. Cheap
  /// enough at 100ms that backoff isn't worth the complexity.
  final Duration _pollInterval;

  /// Creates a binary store. Defaults to [defaultCacheRoot] for [cacheRoot]
  /// and a fresh [http.Client] when [httpClient] is omitted; pass either
  /// to override (tests typically inject both).
  ///
  /// `staleAfter`, `hardTimeout`, and `pollInterval` are tests-only knobs
  /// for exercising stale-claim recovery without sleeping for minutes.
  /// Production callers should leave them at the defaults.
  BinaryStore({
    Directory? cacheRoot,
    http.Client? httpClient,
    Duration staleAfter = const Duration(minutes: 5),
    Duration hardTimeout = const Duration(minutes: 15),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) : cacheRoot = cacheRoot ?? defaultCacheRoot(),
       _http = httpClient ?? http.Client(),
       _ownsHttp = httpClient == null,
       _staleAfter = staleAfter,
       _hardTimeout = hardTimeout,
       _pollInterval = pollInterval;

  /// Top-level binary cache directory for the current user.
  ///
  /// `SERVERPOD_PG_CACHE_DIR`, if set, overrides all of the below - used by CI
  /// to stage the bundle into a fixed, workspace-relative directory so it can
  /// be handed between jobs as an artifact (the per-user defaults differ per
  /// OS, which artifact paths can't express portably).
  ///
  ///   - macOS:   `~/Library/Caches/serverpod/pg-binaries`
  ///   - Linux:   `$XDG_CACHE_HOME/serverpod/pg-binaries` (or
  ///              `~/.cache/serverpod/pg-binaries` if XDG_CACHE_HOME unset)
  ///   - Windows: `%LOCALAPPDATA%\serverpod\Cache\pg-binaries`
  static Directory defaultCacheRoot() {
    final env = Platform.environment;

    var override = env['SERVERPOD_PG_CACHE_DIR'];
    if (override != null && override.isNotEmpty) {
      return Directory(override);
    }

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
  Directory installDirFor(BinaryArtifact artifact) =>
      Directory(p.join(cacheRoot.path, artifact.cacheKey, artifact.platform));

  /// Path to the manifest written after a successful install. Presence of
  /// this file is the cache-hit predicate for [ensure].
  @visibleForTesting
  File metaFileFor(BinaryArtifact artifact) =>
      File(p.join(installDirFor(artifact).path, '.meta.json'));

  /// Per-artifact claim file. Atomic exclusive-create on this path is the
  /// "I'll do the extract" handshake; presence-with-fresh-mtime means
  /// another caller is mid-flight.
  File _claimFileFor(BinaryArtifact artifact) => File(
    p.join(
      cacheRoot.path,
      '${artifact.cacheKey}.${artifact.platform}.claim',
    ),
  );

  /// Ensures [artifact] is installed locally and returns its install dir.
  ///
  /// On cache miss this elects exactly one caller (across processes and
  /// isolates) to fetch the JAR from Maven, verify it against Maven's
  /// `.sha256` sidecar, and extract into a staging dir before atomically
  /// renaming into place. Concurrent callers wait for the winner's
  /// `.meta.json` to appear and then return the same install dir.
  ///
  /// [onProgress] receives `(fraction, stage)` where `stage` is one of
  /// `'download'` or `'extract'`. The `fraction` ramps 0->1 within each
  /// stage; the stage label changes at each phase boundary.
  ///
  /// [source] selects download vs. build-from-source (see [BinarySource]); a
  /// [builder] must be supplied for the build paths. Building is far slower
  /// than a download, so when a build may run the claim stale/timeout windows
  /// are widened to avoid a concurrent isolate stealing the claim mid-build.
  Future<Directory> ensure(
    BinaryArtifact artifact, {
    void Function(double fraction, String stage)? onProgress,
    BinarySource source = BinarySource.download,
    BundleBuilder? builder,
  }) async {
    var installDir = installDirFor(artifact);
    var meta = metaFileFor(artifact);

    if (meta.existsSync()) {
      return installDir;
    }

    var willBuild =
        source == BinarySource.build ||
        (source == BinarySource.auto && builder != null);
    var staleAfter = willBuild && _staleAfter < _buildStaleAfter
        ? _buildStaleAfter
        : _staleAfter;
    var hardTimeout = willBuild && _hardTimeout < _buildHardTimeout
        ? _buildHardTimeout
        : _hardTimeout;

    // Ensure cache root exists; exclusive-create on the claim file can't
    // auto-create parents.
    cacheRoot.createSync(recursive: true);
    var claim = _claimFileFor(artifact);
    var deadline = DateTime.now().add(hardTimeout);

    while (true) {
      try {
        claim.createSync(exclusive: true);
      } on PathExistsException {
        // Someone else is extracting (or crashed mid-extract). Wait for
        // them, or steal a stale claim and retry.
        var outcome = await _awaitOrSteal(claim, meta, deadline, staleAfter);
        switch (outcome) {
          case _LoserOutcome.metaAppeared:
            return installDir;
          case _LoserOutcome.staleStolen:
            continue;
          case _LoserOutcome.timedOut:
            throw BinaryFetchException(
              'Timed out after ${_formatDuration(hardTimeout)} waiting for '
              'another extractor of ${artifact.cacheKey}/${artifact.platform}. '
              'Claim: ${claim.path} (${_describeClaimAge(claim)})',
            );
        }
      }

      try {
        // A previous winner may have completed between our fast-path check
        // and our claim acquisition (e.g. it released its claim, we raced
        // through PathExistsException -> stale-steal -> re-create). Re-check
        // meta before doing the expensive work.
        if (meta.existsSync()) {
          return installDir;
        }
        await _extractAsWinner(
          artifact,
          onProgress: onProgress,
          source: source,
          builder: builder,
        );
        return installDir;
      } finally {
        await claim.deleteIfExists();
      }
    }
  }

  /// Loser branch: poll for the winner's meta to appear, or steal the
  /// claim if it's older than [_staleAfter] (winner presumed crashed).
  Future<_LoserOutcome> _awaitOrSteal(
    File claim,
    File meta,
    DateTime deadline,
    Duration staleAfter,
  ) async {
    while (DateTime.now().isBefore(deadline)) {
      if (meta.existsSync()) return _LoserOutcome.metaAppeared;
      if (_isStale(claim, staleAfter)) {
        // Best-effort delete. If another stealer beat us, our subsequent
        // createSync(exclusive: true) just fails again and we re-poll -
        // exclusive-create remains the only serialization point.
        await claim.deleteIfExists();
        return _LoserOutcome.staleStolen;
      }
      await Future<void>.delayed(_pollInterval);
    }
    return _LoserOutcome.timedOut;
  }

  /// True when the claim is missing or its mtime is older than
  /// [_staleAfter]. Using mtime (set atomically by `createSync(exclusive:
  /// true)`) means a winner that hasn't started extracting yet still has
  /// a fresh-enough timestamp to not be mis-stolen.
  bool _isStale(File claim, Duration staleAfter) {
    var stat = claim.statSync();
    if (stat.type == FileSystemEntityType.notFound) return true;
    return DateTime.now().difference(stat.modified) > staleAfter;
  }

  /// Human-readable claim age for diagnostics. "age 3 s" / "age 2 min" /
  /// `<unstattable>` if even stat fails (unmounted dir, permission flip).
  String _describeClaimAge(File claim) {
    try {
      final age = DateTime.now().difference(claim.statSync().modified);
      return 'age ${_formatDuration(age)}';
    } catch (_) {
      return '<unstattable>';
    }
  }

  Future<void> _extractAsWinner(
    BinaryArtifact artifact, {
    void Function(double fraction, String stage)? onProgress,
    required BinarySource source,
    required BundleBuilder? builder,
  }) async {
    var installDir = installDirFor(artifact);
    var meta = metaFileFor(artifact);

    var (archiveBytes, shaHex, sourceLabel) = await _obtainArchive(
      artifact,
      source: source,
      builder: builder,
      onProgress: onProgress,
    );

    // Per-claimant unique staging dir. Belt-and-suspenders: even though
    // exclusive-create already guarantees a single winner, a unique name
    // means a crashed previous winner's leftover staging can't ever be
    // observed (or stomped) by us. Orphans on crash are acceptable -
    // user-scoped cache, small footprint.
    var stagingDir = Directory(
      p.join(
        cacheRoot.path,
        '${artifact.cacheKey}.${artifact.platform}.staging.$pid.${_randomTag()}',
      ),
    );
    stagingDir.createSync(recursive: true);

    try {
      artifact.extractInto(
        archiveBytes,
        stagingDir,
        onProgress: onProgress == null ? null : (f) => onProgress(f, 'extract'),
      );

      // Sanity-check the extracted shape before caching it: a mis-shaped
      // archive (whose sha256 sidecar still matched) would otherwise poison
      // the cache and surface much later as "postgres not found" at start().
      if (!Directory(p.join(stagingDir.path, 'bin')).existsSync()) {
        throw BinaryVerificationException(
          'Extracted bundle ${artifact.archiveFileName} has no bin/ directory; '
          'expected a postgres install tree at the archive root.',
        );
      }

      // Artifact-specific identity check (e.g. the Serverpod bundle's
      // embedded manifest) - a mislabeled archive must never be promoted
      // into the cache, where it would satisfy every future lookup.
      artifact.validateExtracted(stagingDir);

      // Move into place. Parent must exist; any prior install at the
      // canonical path is removed first (we hold the claim, so this is
      // safe - no concurrent reader could be inside it).
      installDir.parent.createSync(recursive: true);
      if (installDir.existsSync()) {
        installDir.deleteSync(recursive: true);
      }
      stagingDir.renameSync(installDir.path);

      meta.writeAsStringSync(
        jsonEncode({
          'bom': artifact.bom,
          'bundle_id': artifact.cacheKey,
          'platform': artifact.platform,
          'source_url': sourceLabel,
          'sha256': shaHex,
          'installed_at': DateTime.now().toUtc().toIso8601String(),
        }),
      );
    } catch (_) {
      if (stagingDir.existsSync()) {
        stagingDir.deleteSync(recursive: true);
      }
      rethrow;
    }
  }

  /// Obtains the archive bytes for [source], returning
  /// `(bytes, sha256-hex, source-label)`. Download verifies the bytes against
  /// the sidecar; build trusts the freshly-built artifact (records a computed
  /// digest for the meta).
  Future<(Uint8List, String, String)> _obtainArchive(
    BinaryArtifact artifact, {
    required BinarySource source,
    required BundleBuilder? builder,
    void Function(double fraction, String stage)? onProgress,
  }) async {
    switch (source) {
      case BinarySource.build:
        return _buildArchive(artifact, builder, onProgress);
      case BinarySource.download:
        return _downloadVerified(artifact, onProgress);
      case BinarySource.auto:
        try {
          return await _downloadVerified(artifact, onProgress);
        } on BinaryFetchException catch (e) {
          // Fall back to a local build only when the prebuilt bundle is
          // definitively absent (404) and a builder is available - never on a
          // transient network error.
          if (builder != null && e.statusCode == 404) {
            return _buildArchive(artifact, builder, onProgress);
          }
          rethrow;
        }
    }
  }

  Future<(Uint8List, String, String)> _downloadVerified(
    BinaryArtifact artifact,
    void Function(double fraction, String stage)? onProgress,
  ) async {
    // SHA and archive are independent fetches; run them in parallel to save one
    // RTT. The progress callback fires once each completes.
    onProgress?.call(0.0, 'download');
    var fetches = await Future.wait([
      _fetchSha256(artifact),
      _downloadArchive(artifact),
    ]);
    onProgress?.call(1.0, 'download');
    var expectedSha = fetches[0] as String;
    var bytes = fetches[1] as Uint8List;
    var actualSha = sha256.convert(bytes).toString();
    if (actualSha != expectedSha) {
      throw BinaryVerificationException(
        'SHA-256 mismatch for ${artifact.archiveFileName}:\n'
        '  expected $expectedSha\n  actual   $actualSha',
      );
    }
    return (bytes, actualSha, artifact.archiveUrl.toString());
  }

  Future<(Uint8List, String, String)> _buildArchive(
    BinaryArtifact artifact,
    BundleBuilder? builder,
    void Function(double fraction, String stage)? onProgress,
  ) async {
    if (builder == null) {
      throw BinaryBuildException(
        'no builder available to build ${artifact.archiveFileName}.',
      );
    }
    if (artifact is! ServerpodBundleArtifact) {
      throw BinaryBuildException(
        'only Serverpod bundles can be built from source; '
        '${artifact.archiveFileName} is download-only.',
      );
    }
    onProgress?.call(0.0, 'build');
    var file = await builder.build(
      spec: artifact.spec,
      platform: artifact.platform,
    );
    var bytes = await file.readAsBytes();
    try {
      await file.parent.delete(recursive: true);
    } catch (_) {} // Best effort.

    onProgress?.call(1.0, 'build');
    return (
      bytes,
      sha256.convert(bytes).toString(),
      'local-build:${file.path}',
    );
  }

  Future<String> _fetchSha256(BinaryArtifact artifact) async {
    final resp = await _http
        .get(artifact.sha256Url)
        .timeout(
          _sha256Timeout,
          onTimeout: () => throw BinaryFetchException(
            'Timed out after ${_sha256Timeout.inSeconds}s fetching '
            '${artifact.sha256Url}',
          ),
        );
    if (resp.statusCode != 200) {
      throw BinaryFetchException(
        'GET ${artifact.sha256Url} returned ${resp.statusCode}',
        statusCode: resp.statusCode,
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

  Future<Uint8List> _downloadArchive(BinaryArtifact artifact) async {
    final resp = await _http
        .get(artifact.archiveUrl)
        .timeout(
          _jarTimeout,
          onTimeout: () => throw BinaryFetchException(
            'Timed out after ${_jarTimeout.inMinutes} min downloading '
            '${artifact.archiveUrl}',
          ),
        );
    if (resp.statusCode != 200) {
      throw BinaryFetchException(
        'GET ${artifact.archiveUrl} returned ${resp.statusCode}',
        statusCode: resp.statusCode,
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

/// 8 hex chars from a non-secure RNG. Only needs to be unique among
/// concurrent claimants of the same cache root - pid already disambiguates
/// across processes, so this just disambiguates within a single process's
/// hypothetical re-entrant claims (which shouldn't happen, but defensive).
final _random = math.Random();
String _randomTag() =>
    _random.nextInt(1 << 32).toRadixString(16).padLeft(8, '0');

/// Renders a duration with the largest sensible unit. Avoids the
/// `Duration.inMinutes` truncation that would print "0 min" for a
/// sub-minute test timeout.
String _formatDuration(Duration d) {
  if (d.inMinutes >= 1) return '${d.inMinutes} min';
  if (d.inSeconds >= 1) return '${d.inSeconds} s';
  return '${d.inMilliseconds} ms';
}

enum _LoserOutcome { metaAppeared, staleStolen, timedOut }

/// Cap on the SHA-256 sidecar fetch (~80 bytes over HTTPS). Generous so
/// transient mirror latency doesn't fail an otherwise-healthy fetch.
const Duration _sha256Timeout = Duration(seconds: 60);

/// Cap on the JAR download (~200 MB cold). Sized for a slow Maven mirror
/// over a constrained CI connection - tighter risks false-positive
/// failures on legitimately-slow networks; looser defeats the point of
/// adding the timeout at all.
const Duration _jarTimeout = Duration(minutes: 5);

/// Claim stale/hard-timeout windows used when a from-source build may run.
/// A build is far slower than a download (minutes), so widen these so a
/// concurrent isolate doesn't treat the building winner as crashed and steal
/// the claim mid-build (which would double-build).
const Duration _buildStaleAfter = Duration(minutes: 20);
const Duration _buildHardTimeout = Duration(minutes: 45);
